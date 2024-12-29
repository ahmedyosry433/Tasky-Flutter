import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tasky/Features/Taskes/Data/Model/task_model.dart';
import 'package:tasky/Features/Taskes/Data/Repo/task_repo.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepo _taskRepo;
  TaskCubit(this._taskRepo) : super(TaskInitial());

  List<TaskModel> tasksList = [];
  List<TaskModel> allTasks = [];

  void logoutCubit() async {
    emit(LogoutLoading());
    try {
      await _taskRepo.logoutRepo();
      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutError(e.toString()));
    }
  }

  void tasksListCubit() async {
    emit(TaskLoading());
    try {
      var tasks = await _taskRepo.tasksListRepo();
      allTasks = tasks;
      tasksList = tasks;

      emit(TaskSuccess());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  void filterTasksByStatus(String status) async {
    emit(TaskLoading());
    try {
      if (status == "All" || status == "all") {
        // tasksList.clear();
        tasksList = allTasks;
      } else {
        tasksList = allTasks
            .where((task) =>
                task.status == status || task.status == status.toLowerCase())
            .toList();
      }

      emit(TaskSuccess());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  void deleteTaskCubit({required String taskId}) async {
    emit(DeleteTaskLoading());
    try {
      var res = await _taskRepo.deleteTaskRepo(taskID: taskId);
      print("DELETE DONE : ${res.title}");
      emit(DeleteTaskSuccess());
    } catch (e) {
      print("Error Delete: " + e.toString());
      emit(DeleteTaskError(e.toString()));
    }
  }
}
