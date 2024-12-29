part of 'task_cubit.dart';

@immutable
sealed class TaskState {}

final class TaskInitial extends TaskState {}

final class TaskLoading extends TaskState {}

final class TaskSuccess extends TaskState {
  
}

final class TaskError extends TaskState {
  final String errorMessage;

  TaskError(this.errorMessage);
}

final class LogoutLoading extends TaskState {}

final class LogoutSuccess extends TaskState {}

final class LogoutError extends TaskState {
  final String errorMessage;

  LogoutError(this.errorMessage);
}
