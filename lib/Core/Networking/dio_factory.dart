import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:tasky/Core/Helper/constants.dart';
import 'package:tasky/Core/Helper/shared_preferences_helper.dart';
import 'package:tasky/Core/Networking/api_constants.dart';

class DioFactory {
  DioFactory._();

  static Dio? _dio;

  static Dio getDio() {
    Duration timeOut = const Duration(seconds: 30);
    if (_dio == null) {
      _dio = Dio();
      _dio!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;
      _addDioInterceptors();
    }
    return _dio!;
  }

  static void _addDioInterceptors() {
    _dio?.interceptors.add(PrettyDioLogger(
      requestBody: true,
      requestHeader: true,
      responseHeader: true,
    ));
    _dio?.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await SharedPreferencesHelper.getSecuredString(
            AppConstants.accessToken);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          final success = await _handleTokenRefresh();
          if (success) {
            final newToken = await SharedPreferencesHelper.getSecuredString(
                AppConstants.accessToken);
            if (newToken != null) {
              error.requestOptions.headers['Authorization'] =
                  'Bearer $newToken';
              final retryResponse = await _dio?.fetch(error.requestOptions);
              handler.resolve(retryResponse!);
              return;
            }
          }
        }
        handler.next(error);
      },
    ));
  }

  static Future<bool> _handleTokenRefresh() async {
    try {
      final refreshToken = await SharedPreferencesHelper.getSecuredString(
          AppConstants.refreshToken);
      if (refreshToken == null) return false;

      final response = await _dio?.get(
        '${ApiConstants.apiBaseUrl}${ApiConstants.refreshToken}$refreshToken',
      );

      if (response?.statusCode == 200) {
        final newAccessToken = response?.data['access_token'];
        if (newAccessToken != null) {
          await SharedPreferencesHelper.setSecuredString(
              AppConstants.accessToken, newAccessToken);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
