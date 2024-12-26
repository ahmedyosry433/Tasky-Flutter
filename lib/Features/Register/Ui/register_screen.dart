import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/Core/Helper/spacing.dart';
import 'package:tasky/Core/Theme/colors.dart';
import 'package:tasky/Core/Theme/style.dart';
import 'package:tasky/Core/Widgets/app_text_button.dart';

import '../../../Core/Widgets/app_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  String? selectedExperienceLevel;

  final List<String> experienceLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/image/onboarging_img.png',
                width: double.infinity,
                height: 250.h,
                fit: BoxFit.fitWidth,
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Signup',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppTextFormField(
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
                      AppTextFormField(
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
                          onPressed: () {}),
                      verticalSpace(14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have any account? ',
                              style: TextStyles.font14GrayRegular),
                          GestureDetector(
                            onTap: () {
                              // Handle navigation to sign in screen
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyles.font12PrimaryBold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        isDense: true,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorsManager.primryColor,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ColorsManager.grayColor,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.3,
          ),
        ),
        hintStyle: TextStyles.font14GrayRegular,
        filled: true,
        fillColor: Colors.white,
      ),
      value: selectedExperienceLevel,
      items: experienceLevels.map((String level) {
        return DropdownMenuItem(
          value: level,
          child: Text(level),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedExperienceLevel = newValue;
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
