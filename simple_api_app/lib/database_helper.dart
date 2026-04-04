import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static const String _usersKey = 'saved_users';

  DatabaseHelper._init();

  Future<int> insertUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await getAllUsers();
    
    // Add ID to the user
    user['id'] = users.length + 1;
    users.add(user);
    
    // Save to shared preferences
    final usersJson = users.map((u) => json.encode(u)).toList();
    await prefs.setStringList(_usersKey, usersJson);
    
    return user['id'];
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_usersKey) ?? [];
    
    return usersJson.map((userStr) {
      return Map<String, dynamic>.from(json.decode(userStr));
    }).toList();
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usersKey);
  }
}
