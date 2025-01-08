// ignore_for_file: unused_element, unused_field, use_build_context_synchronously

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tasky/Core/Helper/extensions.dart';
import 'package:tasky/Core/Helper/spacing.dart';
import 'package:tasky/Core/Router/routes.dart';
import 'package:tasky/Core/Theme/style.dart';
import 'package:tasky/Core/Widgets/app_text_button.dart';
import 'package:tasky/Core/Widgets/app_text_form_field.dart';
import 'package:tasky/Core/Widgets/app_text_form_field_with_hint.dart';
import 'package:tasky/Core/theme/colors.dart';
import 'package:tasky/Features/Taskes/Data/Model/task_model.dart';
import 'package:tasky/Features/Taskes/Logic/cubit/task_cubit.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TaskPriority _priority = TaskPriority.medium;
  final ImagePicker _picker = ImagePicker();

  DateTime? _selectedDate;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
          BlocProvider.of<TaskCubit>(context).dueDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null &&
        pickedDate != BlocProvider.of<TaskCubit>(context).dueDate) {
      setState(() {
        BlocProvider.of<TaskCubit>(context).dueDate = pickedDate;
      });
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    try {
      final XFile? pickedFile = await showDialog<XFile>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text("Choose Image Source"),
            actions: [
              TextButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text("Camera"),
                onPressed: () async {
                  final picked =
                      await _picker.pickImage(source: ImageSource.camera);
                  dialogContext.pop();
                  setState(() {
                    context.read<TaskCubit>().addImagePickedUrl =
                        File(picked!.path);
                  });
                  BlocProvider.of<TaskCubit>(context).uploadImageCubit(
                      imagePath: File(picked!.path), editOrAdd: 'add');
                },
              ),
              TextButton.icon(
                icon: const Icon(Icons.photo_library),
                label: const Text("Gallery"),
                onPressed: () async {
                  final picked =
                      await _picker.pickImage(source: ImageSource.gallery);
                  dialogContext.pop();
                  setState(() {
                    context.read<TaskCubit>().addImagePickedUrl =
                        File(picked!.path);
                  });
                  BlocProvider.of<TaskCubit>(context).uploadImageCubit(
                      imagePath: File(picked!.path), editOrAdd: 'add');
                },
              ),
            ],
          );
        },
      );

      if (pickedFile != null) {
        setState(() {
          context.read<TaskCubit>().imagePickedUrl = File(pickedFile.path);
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TaskCubit>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.h),
        child: _buildAppbar(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 25.h),
        child: Column(
          children: [
            _buildImagePicker(),
            verticalSpace(20),
            AppTextFormFieldWithTopHint(
              topHintText: "Task title",
              appTextFormField: AppTextFormField(
                  controller: bloc.titleController,
                  hintText: "Enter title here...",
                  validator: (valid) {},
                  keyboardType: TextInputType.text),
            ),
            verticalSpace(20),
            AppTextFormFieldWithTopHint(
              topHintText: "Task Description",
              appTextFormField: AppTextFormField(
                controller: bloc.descController,
                maxLines: 5,
                hintText: "Enter description here...",
                validator: (valid) {},
                keyboardType: TextInputType.text,
              ),
            ),
            verticalSpace(20),
            _buildPrioritySelectorDropdown(),
            verticalSpace(20),
            _buildDueDateFieldWithHint(hintText: "Due date"),
            verticalSpace(40),
            AppTextButton(
                buttonText: "Add Task",
                textStyle: TextStyles.font19WhiteBold,
                onPressed: () {
                  BlocProvider.of<TaskCubit>(context).addTaskCubit();
                }),
            _buildAddTaskBlocLisener(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppbar(BuildContext context) {
    return AppBar(
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
          Text('Add New Task', style: TextStyles.font16BlackBold),
        ],
      ),
      leadingWidth: 200.w,
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: () {
        _pickImage(context);
      },
      child: Column(
        children: [
          BlocBuilder<TaskCubit, TaskState>(
            builder: (context, state) {
              if (state is UplaodImageLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is UplaodImageSuccess) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child:
                      BlocProvider.of<TaskCubit>(context).addImagePickedUrl !=
                              null
                          ? Image.file(
                              BlocProvider.of<TaskCubit>(context)
                                  .addImagePickedUrl!,
                              fit: BoxFit.cover,
                              width: 100.w,
                              height: 100.h,
                            )
                          : const SizedBox.shrink(),
                );
              } else if (state is UplaodImageError) {
                return const Text("Something went wrong");
              }
              return const SizedBox.shrink();
            },
          ),
          DottedBorder(
              color: ColorsManager.primryColor,
              strokeWidth: 1,
              dashPattern: const [6, 3],
              borderType: BorderType.RRect,
              radius: Radius.circular(10.r),
              child: Container(
                height: 50.h,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate_outlined,
                        size: 32.r, color: ColorsManager.primryColor),
                    const SizedBox(height: 8),
                    Text('Add Img', style: TextStyles.font16PrimaryBold),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildDueDateFieldWithHint({required String hintText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(hintText, style: TextStyles.font12GrayRegular),
        verticalSpace(10),
        AppTextFormField(
          hintText: "choose due date...",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a date';
            }
            return null;
          },
          keyboardType: TextInputType.datetime,
          suffixIcon: IconButton(
            icon: Icon(
              Icons.calendar_month_outlined,
              size: 24.r,
              color: ColorsManager.primryColor,
            ),
            onPressed: () => _pickDate(context),
          ),
          readOnly: true,
          controller: TextEditingController(
              text: BlocProvider.of<TaskCubit>(context).dueDate == null
                  ? ''
                  : DateFormat('yyyy - M - d')
                      .format(BlocProvider.of<TaskCubit>(context).dueDate!)
                      .toString()),
        ),
      ],
    );
  }

  Widget _buildPrioritySelectorDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Priority",
          style: TextStyles.font12GrayRegular,
        ),
        verticalSpace(10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: ColorsManager.lightPrimryColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: BlocProvider.of<TaskCubit>(context).selectedPriority,
              isExpanded: true,
              icon: Image.asset(
                'assets/image/arrow_down.png',
                width: 24.w,
              ),
              items: ['low', 'medium', 'high'].map((priority) {
                return DropdownMenuItem<String>(
                  value: priority,
                  child: Row(
                    children: [
                      Icon(Icons.flag_outlined,
                          size: 20.r, color: ColorsManager.primryColor),
                      horizontalSpace(8),
                      Text(
                        "$priority Priority",
                        style: TextStyles.font16PrimaryBold,
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    BlocProvider.of<TaskCubit>(context).selectedPriority =
                        newValue;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddTaskBlocLisener() {
    return BlocListener<TaskCubit, TaskState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is AddTaskLoading) {
          const Center(child: CircularProgressIndicator());
        } else if (state is AddTaskSuccess) {
          context.pushNamed(Routes.taskesScreen);
        }
        if (state is AddTaskError) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Something went wrong. Makes sure your date"),
          ));
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
