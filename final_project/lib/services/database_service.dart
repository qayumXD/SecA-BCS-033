import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;
  
  // In-memory fallback for Web/Desktop during testing
  final List<Map<String, dynamic>> _webMockSessions = [];

  Future<Database?> get database async {
    if (kIsWeb) return null; // SQLite is not supported natively on Web
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'pomodoro_local.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE local_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        duration_minutes INTEGER NOT NULL,
        completed INTEGER NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  // Session operations
  Future<void> insertSession(Map<String, dynamic> session) async {
    if (kIsWeb) {
      _webMockSessions.insert(0, {
        ...session,
        'id': _webMockSessions.length + 1,
        'completed': 1,
        'created_at': DateTime.now().toIso8601String(),
      });
      return;
    }

    final db = await database;
    if (db != null) {
      await db.insert('local_sessions', {
        ...session,
        'completed': 1,
        'created_at': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<List<Map<String, dynamic>>> getSessions() async {
    if (kIsWeb) return _webMockSessions;

    final db = await database;
    if (db != null) {
      return await db.query('local_sessions', orderBy: 'created_at DESC');
    }
    return [];
  }

  Future<int> getDailyFocusMinutes() async {
    if (kIsWeb) {
      final today = DateTime.now().toIso8601String().substring(0, 10);
      return _webMockSessions
          .where((s) => s['type'] == 'focus' && s['created_at'].startsWith(today))
          .fold<int>(0, (sum, s) => sum + (s['duration_minutes'] as int));
    }

    final db = await database;
    if (db == null) return 0;

    final today = DateTime.now().toIso8601String().substring(0, 10);
    final List<Map<String, dynamic>> maps = await db.query(
      'local_sessions',
      where: "type = ? AND created_at LIKE ?",
      whereArgs: ['focus', '$today%'],
    );
    
    int total = 0;
    for (var row in maps) {
      total += (row['duration_minutes'] as int);
    }
    return total;
  }

  Future<Map<DateTime, int>> getWeeklyFocusStats() async {
    final now = DateTime.now();
    final Map<DateTime, int> stats = {};

    for (int i = 0; i < 7; i++) {
      final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final dateStr = date.toIso8601String().substring(0, 10);
      
      int total = 0;
      if (kIsWeb) {
        total = _webMockSessions
            .where((s) => s['type'] == 'focus' && s['created_at'].startsWith(dateStr))
            .fold(0, (sum, s) => sum + (s['duration_minutes'] as int));
      } else {
        final db = await database;
        if (db != null) {
          final List<Map<String, dynamic>> maps = await db.query(
            'local_sessions',
            where: "type = ? AND created_at LIKE ?",
            whereArgs: ['focus', '$dateStr%'],
          );
          for (var row in maps) {
            total += (row['duration_minutes'] as int);
          }
        }
      }
      stats[date] = total;
    }
    return stats;
  }
}
