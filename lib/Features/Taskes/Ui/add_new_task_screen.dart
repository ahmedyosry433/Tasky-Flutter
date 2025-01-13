// ignore_for_file: use_build_context_synchronously

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
import 'package:tasky/Core/Theme/colors.dart';
import 'package:tasky/Core/Theme/style.dart';
import 'package:tasky/Core/Widgets/app_appbar.dart';
import 'package:tasky/Core/Widgets/app_text_button.dart';
import 'package:tasky/Core/Widgets/app_text_form_field.dart';
import 'package:tasky/Core/Widgets/app_text_form_field_with_hint.dart';
import 'package:tasky/Features/Taskes/Logic/cubit/task_cubit.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final ImagePicker _picker = ImagePicker();
  late final TaskCubit _taskCubit;

  @override
  void initState() {
    super.initState();
    _taskCubit = context.read<TaskCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.h),
        child: AppAppbar(type: 'add Task', screenTitle: "Add New Task"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 25.h),
        child: Column(
          children: [
            _buildImagePicker(),
            verticalSpace(20),
            _buildTaskForm(),
            verticalSpace(40),
            _buildAddTaskButton(),
            _buildAddTaskListener(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskForm() {
    return Column(
      children: [
        _buildTitleField(),
        verticalSpace(20),
        _buildDescriptionField(),
        verticalSpace(20),
        _buildPrioritySelector(),
        verticalSpace(20),
        _buildDueDateField(),
      ],
    );
  }

  Widget _buildTitleField() {
    return AppTextFormFieldWithTopHint(
      topHintText: "Task title",
      appTextFormField: AppTextFormField(
        controller: _taskCubit.titleController,
        hintText: "Enter title here...",
        validator: _validateRequired,
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget _buildDescriptionField() {
    return AppTextFormFieldWithTopHint(
      topHintText: "Task Description",
      appTextFormField: AppTextFormField(
        controller: _taskCubit.descController,
        maxLines: 5,
        hintText: "Enter description here...",
        validator: _validateRequired,
        keyboardType: TextInputType.text,
      ),
    );
  }

  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: () => _showImagePickerDialog(),
      child: Column(
        children: [
          _buildSelectedImage(),
          _buildImagePickerButton(),
        ],
      ),
    );
  }

  Widget _buildSelectedImage() {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if (state is UplaodImageLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is UplaodImageSuccess &&
            _taskCubit.addImagePickedUrl != null) {
          return Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: Image.file(
              _taskCubit.addImagePickedUrl!,
              fit: BoxFit.cover,
              width: 100.w,
              height: 100.h,
            ),
          );
        }

        if (state is UplaodImageError) {
          return const Text("Something went wrong");
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildImagePickerButton() {
    return DottedBorder(
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
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 32.r,
              color: ColorsManager.primryColor,
            ),
            horizontalSpace(8),
            Text('Add Img', style: TextStyles.font16PrimaryBold),
          ],
        ),
      ),
    );
  }

  Future<void> _showImagePickerDialog() async {
    final XFile? pickedFile = await showDialog<XFile>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text("Choose Image Source"),
        actions: [
          _buildImageSourceButton(
            icon: Icons.camera_alt,
            label: "Camera",
            source: ImageSource.camera,
          ),
          _buildImageSourceButton(
            icon: Icons.photo_library,
            label: "Gallery",
            source: ImageSource.gallery,
          ),
        ],
      ),
    );

    if (pickedFile != null) {
      setState(() {
        _taskCubit.addImagePickedUrl = File(pickedFile.path);
      });
    }
  }

  Widget _buildImageSourceButton({
    required IconData icon,
    required String label,
    required ImageSource source,
  }) {
    return TextButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: () async {
        final picked = await _picker.pickImage(source: source);
        if (picked != null) {
          context.pop();
          final imageFile = File(picked.path);
          setState(() {
            _taskCubit.addImagePickedUrl = imageFile;
          });
          _taskCubit.uploadImageCubit(imagePath: imageFile, editOrAdd: 'add');
        }
      },
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Priority", style: TextStyles.font12GrayRegular),
        verticalSpace(10),
        _buildPriorityDropdown(),
      ],
    );
  }

  Widget _buildPriorityDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: ColorsManager.lightPrimryColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _taskCubit.selectedPriority,
          isExpanded: true,
          icon: Image.asset('assets/image/arrow_down.png', width: 24.w),
          items: _buildPriorityItems(),
          onChanged: (newValue) {
            if (newValue != null) {
              setState(() {
                _taskCubit.selectedPriority = newValue;
              });
            }
          },
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildPriorityItems() {
    return ['low', 'medium', 'high'].map((priority) {
      return DropdownMenuItem<String>(
        value: priority,
        child: Row(
          children: [
            Icon(
              Icons.flag_outlined,
              size: 20.r,
              color: ColorsManager.primryColor,
            ),
            horizontalSpace(8),
            Text(
              "$priority Priority",
              style: TextStyles.font16PrimaryBold,
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildDueDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Due date", style: TextStyles.font12GrayRegular),
        verticalSpace(10),
        AppTextFormField(
          hintText: "choose due date...",
          validator: _validateRequired,
          keyboardType: TextInputType.datetime,
          suffixIcon: _buildDatePickerIcon(),
          readOnly: true,
          controller: _buildDateController(),
        ),
      ],
    );
  }

  TextEditingController _buildDateController() {
    return TextEditingController(
      text: _taskCubit.dueDate == null
          ? ''
          : DateFormat('yyyy - M - d').format(_taskCubit.dueDate!),
    );
  }

  Widget _buildDatePickerIcon() {
    return IconButton(
      icon: Icon(
        Icons.calendar_month_outlined,
        size: 24.r,
        color: ColorsManager.primryColor,
      ),
      onPressed: () => _showDatePicker(),
    );
  }

  Future<void> _showDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _taskCubit.dueDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _taskCubit.dueDate) {
      setState(() {
        _taskCubit.dueDate = pickedDate;
      });
    }
  }

  Widget _buildAddTaskButton() {
    return AppTextButton(
        buttonText: "Add Task",
        textStyle: TextStyles.font19WhiteBold,
        onPressed: () {
          _taskCubit.addTaskCubit();
        });
  }

  Widget _buildAddTaskListener() {
    return BlocListener<TaskCubit, TaskState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is AddTaskSuccess) {
          context.pushReplacementNamed(Routes.taskDetailsScreen,
              arguments: state.task);
        } else if (state is AddTaskError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text("Something went wrong. Make sure your date is valid"),
            ),
          );
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
