import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:tasky/Core/Helper/shared_preferences_helper.dart';
import 'package:tasky/Features/Taskes/Data/Model/task_model.dart';
import 'package:tasky/Features/Taskes/Data/Repo/task_repo.dart';
import 'package:image/image.dart' as img;

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepo _taskRepo;
  TaskCubit(this._taskRepo) : super(TaskInitial());

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  String? selectedPriority = 'low';
  File? imagePickedUrl;
  File? addImagePickedUrl;
  File? compressedImagePickedUrl;
  DateTime? dueDate;

  List<TaskModel> tasksList = [];
  List<TaskModel> newTasksList = [];
  List<TaskModel> allTasks = [];

  TaskModel? oneTask;
  String? addImageUploadedName;
  String? editImageUploadedName;

  void logoutCubit() async {
    emit(LogoutLoading());
    try {
      await _taskRepo.logoutRepo();
      await SharedPreferencesHelper.removeAllKeysSecured();
      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutError(e.toString()));
    }
  }

  void tasksListCubit({required int pageNum}) async {
    emit(TaskLoading());
    try {
      newTasksList.clear();
      var res = await _taskRepo.tasksListRepo(pageNum: pageNum);
      for (var task in res) {
        newTasksList.add(TaskModel.fromJson(task));
        allTasks.add(TaskModel.fromJson(task));
      }
      tasksList = allTasks;

      if (pageNum == 1) {
        allTasks.clear();
        for (var task in res) {
          allTasks.add(TaskModel.fromJson(task));
        }
        tasksList = allTasks;
      } else {
        for (var task in res) {
          allTasks.add(TaskModel.fromJson(task));
        }
        tasksList = allTasks;
      }

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
      var res = await _taskRepo.editTaskRepo(task: task);
      emit(EditTaskSuccess(TaskModel.fromJson(res)));
    } catch (e) {
      emit(EditTaskError(e.toString()));
    }
  }

  void addTaskCubit() async {
    emit(AddTaskLoading());
    try {
      var res = await _taskRepo.addTaskRepo(
        task: AddTaskModel(
            image: addImageUploadedName!,
            title: titleController.text,
            desc: descController.text,
            priority: selectedPriority!,
            dueDate: DateFormat('yyyy - M - d').format(dueDate!).toString()),
      );

      emit(AddTaskSuccess(TaskModel.fromJson(res)));
    } catch (e) {
      emit(AddTaskError(e.toString()));
    }
  }

  void addTaskByQrCode({required String scannedResult}) async {
    emit(AddTaskByQrCodeLoading());
    try {
      TaskModel res = await _taskRepo.getOneTaskRepo(
          taskID: scannedResult.replaceAll('"', ''));

      await _taskRepo.addTaskRepo(
        task: AddTaskModel(
          image: res.imageUrl == '' ? "image.png" : res.imageUrl,
          title: res.title,
          desc: res.description,
          priority: res.priority,
        ),
      );
      emit(AddTaskByQrCodeSuccess(res));
    } catch (e) {
      emit(AddTaskByQrCodeError(e.toString()));
    }
  }

  void uploadImageCubit(
      {required File imagePath, required String editOrAdd}) async {
    emit(UplaodImageLoading());
    try {
      File? compressedImage = await reduceImageQuality(imageFile: imagePath);

      var res =
          await _taskRepo.uploadImageRepo(ImagePath: compressedImage!.path);
      if (editOrAdd == "add") {
        addImageUploadedName = res['image'];
      } else if (editOrAdd == "edit") {
        editImageUploadedName = res['image'];
      }
      emit(UplaodImageSuccess());
    } catch (e) {
      emit(UplaodImageError(e.toString()));
    }
  }

  Future<File?> reduceImageQuality({required File imageFile}) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final decodedImage = img.decodeImage(bytes);

      if (decodedImage != null) {
        final compressedBytes = img.encodeJpg(decodedImage, quality: 50);

        final tempDir = Directory.systemTemp;
        final tempFile =
            File('${tempDir.path}/${imageFile.path.split('/').last}');
        await tempFile.writeAsBytes(Uint8List.fromList(compressedBytes));
        return tempFile;
      }
    } catch (e) {
      throw Exception(e);
    }
    return null;
  }
}
