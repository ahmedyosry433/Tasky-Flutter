import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:tasky/Core/Networking/api_service.dart';
import 'package:tasky/Core/Networking/dio_factory.dart';
import 'package:tasky/Features/Login/Data/Apis/login_apis_service.dart';
import 'package:tasky/Features/Login/Data/Repo/login_repo.dart';
import 'package:tasky/Features/Login/Logic/cubit/login_cubit.dart';
import 'package:tasky/Features/Profile/Data/Apis/profile_apis_service.dart';
import 'package:tasky/Features/Profile/Data/Repo/profile_repo.dart';
import 'package:tasky/Features/Profile/Logic/cubit/profile_cubit.dart';
import 'package:tasky/Features/Register/Data/Apis/register_apis_service.dart';
import 'package:tasky/Features/Register/Data/Repo/register_repo.dart';
import 'package:tasky/Features/Register/Logic/cubit/register_cubit.dart';
import 'package:tasky/Features/Taskes/Data/Apis/task_apis_service.dart';
import 'package:tasky/Features/Taskes/Data/Repo/task_repo.dart';
import 'package:tasky/Features/Taskes/Logic/cubit/task_cubit.dart';

final getIt = GetIt.instance;
Future<void> setupGetit() async {
  // Dio & Api Service
  Dio dio = DioFactory.getDio();
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));
  // Register
  getIt.registerLazySingleton(() => RegisterApisService(dio));
  getIt.registerLazySingleton(() => RegisterRepo(getIt()));
  getIt.registerFactory<RegisterCubit>(() => RegisterCubit(getIt()));
  // Login
  getIt.registerLazySingleton(() => LoginApisService(dio));
  getIt.registerLazySingleton(() => LoginRepo(getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));
  // Profile
  getIt.registerLazySingleton(() => ProfileApisService(dio));
  getIt.registerLazySingleton(() => ProfileRepo(getIt()));
  getIt.registerFactory<ProfileCubit>(() => ProfileCubit(getIt()));
  // Task
  getIt.registerLazySingleton(() => TaskApisService(dio));
  getIt.registerLazySingleton(() => TaskRepo(getIt()));
  getIt.registerFactory<TaskCubit>(() => TaskCubit(getIt()));
}
