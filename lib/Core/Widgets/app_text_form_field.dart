// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/Core/Theme/style.dart';

import '../theme/colors.dart';

class AppTextFormField extends StatefulWidget {
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final TextStyle? styel;
  final String? hintText;
  final bool? isObscureText;
  final Widget? suffixIcon;
  final Color? backgroundColor;
  final TextEditingController? controller;
  final Icon? prefixIcon;
  final Function(String?) validator;
  final TextInputType keyboardType;
  final bool? readOnly;
  final bool? enable;
  Function(String)? onChanged;
  final int? maxLines;

  AppTextFormField({
    super.key,
    this.styel,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.inputTextStyle,
    this.hintStyle,
    required this.hintText,
    this.isObscureText,
    this.suffixIcon,
    this.backgroundColor,
    required this.validator,
    this.controller,
    this.prefixIcon,
    required this.keyboardType,
    this.readOnly,
    this.enable,
    this.onChanged,
    this.maxLines,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  FocusNode focusNode = FocusNode();
  bool isFocused = false;

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      setState(() {
        isFocused = focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLines,
      onChanged: widget.onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: widget.enable,
      readOnly: widget.readOnly ?? false,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        isDense: true,
        contentPadding: widget.contentPadding ??
            EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        focusedBorder: widget.focusedBorder ??
            const OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorsManager.primryColor,
                width: 1,
              ),
            ),
        enabledBorder: widget.enabledBorder ??
            OutlineInputBorder(
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
        hintStyle: widget.hintStyle ?? TextStyles.font14GrayRegular,
        hintText: widget.hintText,
        suffixIcon: widget.suffixIcon,
        filled: true,
        fillColor: widget.backgroundColor ?? Colors.white,
      ),
      obscureText: widget.isObscureText ?? false,
      style: widget.styel ?? TextStyles.font14BlackRegular,
      validator: (value) => widget.validator(value),
    );
  }
}
