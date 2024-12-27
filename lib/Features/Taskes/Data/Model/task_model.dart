class Task {
  final String title;
  final String description;
  final TaskPriority priority;
  final DateTime? dueDate;
  final String? imageUrl;

  Task({
    required this.title,
    required this.description,
    required this.priority,
    this.dueDate,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'priority': priority.index,
      'dueDate': dueDate?.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'],
      priority: TaskPriority.values[json['priority']],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      imageUrl: json['imageUrl'],
    );
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