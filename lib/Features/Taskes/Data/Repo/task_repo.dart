import 'package:tasky/Core/Networking/api_service.dart';
import 'package:tasky/Features/Taskes/Data/Model/task_model.dart';

class TaskRepo {
  final ApiService _api_service;
  TaskRepo(this._api_service);

  Future logoutRepo() {
    return _api_service.logout();
  }

  Future<List<TaskModel>> tasksListRepo() {
    return _api_service.tasksList();
  }
}
