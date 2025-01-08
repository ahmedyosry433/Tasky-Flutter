// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:tasky/Core/Helper/spacing.dart';
import 'package:tasky/Core/Theme/style.dart';
import 'package:tasky/Core/Widgets/app_text_form_field.dart';

class AppTextFormFieldWithTopHint extends StatelessWidget {
  AppTextFormFieldWithTopHint({
    super.key,
    required this.topHintText,
    required this.appTextFormField,
  });
  String topHintText;
  AppTextFormField appTextFormField;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(topHintText,
              style: TextStyles.font12GrayRegular
                  .copyWith(height: 2, fontWeight: FontWeight.w400)),
        ),
        verticalSpace(10),
        appTextFormField,
      ],
    );
  }
}
