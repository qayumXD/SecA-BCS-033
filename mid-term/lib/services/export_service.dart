import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:task_manager_app/models/task_model.dart';

class ExportService {
  Future<void> exportToCSV(List<Task> tasks) async {
    List<List<dynamic>> rows = [];
    rows.add(["ID", "Title", "Description", "Due Date", "Completed", "Repeat", "Progress"]);

    for (var task in tasks) {
      rows.add([
        task.id,
        task.title,
        task.description,
        task.dueDate.toIso8601String(),
        task.isCompleted ? "Yes" : "No",
        task.repeatType,
        task.progress,
      ]);
    }

    String csvData = const ListToCsvConverter().convert(rows);
    final directory = await getTemporaryDirectory();
    final path = "${directory.path}/tasks.csv";
    final file = File(path);
    await file.writeAsString(csvData);

    await Share.shareXFiles([XFile(path)], text: 'My Task Export');
  }

  Future<void> exportToPDF(List<Task> tasks) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Header(level: 0, child: pw.Text("Task Report")),
              pw.TableHelper.fromTextArray(
                context: context,
                data: <List<String>>[
                  <String>['Title', 'Due Date', 'Status', 'Progress'],
                  ...tasks.map((task) => [
                        task.title,
                        task.dueDate.toString(),
                        task.isCompleted ? "Done" : "Pending",
                        "${(task.progress * 100).toInt()}%"
                      ])
                ],
              ),
            ],
          );
        },
      ),
    );

    final directory = await getTemporaryDirectory();
    final path = "${directory.path}/tasks.pdf";
    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(path)], text: 'My Task PDF Report');
  }

  Future<void> shareViaEmail(List<Task> tasks) async {
    String body = "Here are my tasks:\n\n";
    for (var task in tasks) {
      body += "- ${task.title} (Due: ${task.dueDate})\n";
    }
    
    await Share.share(body, subject: 'Task List Export');
  }
}
