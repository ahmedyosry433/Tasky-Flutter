// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/Core/Helper/extensions.dart';
import 'package:tasky/Core/Helper/shared_preferences_helper.dart';
import 'package:tasky/Core/Helper/spacing.dart';
import 'package:tasky/Core/Router/routes.dart';
import 'package:tasky/Core/Theme/style.dart';
import 'package:tasky/Core/Widgets/app_text_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<bool> _checkToken() async {
    final token = await SharedPreferencesHelper.getValueForKey('token');
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
          future: _checkToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data == true) {
              Future.microtask(
                  () => context.pushReplacementNamed(Routes.taskesScreen));
              return const SizedBox.shrink();
            } else {
              return Scaffold(
                body: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/image/onboarging_img.png',
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 50.h,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            children: [
                              Text(
                                "Task Management &\nTo-Do List",
                                textAlign: TextAlign.center,
                                style: TextStyles.font24BlackBold,
                              ),
                              verticalSpace(10),
                              Text(
                                "This productive tool is designed to help you better manage your task project-wise conveniently!",
                                textAlign: TextAlign.center,
                                style: TextStyles.font14GrayRegular,
                              ),
                              verticalSpace(20),
                              AppTextButton(
                                imagePath: "assets/image/arrow_left.png",
                                buttonText: "Let's Start",
                                textStyle: TextStyles.font14WhiteSemiBold,
                                onPressed: () {
                                  context
                                      .pushReplacementNamed(Routes.loginScreen);
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
