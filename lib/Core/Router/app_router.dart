import 'package:flutter/material.dart';
import 'package:tasky/Core/Router/routes.dart';
import 'package:tasky/Features/Login/Ui/login_screen.dart';
import 'package:tasky/Features/Onboarding/Ui/onboarding_screen.dart';
import 'package:tasky/Features/Register/Ui/register_screen.dart';
import 'package:tasky/Features/Taskes/Ui/taskes_screen.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onboardingScreen:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );
      case Routes.registerScreen:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
        );
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case Routes.taskesScreen:
        return MaterialPageRoute(
          builder: (_) => const TaskListScreen(),
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
