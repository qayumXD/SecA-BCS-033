import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/models/task_model.dart';
import 'package:task_manager_app/providers/task_provider.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late List<SubTask> _subTasks = [];

  @override
  void initState() {
    super.initState();
    _loadSubTasks();
  }

  Future<void> _loadSubTasks() async {
    final subTasks = await Provider.of<TaskProvider>(context, listen: false)
        .getSubTasks(widget.task.id!);
    setState(() {
      _subTasks = subTasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false)
                  .deleteTask(widget.task.id!);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Due: ${DateFormat('MMM dd, yyyy - hh:mm a').format(widget.task.dueDate)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.task.description),
            const SizedBox(height: 16),
            if (widget.task.repeatType != 'none')
              Text('Repeats: ${widget.task.repeatType}',
                  style: const TextStyle(color: Colors.blue)),
            const SizedBox(height: 24),
            const Text('Subtasks & Progress',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: widget.task.progress),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _subTasks.length,
              itemBuilder: (context, index) {
                final subTask = _subTasks[index];
                return CheckboxListTile(
                  title: Text(subTask.title),
                  value: subTask.isCompleted,
                  onChanged: (value) async {
                    subTask.isCompleted = value!;
                    await Provider.of<TaskProvider>(context, listen: false)
                        .updateSubTask(subTask);
                    setState(() {
                      // Progress in widget.task might need update if not using provider's task
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
