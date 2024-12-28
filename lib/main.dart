// ignore_for_file: avoid_relative_lib_imports

import 'package:flutter/material.dart';
import 'package:tasky/Core/Dj/dependency_injection.dart';
import 'package:tasky/Core/Router/app_router.dart';
import 'package:tasky/tasky-app.dart';

void main() async {
  setupGetit();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(TaskyApp(
    appRouter: AppRouter(),
  ));
}
