import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:tasky/Core/Networking/api_constants.dart';
import 'package:tasky/Core/Networking/api_service.dart';
import 'package:tasky/Features/Taskes/Data/Model/task_model.dart';

class TaskApisService extends BaseApiService {
  TaskApisService(super.dio);
  Future<void> logout() async {
    return await post(ApiConstants.apiBaseUrl + ApiConstants.logoutrUrl);
  }

  Future tasksList(int pageNum) async {
    return get(
        "${ApiConstants.apiBaseUrl}${ApiConstants.taskesPaginationUrl}$pageNum");
  }

  Future<TaskModel> getOneTask(String taskId) async {
    final response = await get(
        '${ApiConstants.apiBaseUrl}${ApiConstants.taskesrUrl}/$taskId');
    return TaskModel.fromJson(response);
  }

  Future<void> addTask(AddTaskModel task) async {
    return await post(ApiConstants.apiBaseUrl + ApiConstants.taskesrUrl,
        data: task.toJson());
  }

  Future<void> editTask(TaskModel task) async {
    return await put(
        '${ApiConstants.apiBaseUrl}${ApiConstants.taskesrUrl}/${task.id}',
        data: task.toJson());
  }

  Future<void> deleteTask(String taskId) async {
    return await delete(
        '${ApiConstants.apiBaseUrl}${ApiConstants.taskesrUrl}/$taskId');
  }

  Future<dynamic> uploadImage(String imagePath) async {
    final fileExtension = imagePath.split('.').last.toLowerCase();
    final formData = FormData.fromMap({
      'image': [
        await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
          contentType: MediaType('image', fileExtension),
        )
      ],
    });

    return post(ApiConstants.apiBaseUrl + ApiConstants.uploadImage,
        data: formData);
  }
}
