import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tasky/Core/Helper/shared_preferences_helper.dart';
import 'package:tasky/Features/Taskes/Data/Repo/task_repo.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepo _taskRepo;
  TaskCubit(this._taskRepo) : super(TaskInitial());

  void logoutCubit() async {
    emit(LogoutLoading());
    try {
      String token = await SharedPreferencesHelper.getValueForKey("token");
      await _taskRepo.logoutRepo(token: token);
      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutError(e.toString()));
    }
  }
}
