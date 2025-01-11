// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tasky/Core/Helper/extensions.dart';
import 'package:tasky/Core/Helper/spacing.dart';
import 'package:tasky/Core/Networking/api_constants.dart';
import 'package:tasky/Core/Router/routes.dart';
import 'package:tasky/Core/Theme/style.dart';
import 'package:tasky/Core/Widgets/app_cached_network_image.dart';
import 'package:tasky/Core/theme/colors.dart';
import 'package:tasky/Features/Taskes/Data/Model/task_model.dart';
import 'package:tasky/Features/Taskes/Logic/cubit/task_cubit.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({required this.task, super.key});
  final TaskModel task;

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TaskCubit>(context).getOneTaskCubit(taskId: widget.task.id);
  }

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
              children: [
                _buildBlocBuilder(),
                _buildDeleteBlocLisener(),
                _buildEditBlocLisener(),
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
            offset: const Offset(80, 10),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            position: PopupMenuPosition.under,
            color: Colors.white,
            child: Icon(
              Icons.more_vert,
              color: Colors.black,
              size: 24.r,
            ),
            onSelected: (value) {
              if (value == 'edit') {
                showEditDialog(context, widget.task);
              } else if (value == 'delete') {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      title: const Text("Confirm Delete"),
                      content: const Text(
                          "Are you sure you want to delete this item?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            dialogContext.pop();
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            BlocProvider.of<TaskCubit>(context)
                                .deleteTaskCubit(taskId: widget.task.id);
                            dialogContext.pop();
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
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
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
            icon: Image.asset(
              'assets/image/arrow_to_left.png',
              width: 24.w,
              height: 24.h,
            ),
          ),
          Text('Task Details', style: TextStyles.font16BlackBold),
        ],
      ),
      leadingWidth: 200.w,
    );
  }

  Widget _buildBlocBuilder() {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if (state is OneTaskLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is OneTaskSuccess) {
          return _buildTaskInfo(task: state.task);
        } else if (state is OneTaskError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Text(
                'Something went wrong.',
                style: TextStyles.font18BlackBold,
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildTaskInfo({required TaskModel task}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTaskImage(task.imageUrl),
        Text(task.title, style: TextStyles.font24BlackBold),
        verticalSpace(8),
        Text(task.description, style: TextStyles.font14GrayRegular),
        verticalSpace(20),
        _buildInfoCard(
          label: 'End Date',
          value: '30 June, 2022',
          icon: Image.asset('assets/image/calendar.png'),
        ),
        verticalSpace(10),
        _buildDropdownShapCard(label: 'Status', value: task.status),
        verticalSpace(10),
        _buildDropdownShapCard(
          label: 'Priority',
          value: '${task.priority} Priority',
          icon:
              const Icon(Icons.flag_outlined, color: ColorsManager.primryColor),
        ),
        verticalSpace(20),
        _buildQrCode(),
      ],
    );
  }

  Widget _buildTaskImage(String imageUrl) {
    return Center(
      child: SizedBox(
        width: 300.w,
        height: 200.h,
        child: AppCasedNetworkImage(
          imageUrl:
              '${ApiConstants.apiBaseUrl}${ApiConstants.getImageUrl}$imageUrl',
          fit: BoxFit.cover,
          width: 300.w,
          height: 200.h,
        ),
      ),
    );
  }

  Widget _buildQrCode() {
    return Center(
      child: QrImageView(
        data: BlocProvider.of<TaskCubit>(context).oneTask!.id,
        version: QrVersions.auto,
        size: 250.r,
        backgroundColor: Colors.white,
      ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label == 'End Date'
              ? Text(
                  "End Date",
                  style: TextStyles.font14GrayRegular,
                  textAlign: TextAlign.start,
                )
              : const SizedBox.shrink(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: TextStyles.font16BlackRegular),
                ],
              ),
              if (icon != null) icon,
            ],
          ),
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
                Text(value, style: TextStyles.font16PrimaryBold),
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
        if (state is DeleteTaskLoading) {
        } else if (state is DeleteTaskSuccess) {
          context.pushReplacementNamed(Routes.taskesScreen);
        } else if (state is DeleteTaskError) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Something went wrong."),
          ));
        }
      },
      child: const SizedBox.shrink(),
    );
  }

  void showEditDialog(BuildContext context, TaskModel task) {
    final oneTask = BlocProvider.of<TaskCubit>(context).oneTask!;
    TextEditingController titleController =
        TextEditingController(text: oneTask.title);
    TextEditingController descController =
        TextEditingController(text: oneTask.description);
    String selectedPriority = oneTask.priority;
    String selectedStatus = oneTask.status;
    String imagePath = oneTask.imageUrl;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Edit Task"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 150.h,
                  width: 150.w,
                  child: AppCasedNetworkImage(
                      imageUrl:
                          "${ApiConstants.apiBaseUrl}${ApiConstants.getImageUrl}$imagePath",
                      height: 150.h,
                      width: 150.w,
                      fit: BoxFit.cover),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        imagePath = pickedFile.path;
                      });
                      BlocProvider.of<TaskCubit>(context).uploadImageCubit(
                          imagePath: File(pickedFile.path), editOrAdd: 'edit');
                    }
                  },
                  icon: const Icon(Icons.image),
                  label: const Text("Select Image"),
                ),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedPriority.toLowerCase(),
                  items: ['Low', 'Medium', 'High']
                      .map((priority) => DropdownMenuItem(
                            value: priority.toLowerCase(),
                            child: Text(priority),
                          ))
                      .toList(),
                  onChanged: (value) {
                    selectedPriority = value!;
                  },
                  decoration: const InputDecoration(
                    labelText: "Priority",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedStatus.toLowerCase(),
                  items: ['Waiting', 'Inprogress', 'Finished']
                      .map((status) => DropdownMenuItem(
                            value: status.toLowerCase(),
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    selectedStatus = value!;
                  },
                  decoration: const InputDecoration(
                    labelText: "Status",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                BlocProvider.of<TaskCubit>(context).editTaskCubit(
                    task: TaskModel(
                        id: task.id,
                        title: titleController.text,
                        description: descController.text,
                        priority: selectedPriority,
                        imageUrl: BlocProvider.of<TaskCubit>(context)
                                .editImageUploadedName ??
                            task.imageUrl,
                        status: selectedStatus,
                        userId: task.userId));
                dialogContext.pop();
              },
              child: Text(
                "Save",
                style: TextStyles.font14PrimarySemiBold,
              ),
            ),
          ],
        );
      },
    );
  }

  _buildEditBlocLisener() {
    return BlocListener<TaskCubit, TaskState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is EditTaskLoading) {
            const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is EditTaskSuccess) {
            BlocProvider.of<TaskCubit>(context)
                .getOneTaskCubit(taskId: widget.task.id);
          } else if (state is EditTaskError) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Something went wrong."),
            ));
          }
        },
        child: const SizedBox.shrink());
  }
}
