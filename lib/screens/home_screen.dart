import 'package:flutter/material.dart';
import 'package:task_notes_manager/helpers/database_helper.dart';
import 'package:task_notes_manager/models/task_item.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isDark;
  final Function(bool) onThemeChange;

  const HomeScreen({
    super.key,
    required this.onThemeChange,
    required this.isDark,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TaskItem> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    final data = await DatabaseHelper.instance.getTasks();
    setState(() => tasks = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Notes Manager')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "My Tasks & Notes",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            SwitchListTile(
              title: const Text("Dark Theme"),
              value: widget.isDark,
              onChanged: widget.onThemeChange,
            ),

            const SizedBox(height: 10),

            Expanded(
              child: tasks.isEmpty
                  ? const Center(child: Text("No tasks added yet"))
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (_, index) {
                        final t = tasks[index];
                        return Card(
                          child: ListTile(
                            title: Text(t.title),
                            subtitle:
                                Text("${t.priority} • ${t.description}"),
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
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    await DatabaseHelper.instance
                                        .deleteTask(t.id!);
                                    loadTasks();
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
          loadTasks();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
