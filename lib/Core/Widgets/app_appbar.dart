// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/Core/Helper/extensions.dart';
import 'package:tasky/Core/Helper/spacing.dart';
import 'package:tasky/Core/Router/routes.dart';
import 'package:tasky/Core/Theme/colors.dart';
import 'package:tasky/Core/Theme/style.dart';
import 'package:tasky/Features/Taskes/Logic/cubit/task_cubit.dart';

class AppAppbar extends StatelessWidget {
  AppAppbar({
    super.key,
    required this.type,
    required this.screenTitle,
    this.action,
  });
  List<Widget>? action;
  String? screenTitle;
  String type;

  @override
  Widget build(BuildContext context) {
    return type.toLowerCase() == 'home'
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Logo',
                  style: TextStyles.font24BlackBold,
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          context.pushNamed(Routes.profileScreen);
                        },
                        icon: Icon(
                          Icons.account_circle_outlined,
                          color: Colors.black,
                          size: 25.r,
                        )),
                    horizontalSpace(10),
                    IconButton(
                      onPressed: () {
                        BlocProvider.of<TaskCubit>(context).logoutCubit();
                      },
                      icon: Icon(Icons.logout,
                          color: ColorsManager.primryColor, size: 25.r),
                    ),
                  ],
                ),
              ],
            ),
          )
        : AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            actions: action ?? [],
            leading: Row(
              children: [
                IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: Image.asset(
                    'assets/image/arrow_to_left.png',
                    width: 24.w,
                    height: 24.h,
                  ),
                ),
                Text(screenTitle ?? '', style: TextStyles.font16BlackBold),
              ],
            ),
            leadingWidth: 200.w,
          );
  }
}
