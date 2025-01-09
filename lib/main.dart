// ignore_for_file: avoid_relative_lib_imports

import 'package:flutter/material.dart';
import 'package:tasky/Core/Dj/dependency_injection.dart';
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
  print("____________!_______");
  String? userToken = await SharedPreferencesHelper.getSecuredString('token');
  print("____________2_______");
  if (userToken == null || userToken.isEmpty) {
    print("____________3_______");
    isLogedInUser = false;
    print("____________4_______");
  } else {
    print("____________5_______");
    isLogedInUser = true;
  }
  print("____________6_______");
}
