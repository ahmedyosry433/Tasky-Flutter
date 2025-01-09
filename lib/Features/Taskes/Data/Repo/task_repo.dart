import 'package:tasky/Features/Taskes/Data/Apis/task_apis_service.dart';
import 'package:tasky/Features/Taskes/Data/Model/task_model.dart';

class TaskRepo {
  final TaskApisService _taskApisService;
  TaskRepo(this._taskApisService);

  Future logoutRepo() {
    return _taskApisService.logout();
  }

  Future tasksListRepo({required int pageNum}) {
    return _taskApisService.tasksList(pageNum);
  }

  Future deleteTaskRepo({required String taskID}) {
    return _taskApisService.deleteTask(taskID);
  }

  Future getOneTaskRepo({required String taskID}) {
    return _taskApisService.getOneTask(taskID);
  }

  Future editTaskRepo({required TaskModel task}) {
    return _taskApisService.editTask(task);
  }

  Future addTaskRepo({required AddTaskModel task}) {
    return _taskApisService.addTask(task);
  }

  Future uploadImageRepo({required String ImagePath}) {
    return _taskApisService.uploadImage(ImagePath);
  }
}
