// ignore_for_file: avoid_print, prefer_final_fields, unused_import, unused_field

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:tasky/Core/Networking/api_constants.dart';
import 'package:tasky/Features/Login/Data/Model/login_model.dart';
import 'package:tasky/Features/Register/Data/Model/register_model.dart';
import 'package:tasky/Features/Taskes/Data/Model/task_model.dart';
import '../Helper/shared_preferences_helper.dart';

class ApiService {
  final Dio _dio;
  ApiService(this._dio);
  Future<String> getToken() async {
    return await SharedPreferencesHelper.getValueForKey('token');
  }

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

  Future profile() async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await getToken()}',
    };
    Response response =
        await _dio.request(ApiConstants.apiBaseUrl + ApiConstants.profilerUrl,
            options: Options(
              headers: headers,
              method: 'GET',
            ));
    return response.data;
  }

  Future logout() async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await getToken()}',
    };
    Response response =
        await _dio.request(ApiConstants.apiBaseUrl + ApiConstants.logoutrUrl,
            options: Options(
              headers: headers,
              method: 'POST',
            ));
    return response.data;
  }

  Future<List<TaskModel>> tasksList() async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await getToken()}',
    };
    Response response =
        await _dio.request(ApiConstants.apiBaseUrl + ApiConstants.taskesrUrl,
            options: Options(
              headers: headers,
              method: 'GET',
            ));
    List<TaskModel> tasksList = [];
    for (var task in response.data) {
      tasksList.add(TaskModel.fromJson(task));
    }
    return tasksList;
  }

  Future<TaskModel> deleteTask({required String taskID}) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await getToken()}',
    };
    Response response = await _dio.request(
        "${ApiConstants.apiBaseUrl}${ApiConstants.taskesrUrl}/$taskID",
        options: Options(
          headers: headers,
          method: 'DELETE',
        ));
    return TaskModel.fromJson(response.data);
  }

  Future<TaskModel> getOneTask({required String taskID}) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await getToken()}',
    };
    Response response = await _dio.request(
        "${ApiConstants.apiBaseUrl}${ApiConstants.taskesrUrl}/$taskID",
        options: Options(
          headers: headers,
          method: 'GET',
        ));
    return TaskModel.fromJson(response.data);
  }

  Future<TaskModel> editTask({required TaskModel task}) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await getToken()}',
    };
    Response response = await _dio.request(
        "${ApiConstants.apiBaseUrl}${ApiConstants.taskesrUrl}/${task.id}",
        data: task,
        options: Options(
          headers: headers,
          method: 'PUT',
        ));
    return TaskModel.fromJson(response.data);
  }

  Future addTask({required AddTaskModel addTask}) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await getToken()}',
    };
    await _dio.request("${ApiConstants.apiBaseUrl}${ApiConstants.taskesrUrl}",
        data: addTask,
        options: Options(
          headers: headers,
          method: 'POST',
        ));
    ;
  }
}
