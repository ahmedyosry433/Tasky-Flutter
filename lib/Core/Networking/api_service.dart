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

class ApiService {
  final Dio _dio;
  ApiService(this._dio);

  Future<String> getRefreshToken() async {
    return await SharedPreferencesHelper.getValueForKey('reftoken');
  }

  Future register({required UserModel registerModel}) async {
    Response response =
        await _dio.request(ApiConstants.apiBaseUrl + ApiConstants.registerUrl,
            data: registerModel,
            options: Options(
              method: 'POST',
            ));
    return response.data;
  }

  Future login({required LoginModel loginModel}) async {
    Response response =
        await _dio.request(ApiConstants.apiBaseUrl + ApiConstants.loginrUrl,
            data: loginModel,
            options: Options(
              method: 'POST',
            ));
    return response.data;
  }

  Future refreshToken() async {
    Response response = await _dio.request(
        "${ApiConstants.apiBaseUrl}${ApiConstants.refreshToken}${await getRefreshToken()}",
        options: Options(
          method: 'GET',
        ));
    await SharedPreferencesHelper.setValueForKey(
        "token", "${response.data["access_token"]}");
    DioFactory.setTokenAfterLogin(response.data["access_token"]);

    return response;
  }

  Future profile() async {
    try {
      Response response = await _dio.request(
        ApiConstants.apiBaseUrl + ApiConstants.profilerUrl,
        options: Options(
          method: 'GET',
        ),
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response!.statusCode == 401) {
        await refreshToken();

        return profile;
      }
    }
  }

  Future logout() async {
    try {
      Response response =
          await _dio.request(ApiConstants.apiBaseUrl + ApiConstants.logoutrUrl,
              options: Options(
                method: 'POST',
              ));

      return response;
    } on DioException catch (e) {
      if (e.response!.statusCode == 401) {
        await refreshToken();
        return logout();
      }
    }
  }

  Future tasksList({required int pageNum}) async {
    try {
      Response response = await _dio.request(
          "${ApiConstants.apiBaseUrl}${ApiConstants.taskesPaginationUrl}$pageNum",
          options: Options(
            method: 'GET',
          ));

      return response;
    } on DioException catch (e) {
      if (e.response!.statusCode == 401) {
        await refreshToken();
        return tasksList(pageNum: pageNum);
      }
    }
  }

  Future deleteTask({required String taskID}) async {
    try {
      Response response = await _dio.request(
          "${ApiConstants.apiBaseUrl}${ApiConstants.taskesrUrl}/$taskID",
          options: Options(
            method: 'DELETE',
          ));

      return response;
    } on DioException catch (e) {
      if (e.response!.statusCode == 401) {
        await refreshToken();
        return deleteTask(taskID: taskID);
      }
    }
  }

  Future getOneTask({required String taskID}) async {
    try {
      Response response = await _dio.request(
          "${ApiConstants.apiBaseUrl}${ApiConstants.taskesrUrl}/$taskID",
          options: Options(
            method: 'GET',
          ));

      return TaskModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 401) {
        await refreshToken();
        return getOneTask(taskID: taskID);
      }
    }

    return getOneTask(taskID: taskID);
  }

  Future editTask({required TaskModel task}) async {
    try {
      Response response = await _dio.request(
          "${ApiConstants.apiBaseUrl}${ApiConstants.taskesrUrl}/${task.id}",
          data: task,
          options: Options(
            method: 'PUT',
          ));

      return response;
    } on DioException catch (e) {
      if (e.response!.statusCode == 401) {
        await refreshToken();
        return editTask(task: task);
      }
    }
  }

  Future addTask({required AddTaskModel addTask}) async {
    try {
      var response = await _dio.request(
          "${ApiConstants.apiBaseUrl}${ApiConstants.taskesrUrl}",
          data: addTask,
          options: Options(
            method: 'POST',
          ));
      return response;
    } on DioException catch (e) {
      if (e.response!.statusCode == 401) {
        await refreshToken();
        return addTask;
      }
    }
  }

  Future uploadImage({required String imagePath}) async {
    try {
      final fileExtension = imagePath.split('.').last.toLowerCase();

      var data = FormData.fromMap({
        'image': [
          await MultipartFile.fromFile(
            imagePath,
            filename: imagePath.split('/').last,
            contentType: MediaType('image', fileExtension),
          )
        ],
      });

      var response = await _dio.request(
        '${ApiConstants.apiBaseUrl}${ApiConstants.uploadImage}',
        options: Options(
          method: 'POST',
        ),
        data: data,
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response!.statusCode == 401) {
        await refreshToken();
        return uploadImage(imagePath: imagePath);
      }
    }
  }
}
