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
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              _buildBackgroundImage(),
              verticalSpace(14),
              Positioned(
                bottom: 40.h,
                left: 0,
                right: 0,
                child: _buildLoginForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Image.asset(
      'assets/image/onboarging_img.png',
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: BlocProvider.of<LoginCubit>(context).loginFormKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLoginHeader(),
                verticalSpace(15),
                _buildPhoneField(),
                verticalSpace(10),
                _buildPasswordField(),
                verticalSpace(15),
                _buildSignInButton(),
                verticalSpace(14),
                _buildSignUpLink(),
                _buildBlocLisenner(context),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLoginHeader() {
    return Text(
      'Login',
      style: TextStyles.font24BlackBold,
    );
  }

  Widget _buildPhoneField() {
    return IntlPhoneField(
      decoration: DecorationStyle.inputDecoration.copyWith(
        hintText: '123 456-7890',
      ),
      initialCountryCode: 'EG',
      onChanged: (phone) {
        BlocProvider.of<LoginCubit>(context).phoneController.text =
            phone.completeNumber;
      },
    );
  }

  Widget _buildPasswordField() {
    return AppTextFormField(
      maxLines: 1,
      controller: BlocProvider.of<LoginCubit>(context).passwordController,
      hintText: "Password",
      validator: (value) {},
      keyboardType: TextInputType.visiblePassword,
      isObscureText: _isPasswordVisible,
      suffixIcon: IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
      ),
    );
  }

  Widget _buildSignInButton() {
    return AppTextButton(
        buttonText: "Sign in",
        textStyle: TextStyles.font16WhiteBold,
        onPressed: () {
          login();
        });
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Didn’t have any account? ', style: TextStyles.font14GrayRegular),
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
    );
  }

  Widget _buildBlocLisenner(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
        listenWhen: (previous, current) {
          return previous != current;
        },
        listener: (context, state) {
          if (state is LoginLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          } else if (state is LoginSuccess) {
            Navigator.pop(context);
            context.pushReplacementNamed(Routes.taskesScreen);
          } else if (state is LoginError) {
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Phone Number Or Password Invalid"),
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
