// ignore_for_file: avoid_print, prefer_final_fields, unused_import, unused_field

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:tasky/Core/Networking/api_constants.dart';
import 'package:tasky/Features/Login/Data/Model/login_model.dart';
import 'package:tasky/Features/Register/Data/Model/register_model.dart';
import '../Helper/shared_preferences_helper.dart';

class ApiService {
  final Dio _dio;
  ApiService(this._dio);

  Future register({required UserModel registerModel}) async {
    var headers = {
      'Content-Type': 'application/json',
    };
    Response response =
        await _dio.request(ApiConstants.apiBaseUrl + ApiConstants.registerUrl,
            data: registerModel,
            options: Options(
              headers: headers,
              method: 'POST',
            ));
    return response.data;
  }

  Future login({required LoginModel loginModel}) async {
    var headers = {
      'Content-Type': 'application/json',
    };
    Response response =
        await _dio.request(ApiConstants.apiBaseUrl + ApiConstants.loginrUrl,
            data: loginModel,
            options: Options(
              headers: headers,
              method: 'POST',
            ));
    return response.data;
  }

  Future profile({required String token}) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    Response response =
        await _dio.request(ApiConstants.apiBaseUrl + ApiConstants.profilerUrl,
            options: Options(
              headers: headers,
              method: 'GET',
            ));
    return response.data;
  }
}
