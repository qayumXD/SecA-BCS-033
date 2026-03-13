import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Lab Assignment 2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const UserListPage(),
    );
  }
}

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshUsers();
  }

  Future<void> _refreshUsers() async {
    final data = await DatabaseHelper.instance.readAllUsers();
    setState(() {
      _users = data;
      _isLoading = false;
    });
  }

  void _showForm(int? id) async {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final ageController = TextEditingController();
    String? imagePath;

    if (id != null) {
      final existingUser = _users.firstWhere((element) => element['id'] == id);
      nameController.text = existingUser['name'];
      emailController.text = existingUser['email'];
      ageController.text = existingUser['age'].toString();
      imagePath = existingUser['imagePath'];
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom + 50,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setModalState(() {
                          imagePath = image.path;
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: imagePath != null && imagePath!.isNotEmpty
                          ? FileImage(File(imagePath!))
                          : null,
                      child: imagePath == null || imagePath!.isEmpty
                          ? const Icon(Icons.add_a_photo, size: 50)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(hintText: 'Email'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Age'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (nameController.text.isEmpty ||
                            emailController.text.isEmpty ||
                            ageController.text.isEmpty ||
                            imagePath == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill all fields and select an image!')),
                          );
                          return;
                        }

                        if (id == null) {
                          await _addUser(
                            nameController.text,
                            emailController.text,
                            int.parse(ageController.text),
                            imagePath!,
                          );
                        } else {
                          await _updateUser(
                            id,
                            nameController.text,
                            emailController.text,
                            int.parse(ageController.text),
                            imagePath!,
                          );
                        }
                        nameController.clear();
                        emailController.clear();
                        ageController.clear();
                        if (mounted) Navigator.of(context).pop();
                      },
                      child: Text(id == null ? 'Add' : 'Update'),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _addUser(String name, String email, int age, String imagePath) async {
    await DatabaseHelper.instance.create({
      'name': name,
      'email': email,
      'age': age,
      'imagePath': imagePath,
    });
    _refreshUsers();
  }

  Future<void> _updateUser(int id, String name, String email, int age, String imagePath) async {
    await DatabaseHelper.instance.update({
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'imagePath': imagePath,
    });
    _refreshUsers();
  }

  void _deleteUser(int id) async {
    await DatabaseHelper.instance.delete(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Successfully deleted a user!')),
    );
    _refreshUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Assignment 2'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? const Center(child: Text("No users added yet!"))
              : ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return Card(
                      color: Colors.deepPurple[50],
                      margin: const EdgeInsets.all(15),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: user['imagePath'] != null && user['imagePath'].isNotEmpty
                              ? FileImage(File(user['imagePath']))
                              : null,
                          child: user['imagePath'] == null || user['imagePath'].isEmpty
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        title: Text(user['name']),
                        subtitle: Text('${user['email']} • Age: ${user['age']}'),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showForm(user['id']),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteUser(user['id']),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
