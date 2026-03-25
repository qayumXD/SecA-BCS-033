class Task {
  int? id;
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;
  String? repeatType; // 'none', 'daily', 'weekly'
  List<int>? repeatDays; // [1, 2, 3] for Mon, Tue, Wed
  double progress;

  Task({
    this.id,
    required this.title,
    this.description = '',
    required this.dueDate,
    this.isCompleted = false,
    this.repeatType = 'none',
    this.repeatDays,
    this.progress = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'repeatType': repeatType,
      'repeatDays': repeatDays?.join(','),
      'progress': progress,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      isCompleted: map['isCompleted'] == 1,
      repeatType: map['repeatType'],
      repeatDays: map['repeatDays'] != null && map['repeatDays'].toString().isNotEmpty
          ? map['repeatDays'].toString().split(',').map((e) => int.parse(e)).toList()
          : null,
      progress: map['progress'] ?? 0.0,
    );
  }
}

class SubTask {
  int? id;
  int taskId;
  String title;
  bool isCompleted;

  SubTask({
    this.id,
    required this.taskId,
    required this.title,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'title': title,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory SubTask.fromMap(Map<String, dynamic> map) {
    return SubTask(
      id: map['id'],
      taskId: map['taskId'],
      title: map['title'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
