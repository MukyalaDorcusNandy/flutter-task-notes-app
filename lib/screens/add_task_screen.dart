import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/task_item.dart';

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
      appBar: AppBar(title: const Text("Add New Task")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            DropdownButton<String>(
              value: _priority,
              items: ["Low", "Medium", "High"]
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (val) => setState(() => _priority = val!),
            ),
            SwitchListTile(
              title: const Text("Completed"),
              value: _isCompleted,
              onChanged: (val) => setState(() => _isCompleted = val),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_titleController.text.isEmpty ||
                    _descController.text.isEmpty) {
                  return;
                }

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
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
