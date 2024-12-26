import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'colors.dart';
import 'font_weight_helper.dart';

class TextStyles {
  static TextStyle font14PrimarySemiBold = TextStyle(
    color: ColorsManager.primryColor,
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.semiBold,
  );
  static TextStyle font16PrimaryBold = TextStyle(
    color: ColorsManager.primryColor,
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.bold,
  );
  static TextStyle font12PrimaryBold = TextStyle(
    color: ColorsManager.primryColor,
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.bold,
  );
  static TextStyle font10PrimaryRegular = TextStyle(
    color: ColorsManager.primryColor,
    fontSize: 10.sp,
    fontWeight: FontWeightHelper.regular,
  );
  static TextStyle font8PrimaryRegular = TextStyle(
    color: ColorsManager.primryColor,
    fontSize: 8.sp,
    fontWeight: FontWeightHelper.regular,
  );
  static TextStyle font10PrimaryBold = TextStyle(
    color: ColorsManager.primryColor,
    fontSize: 10.sp,
    fontWeight: FontWeightHelper.bold,
  );
  static TextStyle font6PrimaryBold = TextStyle(
    color: ColorsManager.primryColor,
    fontSize: 6.sp,
    fontWeight: FontWeightHelper.bold,
  );

  static TextStyle font11LightPrimaryBold = TextStyle(
    color: ColorsManager.lightPrimryColor,
    fontSize: 11.sp,
    fontWeight: FontWeightHelper.bold,
  );
  static TextStyle font10LightPrimaryRegular = TextStyle(
    color: ColorsManager.lightPrimryColor,
    fontSize: 10.sp,
    fontWeight: FontWeightHelper.regular,
  );
  //Black Colors
  static TextStyle font10BlackRegular = TextStyle(
    color: Colors.black,
    fontSize: 10.sp,
    fontWeight: FontWeightHelper.regular,
  );
  static TextStyle font14BlackRegular = TextStyle(
    color: Colors.black,
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.regular,
  );
  static TextStyle font24BlackBold = TextStyle(
    color: Colors.black,
    fontSize: 24.sp,
    fontWeight: FontWeightHelper.bold,
  );
  static TextStyle font18BlackBold = TextStyle(
    color: Colors.black,
    fontSize: 20.sp,
    fontWeight: FontWeightHelper.bold,
  );
  //Gray Colors

  static TextStyle font14GrayRegular = TextStyle(
    color: ColorsManager.grayColor,
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.regular,
  );
  static TextStyle font17GrayBold = TextStyle(
    color: ColorsManager.grayColor,
    fontSize: 17.sp,
    fontWeight: FontWeightHelper.bold,
  );
  // WHITE  COLORS
  static TextStyle font14WhiteSemiBold = TextStyle(
    color: ColorsManager.whiteColor,
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.semiBold,
  );
  static TextStyle font14WhiteRegular = TextStyle(
    color: ColorsManager.whiteColor,
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.regular,
  );
  static TextStyle font12WhiteBold = TextStyle(
    color: ColorsManager.whiteColor,
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.bold,
  );
  static TextStyle font10WhiteBold = TextStyle(
    color: ColorsManager.whiteColor,
    fontSize: 10.sp,
    fontWeight: FontWeightHelper.bold,
  );
}

class DecorationStyle {
  static InputDecoration inputDecoration = InputDecoration(
    isDense: true,
    contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
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
  );
}
