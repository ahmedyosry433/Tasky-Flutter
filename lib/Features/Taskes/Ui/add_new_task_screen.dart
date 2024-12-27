import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/Core/Helper/extensions.dart';
import 'package:tasky/Core/Helper/spacing.dart';
import 'package:tasky/Core/Theme/style.dart';
import 'package:tasky/Core/Widgets/app_text_button.dart';
import 'package:tasky/Core/Widgets/app_text_form_field.dart';
import 'package:tasky/Core/theme/colors.dart';
import 'package:tasky/Features/Taskes/Data/Model/task_model.dart';

class TaskCreationScreen extends StatefulWidget {
  const TaskCreationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TaskCreationScreenState createState() => _TaskCreationScreenState();
}

class _TaskCreationScreenState extends State<TaskCreationScreen> {
  TaskPriority _priority = TaskPriority.medium;

  DateTime? _selectedDate;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000), // Earliest date that can be selected
      lastDate: DateTime(2100), // Latest date that can be selected
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            AppTextFormField(
                hintText: "Enter title here...",
                validator: (valid) {},
                keyboardType: TextInputType.text),
            verticalSpace(20),
            AppTextFormField(
              maxLines: 5,
              hintText: "Enter description here...",
              validator: (valid) {},
              keyboardType: TextInputType.text,
            ),
            verticalSpace(20),
            _buildPrioritySelector(),
            verticalSpace(20),
            _buildDueDateField(),
            verticalSpace(40),
            AppTextButton(
                buttonText: "Add Task",
                textStyle: TextStyles.font14WhiteSemiBold,
                onPressed: () {})
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: () {},
      child: DottedBorder(
          color: ColorsManager.primryColor, // Border color
          strokeWidth: 1, // Border width
          dashPattern: const [6, 3], // Pattern: 6px dash, 3px gap
          borderType: BorderType.RRect, // Rounded rectangle border
          radius: Radius.circular(10.r), // Corner radius
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
    );
  }

  Widget _buildDueDateField() {
    return AppTextFormField(
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
          text: _selectedDate == null ? '' : _selectedDate.toString()),
    );
  }

  Widget _buildPrioritySelector() {
    return _buildPrioritySelectorDropdown(
      priority: _priority,
      onChanged: (value) => setState(() => _priority = value),
    );
  }

  Widget _buildPrioritySelectorDropdown(
      {required TaskPriority priority,
      required ValueChanged<TaskPriority> onChanged}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: ColorsManager.lightPrimryColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TaskPriority>(
          value: priority,
          isExpanded: true,
          icon: Image.asset(
            'assets/image/arrow_down.png',
            width: 24.w,
          ),
          items: TaskPriority.values.map((TaskPriority priority) {
            return DropdownMenuItem<TaskPriority>(
              value: priority,
              child: Row(
                children: [
                  Icon(Icons.flag_outlined,
                      size: 20.r, color: ColorsManager.primryColor),
                  horizontalSpace(8),
                  Text(
                    priority.displayName,
                    style: TextStyles.font14PrimarySemiBold,
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (TaskPriority? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
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
            icon: Image.asset('assets/image/arrow_to_left.png'),
          ),
          Text('Add New Task', style: TextStyles.font18BlackBold),
        ],
      ),
      leadingWidth: 200.w,
    );
  }
}
