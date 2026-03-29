import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:task_manager_app/models/task_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;
  
  // In-memory storage for web platform
  static List<Map<String, dynamic>> _webTasks = [];
  static List<Map<String, dynamic>> _webSubTasks = [];
  static int _webTaskIdCounter = 1;
  static int _webSubTaskIdCounter = 1;

  Future<Database> get database async {
    if (kIsWeb) {
      throw UnsupportedError('Database not supported on web');
    }
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'task_manager.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        dueDate TEXT NOT NULL,
        isCompleted INTEGER NOT NULL,
        repeatType TEXT,
        repeatDays TEXT,
        progress REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE subtasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        taskId INTEGER NOT NULL,
        title TEXT NOT NULL,
        isCompleted INTEGER NOT NULL,
        FOREIGN KEY (taskId) REFERENCES tasks (id) ON DELETE CASCADE
      )
    ''');
  }

  // Task CRUD
  Future<int> insertTask(Task task) async {
    if (kIsWeb) {
      final taskMap = task.toMap();
      taskMap['id'] = _webTaskIdCounter++;
      _webTasks.add(taskMap);
      return taskMap['id'] as int;
    }
    Database db = await database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks() async {
    if (kIsWeb) {
      return _webTasks.map((e) => Task.fromMap(e)).toList();
    }
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('tasks');
    return maps.map((e) => Task.fromMap(e)).toList();
  }

  Future<int> updateTask(Task task) async {
    if (kIsWeb) {
      final index = _webTasks.indexWhere((t) => t['id'] == task.id);
      if (index != -1) {
        _webTasks[index] = task.toMap();
        return 1;
      }
      return 0;
    }
    Database db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    if (kIsWeb) {
      _webTasks.removeWhere((t) => t['id'] == id);
      _webSubTasks.removeWhere((st) => st['taskId'] == id);
      return 1;
    }
    Database db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // SubTask CRUD
  Future<int> insertSubTask(SubTask subTask) async {
    if (kIsWeb) {
      final subTaskMap = subTask.toMap();
      subTaskMap['id'] = _webSubTaskIdCounter++;
      _webSubTasks.add(subTaskMap);
      return subTaskMap['id'] as int;
    }
    Database db = await database;
    return await db.insert('subtasks', subTask.toMap());
  }

  Future<List<SubTask>> getSubTasks(int taskId) async {
    if (kIsWeb) {
      return _webSubTasks
          .where((st) => st['taskId'] == taskId)
          .map((e) => SubTask.fromMap(e))
          .toList();
    }
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'subtasks',
      where: 'taskId = ?',
      whereArgs: [taskId],
    );
    return maps.map((e) => SubTask.fromMap(e)).toList();
  }

  Future<int> updateSubTask(SubTask subTask) async {
    if (kIsWeb) {
      final index = _webSubTasks.indexWhere((st) => st['id'] == subTask.id);
      if (index != -1) {
        _webSubTasks[index] = subTask.toMap();
        return 1;
      }
      return 0;
    }
    Database db = await database;
    return await db.update(
      'subtasks',
      subTask.toMap(),
      where: 'id = ?',
      whereArgs: [subTask.id],
    );
  }

  Future<int> deleteSubTask(int id) async {
    if (kIsWeb) {
      _webSubTasks.removeWhere((st) => st['id'] == id);
      return 1;
    }
    Database db = await database;
    return await db.delete(
      'subtasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
