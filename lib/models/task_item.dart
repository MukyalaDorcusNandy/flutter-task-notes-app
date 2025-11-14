class TaskItem {
  int? id;
  String title;
  String priority;
  String description;
  bool isCompleted;

  TaskItem({
    this.id,
    required this.title,
    required this.priority,
    required this.description,
    this.isCompleted = false,
  });

  // Convert TaskItem to JSON for SQLite
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'priority': priority,
        'description': description,
        'isCompleted': isCompleted ? 1 : 0,
      };

  // Convert JSON map from SQLite to TaskItem
  factory TaskItem.fromJson(Map<String, dynamic> json) => TaskItem(
        id: json['id'],
        title: json['title'],
        priority: json['priority'],
        description: json['description'],
        isCompleted: json['isCompleted'] == 1,
      );
}
