// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/Core/Helper/extensions.dart';
import 'package:tasky/Core/Helper/spacing.dart';
import 'package:tasky/Core/Router/routes.dart';
import 'package:tasky/Core/Theme/style.dart';
import 'package:tasky/Core/Widgets/app_text_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.97,
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.68,
                      child: Text(
                        "This productive tool is designed to help you better manage your task project-wise conveniently!",
                        textAlign: TextAlign.center,
                        style: TextStyles.font14GrayRegular
                            .copyWith(height: 1.8.h),
                      ),
                    ),
                    verticalSpace(20),
                    AppTextButton(
                      imagePath: "assets/image/arrow_left.png",
                      buttonText: "Let's Start",
                      textStyle: TextStyles.font16WhiteBold,
                      onPressed: () {
                        context.pushReplacementNamed(Routes.loginScreen);
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
}
