import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tasky/Core/Helper/extensions.dart';
import 'package:tasky/Core/Helper/spacing.dart';
import 'package:tasky/Core/Router/routes.dart';
import 'package:tasky/Core/Theme/style.dart';
import 'package:tasky/Core/Widgets/app_text_button.dart';
import 'package:tasky/Core/Widgets/app_text_form_field.dart';
import 'package:tasky/Features/Login/Logic/cubit/login_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/image/onboarging_img.png',
                  height: 300.h, width: double.infinity, fit: BoxFit.fitWidth),
              verticalSpace(14),
              Form(
                key: BlocProvider.of<LoginCubit>(context).loginFormKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Login',
                            textAlign: TextAlign.right,
                            style: TextStyles.font24BlackBold,
                          ),
                          verticalSpace(15),
                          IntlPhoneField(
                            decoration:
                                DecorationStyle.inputDecoration.copyWith(
                              hintText: '123 456-7890',
                            ),
                            initialCountryCode: 'EG',
                            onChanged: (phone) {
                              BlocProvider.of<LoginCubit>(context)
                                  .phoneController
                                  .text = phone.completeNumber;
                            },
                          ),
                          verticalSpace(10),
                          AppTextFormField(
                            maxLines: 1,
                            controller: BlocProvider.of<LoginCubit>(context)
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
                              buttonText: "Sign in",
                              textStyle: TextStyles.font14WhiteSemiBold,
                              onPressed: () {
                                login();
                              }),
                          verticalSpace(14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Didn’t have any account? ',
                                  style: TextStyles.font14GrayRegular),
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed(Routes.registerScreen);
                                },
                                child: Text(
                                  'Sign Up here',
                                  style: TextStyles.font12PrimaryBold,
                                ),
                              ),
                            ],
                          ),
                          verticalSpace(20),
                          _buildBlocLisenner(context),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlocLisenner(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
        listenWhen: (previous, current) {
          return previous != current;
        },
        listener: (context, state) {
          if (state is LoginLoading) {
            const Center(child: CircularProgressIndicator());
          }
          if (state is LoginSuccess) {
            context.pushNamed(Routes.taskesScreen);
          }
          if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: TextStyles.font14WhiteSemiBold,
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: const SizedBox());
  }

  void login() {
    if (BlocProvider.of<LoginCubit>(context)
        .loginFormKey
        .currentState!
        .validate()) {
      BlocProvider.of<LoginCubit>(context).loginCubit();
    }
  }
}
