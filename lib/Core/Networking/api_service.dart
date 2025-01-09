// ignore_for_file: avoid_print, prefer_final_fields, unused_import, unused_field

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:tasky/Core/Networking/api_constants.dart';
import 'package:tasky/Core/Networking/dio_factory.dart';
import 'package:tasky/Features/Login/Data/Model/login_model.dart';
import 'package:tasky/Features/Register/Data/Model/register_model.dart';
import 'package:tasky/Features/Taskes/Data/Model/task_model.dart';
import '../Helper/shared_preferences_helper.dart';
import 'package:http/http.dart' as http;

class BaseApiService {
  final Dio _dio;

  BaseApiService(this._dio);

  Future<dynamic> get(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: params);
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _refreshToken();
        return get(endpoint, params: params);
      }
      rethrow;
    }
  }

  Future<dynamic> post(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _refreshToken();
        return post(endpoint, data: data);
      }
      rethrow;
    }
  }

  Future<dynamic> put(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _refreshToken();
        return put(endpoint, data: data);
      }
      rethrow;
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _refreshToken();
        return delete(endpoint);
      }
      rethrow;
    }
  }

  Future<String> getRefreshToken() async {
    return await SharedPreferencesHelper.getSecuredString('reftoken');
  }

  Future _refreshToken() async {
    Response response = await _dio.request(
        "${ApiConstants.apiBaseUrl}${ApiConstants.refreshToken}${await getRefreshToken()}",
        options: Options(
          method: 'GET',
        ));
    await SharedPreferencesHelper.setSecuredString(
        "token", "${response.data["access_token"]}");

    DioFactory.setTokenAfterLogin(response.data["access_token"]);

    return response;
  }
}
