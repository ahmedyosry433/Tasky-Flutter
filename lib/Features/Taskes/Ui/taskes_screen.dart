import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/Core/Helper/extensions.dart';
import 'package:tasky/Core/Helper/spacing.dart';
import 'package:tasky/Core/Router/routes.dart';
import 'package:tasky/Core/Theme/colors.dart';
import 'package:tasky/Core/Theme/style.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  int selectedFilter = 0;
  final List<String> filters = ['All', 'Inprogress', 'Waiting', 'Finished'];

  // Sample task data
  final List<Map<String, dynamic>> tasks = [
    {
      'title': 'Grocery Shopping...',
      'description': 'This application is designed for s...',
      'priority': 'Medium',
      'status': 'Waiting',
      'date': '30/12/2022'
    },
    {
      'title': 'Grocery Shopping...',
      'description': 'This application is designed for s...',
      'priority': 'Low',
      'status': 'Waiting',
      'date': '30/12/2022'
    },
    {
      'title': 'Grocery Shopping...',
      'description': 'This application is designed for s...',
      'priority': 'High',
      'status': 'Inprogress',
      'date': '30/12/2022'
    },
    {
      'title': 'Grocery Shopping...',
      'description': 'This application is designed for s...',
      'priority': 'Medium',
      'status': 'Finished',
      'date': '30/12/2022'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Bar
                _buildAppbar(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'My Tasks',
                    style: TextStyles.font17GrayBold,
                  ),
                ),

                // Filter Chips
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                  child: SizedBox(
                    height: 37.h,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: filters.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              setState(() {
                                selectedFilter = index;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14.w, vertical: 10.h),
                              margin: EdgeInsets.only(right: 5.w),
                              decoration: BoxDecoration(
                                color: selectedFilter == index
                                    ? ColorsManager.primryColor
                                    : ColorsManager.lightPrimryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                filters[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: selectedFilter == index
                                      ? ColorsManager.whiteColor
                                      : ColorsManager.grayColor,
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                // Task List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return _buildTaskCard(task, () {
                        context.pushNamed(Routes.taskDetailsScreen);
                      });
                    },
                  ),
                ),
              ],
            ),
            // Floating Action Buttons
            Positioned(
              bottom: 16.h,
              right: 16.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    heroTag: 'qr',
                    onPressed: () {},
                    backgroundColor: ColorsManager.lightPrimryColor,
                    mini: true,
                    child: const Icon(
                      Icons.qr_code,
                      color: ColorsManager.primryColor,
                    ),
                  ),
                  verticalSpace(8),
                  FloatingActionButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    heroTag: 'add',
                    onPressed: () {
                      context.pushNamed(Routes.taskCreationScreen);
                    },
                    backgroundColor: ColorsManager.primryColor,
                    child: const Icon(
                      Icons.add,
                      color: ColorsManager.whiteColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppbar() {
    return Padding(
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
              horizontalSpace(16),
              IconButton(
                onPressed: () {
                  context.pushNamed(Routes.loginScreen);
                },
                icon: Icon(Icons.logout,
                    color: ColorsManager.primryColor, size: 25.r),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task, void Function()? onTap) {
    Color statusColor;
    switch (task['status']) {
      case 'Waiting':
        statusColor = ColorsManager.waitingColor;
        break;
      case 'Inprogress':
        statusColor = ColorsManager.primryColor;
        break;
      case 'Finished':
        statusColor = Colors.blue;
        break;
      default:
        statusColor = Colors.grey;
    }

    Color priorityColor;
    switch (task['priority'].toString().toLowerCase()) {
      case 'high':
        priorityColor = Colors.orange;
        break;
      case 'medium':
        priorityColor = ColorsManager.primryColor;
        break;
      case 'low':
        priorityColor = Colors.blue;
        break;
      default:
        priorityColor = Colors.grey;
    }

    return GestureDetector(
      onTap: () {
        context.pushNamed(Routes.taskDetailsScreen);
      },
      child: Card(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.only(bottom: 16.h),
        child: Padding(
          padding: EdgeInsets.all(10.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/image/task_img.png',
                width: 50.w,
                height: 50.h,
              ),
              horizontalSpace(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(task['title'],
                              style: TextStyles.font14BlackBold),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            task['status'],
                            style: TextStyle(color: statusColor),
                          ),
                        ),
                        horizontalSpace(2),
                        GestureDetector(
                            onTap: () {}, child: const Icon(Icons.more_vert)),
                      ],
                    ),
                    verticalSpace(7),
                    Text(
                      task['description'],
                      style: TextStyles.font14GrayRegular,
                    ),
                    verticalSpace(7),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.flag_outlined,
                                size: 16, color: priorityColor),
                            horizontalSpace(4),
                            Text(
                              task['priority'],
                              style: TextStyle(color: priorityColor),
                            ),
                          ],
                        ),
                        Text(
                          task['date'],
                          style: TextStyles.font14GrayRegular,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
