import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/task_provider.dart';
import 'package:task_manager_app/providers/theme_provider.dart';
import 'package:task_manager_app/screens/add_task_screen.dart';
import 'package:task_manager_app/widgets/task_list_item.dart';
import 'package:task_manager_app/services/export_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ExportService _exportService = ExportService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // Changed to 4
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(themeProvider.themeMode != ThemeMode.dark),
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'pdf':
                  await _exportService.exportToPDF(taskProvider.tasks);
                  break;
                case 'csv':
                  await _exportService.exportToCSV(taskProvider.tasks);
                  break;
                case 'email':
                  await _exportService.shareViaEmail(taskProvider.tasks);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'pdf', child: Text('Export to PDF')),
              const PopupMenuItem(value: 'csv', child: Text('Export to CSV')),
              const PopupMenuItem(value: 'email', child: Text('Share via Email')),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true, // Allow scrolling if tabs are many
          tabs: const [
            Tab(text: 'Tasks'), // All pending tasks
            Tab(text: 'Today'),
            Tab(text: 'Completed'),
            Tab(text: 'Repeated'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTasksTabView(context), // New composite view
          _buildTaskList(context, 'today'),
          _buildTaskList(context, 'completed'),
          _buildTaskList(context, 'repeated'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTasksTabView(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final allPending = taskProvider.allPendingTasks;
        final todayTasks = taskProvider.todayTasks;

        if (allPending.isEmpty && todayTasks.isEmpty) {
          return const Center(child: Text('No tasks found'));
        }

        return ListView(
          children: [
            if (allPending.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('All Pending Tasks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ...allPending.map((task) => TaskListItem(task: task)).toList(),
            ],
            if (todayTasks.isNotEmpty) ...[
              const Divider(thickness: 2, height: 40),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Today\'s Tasks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ...todayTasks.map((task) => TaskListItem(task: task)).toList(),
            ],
          ],
        );
      },
    );
  }

  Widget _buildTaskList(BuildContext context, String type) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final List tasks;
        switch (type) {
          case 'today':
            tasks = taskProvider.todayTasks;
            break;
          case 'completed':
            tasks = taskProvider.completedTasks;
            break;
          case 'repeated':
            tasks = taskProvider.repeatedTasks;
            break;
          default:
            tasks = [];
        }

        if (tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.task_alt, size: 64, color: Colors.grey.withOpacity(0.5)),
                const SizedBox(height: 16),
                Text('No tasks in ${type} list',
                   style: const TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return TaskListItem(task: tasks[index]);
          },
        );
      },
    );
  }
}
