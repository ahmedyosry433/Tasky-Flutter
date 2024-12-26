import 'package:flutter/material.dart';
import 'package:tasky/Core/Router/routes.dart';
import 'package:tasky/Features/Onboarding/Ui/onboarding_screen.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onboardingScreen:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );
      // case Routes.homeScreen:
      //   return MaterialPageRoute(
      //     builder: (_) =>  HomeScreen(),
      //   );

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
