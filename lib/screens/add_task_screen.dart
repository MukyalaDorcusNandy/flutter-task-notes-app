import 'package:flutter/material.dart';
import 'package:task_notes_manager/helpers/database_helper.dart';
import 'package:task_notes_manager/models/task_item.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  String _priority = "Low";
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add New Task")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: "Description"),
            ),

            DropdownButton<String>(
              value: _priority,
              items: ["Low", "Medium", "High"]
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (val) => setState(() => _priority = val!),
            ),

            SwitchListTile(
              title: Text("Completed"),
              value: _isCompleted,
              onChanged: (val) => setState(() => _isCompleted = val),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final task = TaskItem(
                  title: _titleController.text,
                  priority: _priority,
                  description: _descController.text,
                  isCompleted: _isCompleted,
                );

                await DatabaseHelper.instance.insertTask(task);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}
