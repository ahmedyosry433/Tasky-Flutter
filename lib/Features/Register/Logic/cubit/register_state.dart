part of 'register_cubit.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  RegisterSuccess();
}

final class RegisterError extends RegisterState {
  final String errorMessage;
  RegisterError({required this.errorMessage});
}
