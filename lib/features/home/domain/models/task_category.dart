import 'package:instakarm/features/home/domain/models/category.dart';

class Task {
  final String name;

  Task({required this.name});

  factory Task.fromJson(String json) {
    return Task(name: json);
  }
}

class TaskCategory {
  final Category category;
  final List<Task> tasks;

  TaskCategory({
    required this.category,
    required this.tasks,
  });

  factory TaskCategory.fromJson(Map<String, dynamic> json) {
    var taskList = json['tasks'] as List;
    List<Task> tasks = taskList.map((i) => Task.fromJson(i)).toList();

    return TaskCategory(
      category: _categoryFromString(json['id']),
      tasks: tasks,
    );
  }

  static Category _categoryFromString(String id) {
    return Category.values.firstWhere(
      (e) => e.toString().split('.').last == id,
      orElse: () => Category.grounding, // Fallback
    );
  }
}
