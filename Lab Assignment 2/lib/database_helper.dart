import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static int _nextId = 1;
  static final Map<int, Map<String, dynamic>> _data = {};

  DatabaseHelper._init();

  // Dummy database getter for compatibility
  Future<void> get database async {
    // Initialize data if needed
    if (_nextId == 1 && _data.isEmpty) {
      _nextId = 1;
    }
  }

  Future<int> create(Map<String, dynamic> user) async {
    await database;
    user['id'] = _nextId;
    _data[_nextId] = Map<String, dynamic>.from(user);
    _nextId++;
    return user['id'] as int;
  }

  Future<List<Map<String, dynamic>>> readAllUsers() async {
    await database;
    final users = _data.values.toList();
    users.sort((a, b) => (a['id'] as int).compareTo(b['id'] as int));
    return users;
  }

  Future<int> update(Map<String, dynamic> user) async {
    await database;
    final id = user['id'] as int;
    if (_data.containsKey(id)) {
      _data[id] = Map<String, dynamic>.from(user);
      return 1;
    }
    return 0;
  }

  Future<int> delete(int id) async {
    await database;
    if (_data.containsKey(id)) {
      _data.remove(id);
      return 1;
    }
    return 0;
  }

  Future close() async {
    // Cleanup
  }
}
