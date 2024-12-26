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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/image/onboarging_img.png'),
            verticalSpace(10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    "Task Management &\nTo-Do List",
                    style: TextStyles.font24BlackBold,
                  ),
                  verticalSpace(10),
                  Text(
                    textAlign: TextAlign.center,
                    "This productive tool is designed to helpyou better manage your task project-wise conveniently!",
                    style: TextStyles.font14GrayRegular,
                  ),
                  AppTextButton(
                      imagePath: "assets/image/arrow_left.png",
                      buttonText: "Let’s Start",
                      textStyle: TextStyles.font14WhiteSemiBold,
                      onPressed: () {
                        context.pushNamed(Routes.registerScreen);
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
