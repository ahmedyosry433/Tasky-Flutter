import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tasky/Core/Helper/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tasky/Core/Helper/spacing.dart';
import 'package:tasky/Core/Router/routes.dart';
import 'package:tasky/Core/Theme/style.dart';
import 'package:tasky/Core/Widgets/app_text_button.dart';
import 'package:tasky/Features/Register/Logic/cubit/register_cubit.dart';

import '../../../Core/Widgets/app_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 1.1,
            child: Stack(
              children: [
                Image.asset(
                  'assets/image/onboarging_img.png',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.55,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: -10,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Form(
                      key: BlocProvider.of<RegisterCubit>(context)
                          .registerFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Signup',
                            style: TextStyles.font24BlackBold,
                          ),
                          verticalSpace(10),
                          AppTextFormField(
                            controller: BlocProvider.of<RegisterCubit>(context)
                                .displayNameController,
                            hintText: 'Name...',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                          ),
                          verticalSpace(14),
                          IntlPhoneField(
                            decoration:
                                DecorationStyle.inputDecoration.copyWith(
                              hintText: '123 456-7890',
                            ),
                            initialCountryCode: 'EG',
                            onChanged: (phone) {
                              BlocProvider.of<RegisterCubit>(context)
                                  .phoneController
                                  .text = phone.completeNumber;
                            },
                          ),
                          AppTextFormField(
                              controller:
                                  BlocProvider.of<RegisterCubit>(context)
                                      .experienceYearsController,
                              hintText: "Years of experience...",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your years of experience';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number),
                          verticalSpace(14),
                          _buildDropdown(),
                          verticalSpace(14),
                          AppTextFormField(
                              controller:
                                  BlocProvider.of<RegisterCubit>(context)
                                      .addressController,
                              hintText: "Address...",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your address';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.streetAddress),
                          verticalSpace(14),
                          AppTextFormField(
                            maxLines: 1,
                            controller: BlocProvider.of<RegisterCubit>(context)
                                .passwordController,
                            hintText: "Password",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.visiblePassword,
                            isObscureText: _isPasswordVisible,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          verticalSpace(15),
                          AppTextButton(
                              buttonText: "Signup",
                              textStyle: TextStyles.font14WhiteSemiBold,
                              onPressed: () {
                                login(context);
                              }),
                          verticalSpace(14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already have any account? ',
                                  style: TextStyles.font14GrayRegular),
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed(Routes.loginScreen);
                                },
                                child: Text(
                                  'Sign in',
                                  style: TextStyles.font12PrimaryBold,
                                ),
                              ),
                            ],
                          ),
                          _buildBlocLisenner(context),
                          verticalSpace(40)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      decoration: DecorationStyle.inputDecoration.copyWith(
        hintText: 'Choose experience Level',
      ),
      value: BlocProvider.of<RegisterCubit>(context).selectedExperienceLevel,
      items: BlocProvider.of<RegisterCubit>(context)
          .experienceLevels
          .map((String level) {
        return DropdownMenuItem(
          value: level,
          child: Text(level),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          BlocProvider.of<RegisterCubit>(context).selectedExperienceLevel =
              newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select experience level';
        }
        return null;
      },
    );
  }
}

Widget _buildBlocLisenner(BuildContext context) {
  return BlocListener<RegisterCubit, RegisterState>(
    listenWhen: (previous, current) {
      return previous != current;
    },
    listener: (context, state) {
      if (state is RegisterLoading) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          },
        );
      }
      if (state is RegisterSuccess) {
        context.pop();

        context.pushReplacementNamed(Routes.taskesScreen);
      }
      if (state is RegisterError) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Something went wrong, Make sure Your Data"),
          ),
        );
      }
    },
    child: Container(),
  );
}

void login(BuildContext context) {
  if (BlocProvider.of<RegisterCubit>(context)
      .registerFormKey
      .currentState!
      .validate()) {
    BlocProvider.of<RegisterCubit>(context)
        .registerFormKey
        .currentState!
        .save();
    BlocProvider.of<RegisterCubit>(context).registerCubit();
  }
}
