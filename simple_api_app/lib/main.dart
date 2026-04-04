import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API & Database App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _usernameController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  
  Map<String, dynamic>? _apiData;
  List<Map<String, dynamic>> _savedUsers = [];
  bool _isLoading = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _loadSavedUsers();
  }

  // 1. API Call
  Future<void> _fetchDataFromAPI() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _apiData = json.decode(response.body);
          _message = 'API data fetched successfully!';
        });
      } else {
        setState(() {
          _message = 'Failed to fetch data';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 3. Username save & 4. Database insert
  Future<void> _saveToDatabase() async {
    if (_usernameController.text.isEmpty) {
      setState(() {
        _message = 'Please enter a username';
      });
      return;
    }

    final user = {
      'username': _usernameController.text,
      'email': _apiData?['email'] ?? '',
      'name': _apiData?['name'] ?? '',
      'created_at': DateTime.now().toIso8601String(),
    };

    await _dbHelper.insertUser(user);
    _usernameController.clear();
    
    setState(() {
      _message = 'User saved to database!';
    });
    
    _loadSavedUsers();
  }

  Future<void> _loadSavedUsers() async {
    final users = await _dbHelper.getAllUsers();
    setState(() {
      _savedUsers = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API & Database App'),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. API Call Button
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _fetchDataFromAPI,
              icon: const Icon(Icons.cloud_download),
              label: const Text('Fetch Data from API'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 2. Data Print (Display)
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_apiData != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'API Data:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Name: ${_apiData!['name']}'),
                      Text('Email: ${_apiData!['email']}'),
                      Text('Phone: ${_apiData!['phone']}'),
                      Text('Website: ${_apiData!['website']}'),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 16),
            
            // 3. Username Input
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Enter Username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 4. Save to Database Button
            ElevatedButton.icon(
              onPressed: _saveToDatabase,
              icon: const Icon(Icons.save),
              label: const Text('Save to Database'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            
            if (_message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _message,
                  style: TextStyle(
                    color: _message.contains('Error') || _message.contains('Failed')
                        ? Colors.red
                        : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            
            const SizedBox(height: 24),
            
            // Display saved users from database
            const Text(
              'Saved Users:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            if (_savedUsers.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No users saved yet',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              ..._savedUsers.map((user) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(user['username']),
                  subtitle: Text(user['email'] ?? 'No email'),
                  trailing: Text('#${user['id']}'),
                ),
              )),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}
