import 'package:tasky/Core/Networking/api_service.dart';
import 'package:tasky/Features/Taskes/Data/Model/task_model.dart';

class TaskRepo {
  final ApiService _api_service;
  TaskRepo(this._api_service);

  Future logoutRepo() {
    return _api_service.logout();
  }

  Future tasksListRepo() {
    return _api_service.tasksList();
  }

  Future deleteTaskRepo({required String taskID}) {
    return _api_service.deleteTask(taskID: taskID);
  }

  Future getOneTaskRepo({required String taskID}) {
    return _api_service.getOneTask(taskID: taskID);
  }

  Future editTaskRepo({required TaskModel task}) {
    return _api_service.editTask(task: task);
  }

  Future addTaskRepo({required AddTaskModel task}) {
    return _api_service.addTask(addTask: task);
  }

  Future uploadImageRepo({required String ImagePath}) {
    return _api_service.uploadImage(imagePath: ImagePath);
  }

  Future refreshTokenRepo() {
    return _api_service.refreshToken();
  }
}
