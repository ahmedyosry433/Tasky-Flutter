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
    final response = await _dio.get('${ApiConstants.apiBaseUrl}$endpoint', queryParameters: params);
    return response.data;
  }

  Future<dynamic> post(String endpoint, {dynamic data}) async {
    final response = await _dio.post('${ApiConstants.apiBaseUrl}$endpoint', data: data);
    return response.data;
  }

  Future<dynamic> put(String endpoint, {dynamic data}) async {
    final response = await _dio.put('${ApiConstants.apiBaseUrl}$endpoint', data: data);
    return response.data;
  }

  Future<dynamic> delete(String endpoint) async {
    final response = await _dio.delete('${ApiConstants.apiBaseUrl}$endpoint');
    return response.data;
  }

 
}
