// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tasky/Core/Networking/dio_factory.dart';
import 'package:tasky/Core/Helper/shared_preferences_helper.dart';
import 'package:tasky/Features/Register/Data/Model/register_model.dart';
import 'package:tasky/Features/Register/Data/Repo/register_repo.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterRepo registerRepo;
  RegisterCubit(this.registerRepo) : super(RegisterInitial());

  final registerFormKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController experienceYearsController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final List<String> experienceLevels = [
    'Fresh',
    'Junior',
    'MidLevel',
    'Senior'
  ];
  String? selectedExperienceLevel;

  void registerCubit() async {
    emit(RegisterLoading());
    try {
      var res = await registerRepo.registerRepo(
          registerModel: UserModel(
              phone: phoneController.text,
              password: passwordController.text,
              displayName: displayNameController.text,
              experienceYears: int.parse(experienceYearsController.text),
              address: addressController.text,
              level: selectedExperienceLevel!.toLowerCase()));

      await SharedPreferencesHelper.setSecuredString(
          'token', res['access_token']);
      await SharedPreferencesHelper.setSecuredString(
          'reftoken', res["refresh_token"]);
      DioFactory.setTokenAfterLogin(res["access_token"]);

      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterError(errorMessage: e.toString()));
    }
  }
}
