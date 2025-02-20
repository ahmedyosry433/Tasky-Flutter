// ignore_for_file: avoid_relative_lib_imports

import 'package:flutter/material.dart';
import 'package:tasky/Core/Dj/dependency_injection.dart';
import 'package:tasky/Core/Helper/constants.dart';
import 'package:tasky/Core/Helper/shared_preferences_helper.dart';
import 'package:tasky/Core/Router/app_router.dart';
import 'package:tasky/tasky-app.dart';

bool isLogedInUser = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupGetit();
  await checkIfLoggedInUser();
  runApp(TaskyApp(
    appRouter: AppRouter(),
  ));
}

checkIfLoggedInUser() async {
  String? userToken =
      await SharedPreferencesHelper.getSecuredString(AppConstants.accessToken);
  if (userToken == null || userToken.isEmpty) {
    isLogedInUser = false;

  } else {
   
    isLogedInUser = true;
  }
}
