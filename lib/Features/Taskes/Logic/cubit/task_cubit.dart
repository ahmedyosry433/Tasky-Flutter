import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:tasky/Features/Taskes/Data/Model/task_model.dart';
import 'package:tasky/Features/Taskes/Data/Repo/task_repo.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepo _taskRepo;
  TaskCubit(this._taskRepo) : super(TaskInitial());

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  String? selectedPriority = 'low';
  File? imagePickedUrl;
  DateTime? dueDate;

  List<TaskModel> tasksList = [];
  List<TaskModel> allTasks = [];
  TaskModel? oneTask;

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
            .where((task) => task.status.toLowerCase() == status.toLowerCase())
            .toList();
      }

      emit(TaskSuccess());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  void getOneTaskCubit({required String taskId}) async {
    emit(OneTaskLoading());
    try {
      TaskModel res = await _taskRepo.getOneTaskRepo(taskID: taskId);
      oneTask = res;
      emit(OneTaskSuccess(res));
    } catch (e) {
      emit(OneTaskError(e.toString()));
    }
  }

  void deleteTaskCubit({required String taskId}) async {
    emit(DeleteTaskLoading());
    try {
      await _taskRepo.deleteTaskRepo(taskID: taskId);
      emit(DeleteTaskSuccess());
    } catch (e) {
      emit(DeleteTaskError(e.toString()));
    }
  }

  void editTaskCubit({required TaskModel task}) async {
    emit(EditTaskLoading());
    try {
      await _taskRepo.editTaskRepo(task: task);
      emit(EditTaskSuccess());
    } catch (e) {
      emit(EditTaskError(e.toString()));
    }
  }

  void addTaskCubit() async {
    emit(AddTaskLoading());
    try {
      await _taskRepo.addTaskRepo(
        task: AddTaskModel(
            image: imagePickedUrl!.path,
            title: titleController.text,
            desc: descController.text,
            priority: selectedPriority!,
            dueDate: DateFormat('yyyy - M - d').format(dueDate!).toString()),
      );

      emit(AddTaskSuccess());
    } catch (e) {
      print("____________Error: " + e.toString());
      emit(AddTaskError(e.toString()));
    }
  }
}
