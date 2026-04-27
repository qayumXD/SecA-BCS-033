import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/game_result.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'number_guess_game.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE game_results(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            guess INTEGER NOT NULL,
            status TEXT NOT NULL,
            timestamp TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertResult(GameResult result) async {
    final db = await database;
    return db.insert('game_results', result.toMap());
  }

  Future<List<GameResult>> fetchResults() async {
    final db = await database;
    final rows = await db.query(
      'game_results',
      orderBy: 'id DESC',
    );

    return rows.map(GameResult.fromMap).toList();
  }
}
