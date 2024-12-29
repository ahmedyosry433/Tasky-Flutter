import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/Core/Helper/extensions.dart';
import 'package:tasky/Core/Helper/spacing.dart';
import 'package:tasky/Core/Router/routes.dart';
import 'package:tasky/Core/Theme/colors.dart';
import 'package:tasky/Core/Theme/style.dart';
import 'package:tasky/Features/Taskes/Data/Model/task_model.dart';
import 'package:tasky/Features/Taskes/Logic/cubit/task_cubit.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TaskCubit>(context).tasksListCubit();
  }

  int selectedFilter = 0;
  final List<String> filters = ['All', 'Inprogress', 'Waiting', 'Finished'];

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
                _buildAppbar(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'My Tasks',
                    style: TextStyles.font17GrayBold,
                  ),
                ),
                _buildFilter(),
                _buildCardBlocBuilder(),
              ],
            ),
            _buildFloatingActionBtn(),
            _buildBlocLisener(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task, void Function()? onTap) {
    Color statusColor;
    switch (task.status.toLowerCase()) {
      case 'waiting':
        statusColor = ColorsManager.waitingColor;
        break;
      case 'inprogress':
        statusColor = ColorsManager.primryColor;
        break;
      case 'finished':
        statusColor = Colors.blue;
        break;
      default:
        statusColor = Colors.grey;
    }

    Color priorityColor;
    switch (task.priority.toLowerCase()) {
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
                          child: Text(task.title,
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
                            task.status,
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
                      task.description,
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
                              task.priority,
                              style: TextStyle(color: priorityColor),
                            ),
                          ],
                        ),
                        Text(
                          '12/12/2024',
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
                  BlocProvider.of<TaskCubit>(context).logoutCubit();
                },
                icon: Icon(Icons.logout,
                    color: ColorsManager.primryColor, size: 25.r),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBlocLisener(BuildContext context) {
    return BlocListener<TaskCubit, TaskState>(
        listenWhen: (previous, current) {
          return previous != current;
        },
        listener: (context, state) {
          if (state is LogoutLoading) {
            const Center(child: CircularProgressIndicator());
          }
          if (state is LogoutSuccess) {
            context.pushReplacementNamed(Routes.loginScreen);
          }
          if (state is LogoutError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage,
                  style: TextStyles.font14WhiteSemiBold,
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: const SizedBox.shrink());
  }

  Widget _buildCardBlocBuilder() {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is TaskSuccess) {
          return Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: BlocProvider.of<TaskCubit>(context).tasksList.length,
              itemBuilder: (context, index) {
                return _buildTaskCard(
                    BlocProvider.of<TaskCubit>(context).tasksList[index], () {
                  context.pushNamed(Routes.taskDetailsScreen);
                });
              },
            ),
          );
        }
        if (state is TaskError) {
          return Center(
            child: Text(state.errorMessage.toString()),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFloatingActionBtn() {
    return Positioned(
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
    );
  }

  Widget _buildFilter() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
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
                    BlocProvider.of<TaskCubit>(context)
                        .filterTasksByStatus(filters[index]);
                  });
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
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
    );
  }
}
