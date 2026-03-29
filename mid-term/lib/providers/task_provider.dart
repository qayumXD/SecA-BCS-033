import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/database/db_helper.dart';
import 'package:task_manager_app/models/task_model.dart';
import 'package:task_manager_app/services/notification_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  final DBHelper _dbHelper = DBHelper();
  final NotificationService _notificationService = NotificationService();

  List<Task> get tasks => _tasks;

  List<Task> get allPendingTasks => _tasks.where((task) => !task.isCompleted).toList();

  List<Task> get todayTasks {
    final now = DateTime.now();
    return _tasks.where((task) {
      return !task.isCompleted &&
          task.dueDate.year == now.year &&
          task.dueDate.month == now.month &&
          task.dueDate.day == now.day;
    }).toList();
  }

  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList();

  List<Task> get repeatedTasks => _tasks.where((task) => task.repeatType != 'none').toList();

  Future<void> fetchTasks() async {
    _tasks = await _dbHelper.getTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task, List<SubTask> subTasks) async {
    int taskId = await _dbHelper.insertTask(task);
    task.id = taskId;
    for (var subTask in subTasks) {
      subTask.taskId = taskId;
      await _dbHelper.insertSubTask(subTask);
    }
    
    // Schedule notification (only on mobile platforms)
    if (!kIsWeb) {
      await _notificationService.scheduleNotification(task);
    }
    
    await fetchTasks();
  }

  Future<void> updateTask(Task task) async {
    await _dbHelper.updateTask(task);
    if (!kIsWeb) {
      await _notificationService.scheduleNotification(task);
    }
    await fetchTasks();
  }

  Future<void> deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
    if (!kIsWeb) {
      await _notificationService.cancelNotification(id);
    }
    await fetchTasks();
  }

  Future<void> toggleTaskCompletion(Task task) async {
    task.isCompleted = !task.isCompleted;
    if (task.isCompleted) {
      if (!kIsWeb) {
        await _notificationService.cancelNotification(task.id!);
      }
      
      // Handle repeat logic
      if (task.repeatType != 'none') {
        _handleRepeatTask(task);
      }
    } else {
      if (!kIsWeb) {
        await _notificationService.scheduleNotification(task);
      }
    }
    await _dbHelper.updateTask(task);
    await fetchTasks();
  }

  void _handleRepeatTask(Task task) async {
    DateTime nextDueDate;
    if (task.repeatType == 'daily') {
      nextDueDate = task.dueDate.add(const Duration(days: 1));
    } else if (task.repeatType == 'weekly') {
      nextDueDate = task.dueDate.add(const Duration(days: 7));
    } else {
      return;
    }

    final newTask = Task(
      title: task.title,
      description: task.description,
      dueDate: nextDueDate,
      repeatType: task.repeatType,
      repeatDays: task.repeatDays,
    );

    List<SubTask> subTasks = await _dbHelper.getSubTasks(task.id!);
    List<SubTask> newSubTasks = subTasks.map((st) => SubTask(taskId: 0, title: st.title)).toList();

    await addTask(newTask, newSubTasks);
  }

  Future<List<SubTask>> getSubTasks(int taskId) async {
    return await _dbHelper.getSubTasks(taskId);
  }

  Future<void> updateSubTask(SubTask subTask) async {
    await _dbHelper.updateSubTask(subTask);
    
    List<SubTask> allSubTasks = await _dbHelper.getSubTasks(subTask.taskId);
    int completedCount = allSubTasks.where((st) => st.isCompleted).length;
    double progress = allSubTasks.isEmpty ? 0.0 : completedCount / allSubTasks.length;
    
    int index = _tasks.indexWhere((t) => t.id == subTask.taskId);
    if (index != -1) {
      _tasks[index].progress = progress;
      await _dbHelper.updateTask(_tasks[index]);
    }
    notifyListeners();
  }
}
