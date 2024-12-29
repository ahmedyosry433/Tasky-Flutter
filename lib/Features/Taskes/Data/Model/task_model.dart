class TaskModel {
  final String id;
  final String title;
  final String description;
  final String priority;
  final String imageUrl;
  final String status;
  final String userId;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.imageUrl,
    required this.status,
    required this.userId,
  });
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['_id'],
      title: json['title'],
      description: json['desc'],
      priority: json['priority'],
      imageUrl: json['image'],
      status: json['status'],
      userId: json['user'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'desc': description,
      'priority': priority,
      'image': imageUrl,
      'status': status,
      'user': userId,
    };
  }
}

class AddTaskModel {
  String image;
  String title;
  String desc;
  String priority;
  String dueDate;

  AddTaskModel({
    required this.image,
    required this.title,
    required this.desc,
    required this.priority,
    required this.dueDate,
  });

  factory AddTaskModel.fromJson(Map<String, dynamic> json) {
    return AddTaskModel(
      image: json['image'],
      title: json['title'],
      desc: json['desc'],
      priority: json['priority'],
      dueDate: json['dueDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'title': title,
      'desc': desc,
      'priority': priority,
      'dueDate': dueDate,
    };
  }
}

enum TaskPriority {
  low,
  medium,
  high;

  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Low Priority';
      case TaskPriority.medium:
        return 'Medium Priority';
      case TaskPriority.high:
        return 'High Priority';
    }
  }
}
