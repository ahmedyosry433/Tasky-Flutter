import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/Core/Helper/extensions.dart';
import 'package:tasky/Core/Helper/spacing.dart';
import 'package:tasky/Core/Router/routes.dart';
import 'package:tasky/Core/Theme/style.dart';
import 'package:tasky/Core/theme/colors.dart';
import 'package:tasky/Features/Taskes/Data/Model/task_model.dart';
import 'package:tasky/Features/Taskes/Logic/cubit/task_cubit.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({required this.task, super.key});
  final TaskModel task;

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
                Text(task.title, style: TextStyles.font18BlackBold),
                verticalSpace(8),
                Text(task.description, style: TextStyles.font14GrayRegular),
                verticalSpace(20),
                _buildInfoCard(
                  label: 'End Date',
                  value: '30 June, 2022',
                  icon: const Icon(Icons.calendar_today,
                      color: ColorsManager.primryColor),
                ),
                verticalSpace(10),
                _buildDropdownShapCard(label: 'Status', value: task.status),
                verticalSpace(10),
                _buildDropdownShapCard(
                  label: 'Priority',
                  value: '${task.priority} Priority',
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
                _buildDeleteBlocLisener(),
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
        Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: PopupMenuButton(
            position: PopupMenuPosition.under,
            color: Colors.white,
            child: Icon(
              Icons.more_vert,
              color: Colors.black,
              size: 24.r,
            ),
            onSelected: (value) {
              // if (value == 'edit') {
              //   context.pushNamed(Routes.taskesScreen);
              // }
              if (value == 'delete') {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirm Delete"),
                      content: const Text(
                          "Are you sure you want to delete this item?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            context.pop(); // Close the dialog
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            context
                                .read<TaskCubit>()
                                .deleteTaskCubit(taskId: task.id);
                            print("Item deleted");
                            context.pop(); // Close the dialog
                          },
                          child: const Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
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
        ),
      ],
      leading: Row(
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

  Widget _buildDropdownShapCard(
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

  Widget _buildDeleteBlocLisener() {
    return BlocListener<TaskCubit, TaskState>(
      listener: (context, state) {
        if (state is DeleteTaskSuccess) {
          // BlocProvider.of<TaskCubit>(context).tasksListCubit();
          context.pushReplacementNamed(Routes.taskesScreen);
        } else if (state is DeleteTaskError) {}
      },
      child: const SizedBox.shrink(),
    );
  }
}
