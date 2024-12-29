part of 'task_cubit.dart';

@immutable
sealed class TaskState {}

final class TaskInitial extends TaskState {}

final class TaskLoading extends TaskState {}

final class TaskSuccess extends TaskState {}

final class TaskError extends TaskState {
  final String errorMessage;

  TaskError(this.errorMessage);
}

final class OneTaskLoading extends TaskState {}

final class OneTaskSuccess extends TaskState {
  final TaskModel task;
  OneTaskSuccess(this.task);
}

final class OneTaskError extends TaskState {
  final String errorMessage;

  OneTaskError(this.errorMessage);
}

final class LogoutLoading extends TaskState {}

final class LogoutSuccess extends TaskState {}

final class LogoutError extends TaskState {
  final String errorMessage;

  LogoutError(this.errorMessage);
}

final class DeleteTaskLoading extends TaskState {}

final class DeleteTaskSuccess extends TaskState {}

final class DeleteTaskError extends TaskState {
  final String errorMessage;

  DeleteTaskError(this.errorMessage);
}

final class EditTaskLoading extends TaskState {}

final class EditTaskSuccess extends TaskState {}

final class EditTaskError extends TaskState {
  final String errorMessage;

  EditTaskError(this.errorMessage);
}

final class AddTaskLoading extends TaskState {}

final class AddTaskSuccess extends TaskState {}

final class AddTaskError extends TaskState {
  final String errorMessage;

  AddTaskError(this.errorMessage);
}
