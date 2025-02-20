import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/Core/Helper/extensions.dart';
import 'package:tasky/Core/Helper/spacing.dart';
import 'package:tasky/Core/Theme/colors.dart';
import 'package:tasky/Core/Theme/style.dart';
import 'package:tasky/Features/Profile/Logic/cubit/profile_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
            Text('Profile', style: TextStyles.font16BlackBold),
          ],
        ),
        leadingWidth: 150.w,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [_buildBlocBuilder()],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      {required String label, required String value, Widget? icon}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColorsManager.grayColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyles.font12GrayMedium),
          verticalSpace(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: TextStyles.font18GrayBold),
              icon ?? const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBlocBuilder() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ProfileSuccess) {
          return Column(
            children: [
              _buildInfoCard(
                label: 'NAME',
                value: BlocProvider.of<ProfileCubit>(context).displayName ?? '',
              ),
              verticalSpace(16),
              _buildInfoCard(
                label: 'PHONE',
                value: BlocProvider.of<ProfileCubit>(context).phone ?? '',
                icon: Tooltip(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    color: ColorsManager.primryColor,
                    border: Border.all(color: Colors.black),
                  ),
                  message: 'Phone number copied!',
                  child: IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                          text: BlocProvider.of<ProfileCubit>(context).phone!));
                    },
                    icon: Image.asset('assets/image/copy.png', width: 25.w),
                  ),
                ),
              ),
              verticalSpace(16),
              _buildInfoCard(
                label: 'LEVEL',
                value: BlocProvider.of<ProfileCubit>(context).level ?? '',
              ),
              verticalSpace(16),
              _buildInfoCard(
                label: 'YEARS OF EXPERIENCE',
                value: BlocProvider.of<ProfileCubit>(context)
                    .yearsOfExperience
                    .toString(),
              ),
              verticalSpace(16),
              _buildInfoCard(
                label: 'ADDRESS',
                value: BlocProvider.of<ProfileCubit>(context).address ?? '',
              ),
            ],
          );
        } else if (state is ProfileError) {
          return Text('Failed to load profile ${state.error}');
        }
        return const SizedBox.shrink();
      },
    );
  }
}
