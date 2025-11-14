import 'package:flutter/material.dart';
import 'package:task_notes_manager/helpers/database_helper.dart';
import 'package:task_notes_manager/models/task_item.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isDark;
  final Function(bool) onThemeChange;

  const HomeScreen({
    super.key,
    required this.isDark,
    required this.onThemeChange,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TaskItem> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final data = await DatabaseHelper.instance.getTasks();

    // If empty, add sample tasks
    if (data.isEmpty) {
      tasks = [
        TaskItem(
            title: "Buy groceries",
            description: "Milk, Eggs, Bread",
            priority: "High",
            isCompleted: false),
        TaskItem(
            title: "Morning jog",
            description: "Run 3km in the park",
            priority: "Medium",
            isCompleted: true),
      ];
    } else {
      tasks = data;
    }

    setState(() {});
  }

  Color priorityColor(String priority) {
    switch (priority) {
      case "High":
        return Colors.redAccent;
      case "Medium":
        return Colors.orangeAccent;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Notes Manager")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("My Tasks & Notes",
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold)),
            SwitchListTile(
              title: const Text("Dark Theme"),
              value: widget.isDark,
              onChanged: widget.onThemeChange,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: tasks.isEmpty
                  ? const Center(child: Text("No tasks yet"))
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (_, index) {
                        final t = tasks[index];
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: priorityColor(t.priority),
                              child: Text(t.priority[0]),
                            ),
                            title: Text(
                              t.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(t.description),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  t.isCompleted
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  color: t.isCompleted
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () async {
                                    if (t.id != null) {
                                      await DatabaseHelper.instance
                                          .deleteTask(t.id!);
                                      _loadTasks();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
          _loadTasks();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
