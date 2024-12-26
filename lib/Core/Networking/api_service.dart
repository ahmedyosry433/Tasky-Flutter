// ignore_for_file: avoid_print, prefer_final_fields, unused_import, unused_field

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../helper/shared_preferences_helper.dart';

class ApiService {
  final Dio _dio;
  ApiService(this._dio);
}
