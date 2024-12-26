import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/Core/Helper/extensions.dart';
import 'package:tasky/Core/Helper/spacing.dart';
import 'package:tasky/Core/Theme/colors.dart';
import 'package:tasky/Core/Theme/style.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Row(
            children: [
              IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: Image.asset('assets/image/arrow_to_left.png'),
              ),
              Text('Profile', style: TextStyles.font18BlackBold),
            ],
          ),
          onPressed: () => Navigator.pop(context),
        ),
        leadingWidth: 150.w,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoCard(
              label: 'NAME',
              value: 'Islam Sayed',
            ),
            verticalSpace(16),
            _buildInfoCard(
              label: 'PHONE',
              value: '123 456-7890',
              icon: IconButton(
                  onPressed: () {},
                  icon: Image.asset('assets/image/copy.png', width: 25.w)),
            ),
            verticalSpace(16),
            _buildInfoCard(
              label: 'LEVEL',
              value: 'Senior',
            ),
            verticalSpace(16),
            _buildInfoCard(
              label: 'YEARS OF EXPERIENCE',
              value: '7 years',
            ),
            verticalSpace(16),
            _buildInfoCard(
              label: 'LOCATION',
              value: 'Fayyum, Egypt',
            ),
          ],
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
          Text(label, style: TextStyles.font14GrayRegular),
          verticalSpace(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: TextStyles.font17GrayBold),
              icon ?? const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
