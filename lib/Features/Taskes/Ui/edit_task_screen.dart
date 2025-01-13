// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasky/Core/Helper/extensions.dart';
import 'package:tasky/Core/Helper/spacing.dart';
import 'package:tasky/Core/Router/routes.dart';
import 'package:tasky/Core/Theme/colors.dart';
import 'package:tasky/Core/Theme/style.dart';
import 'package:tasky/Core/Widgets/app_appbar.dart';
import 'package:tasky/Core/Widgets/app_text_button.dart';
import 'package:tasky/Core/Widgets/app_text_form_field.dart';
import 'package:tasky/Core/Widgets/app_text_form_field_with_hint.dart';
import 'package:tasky/Features/Taskes/Data/Model/task_model.dart';
import 'package:tasky/Features/Taskes/Logic/cubit/task_cubit.dart';

// ignore: must_be_immutable
class EditTaskScreen extends StatefulWidget {
  EditTaskScreen({super.key, required this.task});
  TaskModel task;

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final ImagePicker _picker = ImagePicker();

  late final TaskCubit _taskCubit;

  @override
  void initState() {
    super.initState();
    _taskCubit = context.read<TaskCubit>();
    selectedStatus = widget.task.status;
    selectedPriority = widget.task.priority;
  }

  String? selectedStatus;
  String? selectedPriority;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.h),
        child: AppAppbar(type: 'editTask', screenTitle: 'Edit Task'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 25.h),
        child: Column(
          children: [
            _buildSelectedImage(),
            verticalSpace(20),
            _buildImagePicker(),
            verticalSpace(20),
            _buildEditTaskForm(),
            _buildEditBlocLisener(),
          ],
        ),
      ),
    );
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

        if (state is UplaodImageSuccess || state is OneTaskSuccess) {
          if (_taskCubit.editImagePickedUrl != null) {
            return Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Image.file(
                _taskCubit.editImagePickedUrl!,
                fit: BoxFit.cover,
                width: 150.w,
                height: 120.h,
              ),
            );
          } else {}
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
            Text('Edit Img', style: TextStyles.font16PrimaryBold),
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
        _taskCubit.editImagePickedUrl = File(pickedFile.path);
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
            _taskCubit.editImagePickedUrl = imageFile;
          });
          _taskCubit.uploadImageCubit(imagePath: imageFile, editOrAdd: 'edit');
        }
      },
    );
  }

  Widget _buildEditTaskForm() {
    TextEditingController titleController =
        TextEditingController(text: widget.task.title);
    TextEditingController descController =
        TextEditingController(text: widget.task.description);

    return Form(
        child: Column(
      children: [
        AppTextFormFieldWithTopHint(
          topHintText: 'Title',
          appTextFormField: AppTextFormField(
            hintText: 'Enter Title',
            validator: (validator) {},
            keyboardType: TextInputType.text,
            controller: titleController,
          ),
        ),
        verticalSpace(20),
        AppTextFormFieldWithTopHint(
          topHintText: 'Description',
          appTextFormField: AppTextFormField(
            hintText: 'Enter Description',
            validator: (validator) {},
            keyboardType: TextInputType.text,
            controller: descController,
            maxLines: 5,
          ),
        ),
        verticalSpace(20),
        _buildSelector(['Low', 'Medium', 'High'], selectedPriority!, "Priority",
            (vale) {
          setState(() {
            selectedPriority = vale;
          });
        }),
        verticalSpace(20),
        _buildSelector(
            ['Waiting', 'Inprogress', 'Finished'], selectedStatus!, "Status",
            (value) {
          setState(() {
            selectedStatus = value;
          });
        }),
        verticalSpace(40),
        _buildEditTaskButton(
          titleController: titleController,
          descController: descController,
          selectedPriority: selectedPriority!,
          selectedStatus: selectedStatus!,
        ),
      ],
    ));
  }

  Widget _buildSelector(List<String> items, String selectorType, String lable,
      ValueChanged<String> onItemSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lable, style: TextStyles.font12GrayRegular),
        verticalSpace(10),
        _buildDropdown(items, selectorType, onItemSelected),
      ],
    );
  }

  Widget _buildDropdown(List<String> items, String selectorType,
      ValueChanged<String> onItemSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: ColorsManager.lightPrimryColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectorType,
          isExpanded: true,
          icon: Image.asset('assets/image/arrow_down.png', width: 24.w),
          items: _buildItems(items),
          onChanged: (newValue) {
            if (newValue != null) {
              setState(() {
                selectorType = newValue;
                onItemSelected(newValue);
              });
            }
          },
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildItems(List<String> items) {
    return items.map((value) {
      return DropdownMenuItem<String>(
        value: value.toLowerCase(),
        child: Row(
          children: [
            horizontalSpace(8),
            Text(
              value,
              style: TextStyles.font16PrimaryBold,
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildEditTaskButton({
    required TextEditingController titleController,
    required TextEditingController descController,
    required String selectedPriority,
    required String selectedStatus,
  }) {
    return AppTextButton(
      buttonText: "Edit Task",
      textStyle: TextStyles.font19WhiteBold,
      onPressed: () {
        BlocProvider.of<TaskCubit>(context).editTaskCubit(
          task: TaskModel(
              id: widget.task.id,
              title: titleController.text,
              description: descController.text,
              priority: selectedPriority,
              imageUrl:
                  BlocProvider.of<TaskCubit>(context).editImageUploadedName ??
                      widget.task.imageUrl,
              status: selectedStatus,
              userId: widget.task.userId),
        );
      },
    );
  }

  Widget _buildEditBlocLisener() {
    return BlocListener<TaskCubit, TaskState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is EditTaskLoading) {
            const Center(child: CircularProgressIndicator());
          } else if (state is EditTaskSuccess) {
            context.pushNamed(Routes.taskDetailsScreen, arguments: state.task);
          } else if (state is EditTaskError) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Something went wrong."),
            ));
          }
        },
        child: const SizedBox.shrink());
  }
}
