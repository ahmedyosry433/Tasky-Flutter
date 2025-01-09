// ignore_for_file: unnecessary_import

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:tasky/Core/Helper/shared_preferences_helper.dart';
import 'package:tasky/Features/Login/Data/Model/login_model.dart';
import 'package:tasky/Features/Login/Data/Repo/login_repo.dart';

import '../../../../Core/Networking/dio_factory.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginRepo _loginRepo;
  LoginCubit(this._loginRepo) : super(LoginInitial());

  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  void loginCubit() async {
    emit(LoginLoading());
    try {
      final response = await _loginRepo.loginRepo(
        loginModel: LoginModel(
            phone: phoneController.text, password: passwordController.text),
      );
      await SharedPreferencesHelper.setSecuredString(
          'token', response["access_token"]);

      await SharedPreferencesHelper.setSecuredString(
          'reftoken', response["refresh_token"]);

      DioFactory.setTokenAfterLogin(response["access_token"]);

      emit(LoginSuccess());
      phoneController.clear();
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
