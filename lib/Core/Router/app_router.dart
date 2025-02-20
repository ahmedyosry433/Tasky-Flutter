import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/Core/Dj/dependency_injection.dart';
import 'package:tasky/Core/Router/routes.dart';
import 'package:tasky/Features/Login/Logic/cubit/login_cubit.dart';
import 'package:tasky/Features/Login/Ui/login_screen.dart';
import 'package:tasky/Features/Onboarding/Ui/onboarding_screen.dart';
import 'package:tasky/Features/Profile/Logic/cubit/profile_cubit.dart';
import 'package:tasky/Features/Profile/Ui/profile_screen.dart';
import 'package:tasky/Features/Register/Logic/cubit/register_cubit.dart';
import 'package:tasky/Features/Register/Ui/register_screen.dart';
import 'package:tasky/Features/Taskes/Data/Model/task_model.dart';
import 'package:tasky/Features/Taskes/Logic/cubit/task_cubit.dart';
import 'package:tasky/Features/Taskes/Ui/add_new_task_screen.dart';
import 'package:tasky/Features/Taskes/Ui/edit_task_screen.dart';
import 'package:tasky/Features/Taskes/Ui/task_details_screen.dart';
import 'package:tasky/Features/Taskes/Ui/taskes_screen.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    final argument = settings.arguments;
    switch (settings.name) {
      case Routes.onboardingScreen:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );
      case Routes.registerScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<RegisterCubit>(),
            child: const RegisterScreen(),
          ),
        );
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: const LoginScreen(),
          ),
        );
      case Routes.taskesScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<TaskCubit>(),
            child: const TaskListScreen(),
          ),
        );
      case Routes.profileScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ProfileCubit>(),
            child: const ProfileScreen(),
          ),
        );

      case Routes.taskDetailsScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<TaskCubit>(),
            child: TaskDetailsScreen(task: argument as TaskModel),
          ),
        );
      case Routes.addTaskScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<TaskCubit>(),
            child: const AddTaskScreen(),
          ),
        );
      case Routes.editTaskScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<TaskCubit>(),
            child: EditTaskScreen(task: argument as TaskModel),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(' No Route Defined For ${settings.name}'),
            ),
          ),
        );
    }
  }
}
