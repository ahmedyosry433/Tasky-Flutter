import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/Core/Helper/extensions.dart';
import 'package:tasky/Core/Helper/spacing.dart';
import 'package:tasky/Core/Theme/style.dart';
import 'package:tasky/Core/theme/colors.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.h),
        child: _buildAppbar(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/image/task_img.png'),
                Text('Grocery Shopping App', style: TextStyles.font18BlackBold),
                verticalSpace(8),
                Text(
                    'This application is designed for super shops. By using '
                    'this application they can enlist all their products in one '
                    'place and can deliver. Customers will get a one-stop '
                    'solution for their daily shopping.',
                    style: TextStyles.font14GrayRegular),
                verticalSpace(20),
                _buildInfoCard(
                  label: 'End Date',
                  value: '30 June, 2022',
                  icon: const Icon(Icons.calendar_today,
                      color: ColorsManager.primryColor),
                ),
                verticalSpace(10),
                _buildDropdownCard(label: 'Status', value: 'Inprogress'),
                verticalSpace(10),
                _buildDropdownCard(
                  label: 'Priority',
                  value: 'Medium Priority',
                  icon: const Icon(Icons.flag_outlined,
                      color: ColorsManager.primryColor),
                ),
                verticalSpace(20),
                Center(
                  child: Image.asset(
                    'assets/image/qr.png',
                    width: 200.w,
                    height: 200.h,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        PopupMenuButton(
          position: PopupMenuPosition.under,
          color: Colors.white,
          child: Icon(
            Icons.more_vert,
            color: Colors.black,
            size: 24.r,
          ),
          onSelected: (value) {
            if (value == 'edit') {
              // Navigate to edit screen
            } else {
              // Show delete confirmation dialog
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ],
      leading: IconButton(
        icon: Row(
          children: [
            IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Image.asset('assets/image/arrow_to_left.png'),
            ),
            Text('Task Details', style: TextStyles.font18BlackBold),
          ],
        ),
        onPressed: () => Navigator.pop(context),
      ),
      leadingWidth: 200.w,
    );
  }

  Widget _buildInfoCard(
      {required String label, required String value, Widget? icon}) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColorsManager.primryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          if (icon != null) icon,
        ],
      ),
    );
  }

  Widget _buildDropdownCard(
      {required String label, required String value, Widget? icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsManager.primryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (icon != null) icon,
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Image.asset('assets/image/arrow_down.png', width: 24.w),
        ],
      ),
    );
  }
}
