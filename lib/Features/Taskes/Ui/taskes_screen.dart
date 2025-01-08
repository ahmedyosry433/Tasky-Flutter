// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';
import 'package:tasky/Core/Helper/extensions.dart';
import 'package:tasky/Core/Helper/spacing.dart';
import 'package:tasky/Core/Networking/api_constants.dart';
import 'package:tasky/Core/Router/routes.dart';
import 'package:tasky/Core/Theme/colors.dart';
import 'package:tasky/Core/Theme/font_weight_helper.dart';
import 'package:tasky/Core/Theme/style.dart';
import 'package:tasky/Core/Widgets/app_cached_network_image.dart';
import 'package:tasky/Features/Taskes/Data/Model/task_model.dart';
import 'package:tasky/Features/Taskes/Logic/cubit/task_cubit.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;

  bool isScanning = false;

  int selectedFilter = 0;
  final List<String> filters = ['All', 'Inprogress', 'Waiting', 'Finished'];
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TaskCubit>(context).tasksListCubit(pageNum: 1);

    _setupScroll();
  }

  _setupScroll() {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          if (BlocProvider.of<TaskCubit>(context).newTasksList.isNotEmpty) {
            BlocProvider.of<TaskCubit>(context)
                .tasksListCubit(pageNum: currentPage);
            currentPage++;
          } else {
            return;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<TaskCubit>(context).tasksListCubit(pageNum: 1);

        _setupScroll();
        setState(() {
          currentPage = 1;
          selectedFilter = 0;
        });
      },
      child: Scaffold(
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
                      style: TextStyles.font16GrayBold,
                    ),
                  ),
                  _buildFilter(),
                  _buildCardBlocBuilder(),
                ],
              ),
              _buildFloatingActionBtn(),
              _buildLogoutBlocLisener(context),
              _buildDeleteBlocLisener(),
              _buildEditBlocLisener(),
              _buildQrCodeBlocLisener(),
            ],
          ),
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
        context.pushNamed(Routes.taskDetailsScreen, arguments: task);
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
              SizedBox(
                width: 50.w,
                height: 50.h,
                child: AppCasedNetworkImage(
                  imageUrl:
                      '${ApiConstants.apiBaseUrl}${ApiConstants.getImageUrl}${task.imageUrl}',
                  fit: BoxFit.cover,
                  width: 50.w,
                  height: 50.h,
                ),
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
                              style: TextStyles.font16BlackBold),
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
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeightHelper.regular,
                                color: statusColor),
                          ),
                        ),
                        horizontalSpace(2),
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
                              showEditDialog(context, task);
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
                                          dialogContext
                                              .pop(); // Close the dialog
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          BlocProvider.of<TaskCubit>(context)
                                              .deleteTaskCubit(taskId: task.id);
                                          dialogContext
                                              .pop(); // Close the dialog
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
                              child: Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
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
              horizontalSpace(10),
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

  Widget _buildLogoutBlocLisener(BuildContext context) {
    return BlocListener<TaskCubit, TaskState>(
        listenWhen: (previous, current) {
          return previous != current;
        },
        listener: (context, state) {
          if (state is LogoutLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
          if (state is LogoutSuccess) {
            context.pop();
            context.pushReplacementNamed(Routes.loginScreen);
          }
          if (state is LogoutError) {
            context.pop();
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
        if (state is TaskLoading && currentPage == 1) {
          return const Center(child: CircularProgressIndicator());
        }

        final tasks = BlocProvider.of<TaskCubit>(context).tasksList;
        final newTasks = BlocProvider.of<TaskCubit>(context).newTasksList;
        final screenHeight = MediaQuery.of(context).size.height;
        const taskItemHeight = 100.0;
        final totalTasksHeight = tasks.length * taskItemHeight;

        return Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: tasks.length + (totalTasksHeight < screenHeight ? 0 : 1),
            itemBuilder: (context, index) {
              if (index < tasks.length) {
                return _buildTaskCard(tasks[index], () {
                  context.pushNamed(Routes.taskDetailsScreen,
                      arguments: tasks[index]);
                });
              } else if (newTasks.isEmpty) {
                return const SizedBox.shrink();
              } else {
                return Padding(
                  padding: EdgeInsets.all(16.r),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        );
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
            onPressed: _showScanner,
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
              context.pushNamed(Routes.addTaskScreen);
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
        height: 40.h,
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
                    style: selectedFilter == index
                        ? TextStyles.font16WhiteBold
                        : TextStyles.font16GrayRegular,
                  ),
                ),
              );
            }),
      ),
    );
  }

  void showEditDialog(BuildContext context, TaskModel task) {
    TextEditingController titleController =
        TextEditingController(text: task.title);
    TextEditingController descController =
        TextEditingController(text: task.description);
    String selectedPriority = task.priority;
    String selectedStatus = task.status;
    String imagePath = task.imageUrl;

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
                        imagePath = File(pickedFile.path).path;
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
                          .editImageUploadedName!,
                      status: selectedStatus,
                      userId: task.userId),
                );

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

  Widget _buildDeleteBlocLisener() {
    return BlocListener<TaskCubit, TaskState>(
      listener: (context, state) {
        if (state is DeleteTaskLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return const Center(child: CircularProgressIndicator());
            },
          );
        } else if (state is DeleteTaskSuccess) {
          context.pop();
          context.pushReplacementNamed(Routes.taskesScreen);
        } else if (state is DeleteTaskError) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Something went wrong."),
          ));
        }
      },
      child: const SizedBox.shrink(),
    );
  }

  Widget _buildEditBlocLisener() {
    return BlocListener<TaskCubit, TaskState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is EditTaskLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          } else if (state is EditTaskSuccess) {
            context.pop();
            BlocProvider.of<TaskCubit>(context)
                .tasksListCubit(pageNum: currentPage);
          } else if (state is EditTaskError) {
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Something went wrong."),
            ));
          }
        },
        child: const SizedBox.shrink());
  }

  void _showScanner() {
    setState(() {
      isScanning = true;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BottmSheetcontext) => Container(
        height: MediaQuery.of(BottmSheetcontext).size.height * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            AppBar(
              backgroundColor: ColorsManager.lightPrimryColor,
              elevation: 0,
              title: const Text('Scan QR Code'),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(BottmSheetcontext);
                  setState(() {
                    isScanning = false;
                  });
                },
              ),
            ),
            Expanded(
              child: QRCodeDartScanView(
                scanInvertedQRCode: true,
                typeScan: TypeScan.takePicture,
                formats: const [
                  BarcodeFormat.qrCode,
                  BarcodeFormat.aztec,
                  BarcodeFormat.dataMatrix,
                  BarcodeFormat.pdf417,
                  BarcodeFormat.code39,
                  BarcodeFormat.code93,
                  BarcodeFormat.code128,
                  BarcodeFormat.ean8,
                  BarcodeFormat.ean13,
                ],
                onCapture: (Result result) {
                  setState(() {
                    isScanning = false;
                  });

                  BlocProvider.of<TaskCubit>(context)
                      .addTaskByQrCode(scannedResult: result.text);
                  BottmSheetcontext.pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrCodeBlocLisener() {
    return BlocListener<TaskCubit, TaskState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is AddTaskByQrCodeLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          } else if (state is AddTaskByQrCodeSuccess) {
            context.pop();
            BlocProvider.of<TaskCubit>(context)
                .tasksListCubit(pageNum: currentPage);
            // context.pushNamed(Routes.taskesScreen);
            context.pop();
          } else if (state is AddTaskByQrCodeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Scanned: ${state.errorMessage}')),
            );
          }
        },
        child: const SizedBox.shrink());
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }
}
