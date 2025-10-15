import 'package:flutter/material.dart';

class Task {
  final String name;

  Task({required this.name});

  factory Task.fromJson(String json) {
    return Task(name: json);
  }
}

class TaskCategory {
  final String name;
  final Color color;
  final List<Task> tasks;
  final int weeklyProgress; // Added for weekly progress tracking

  TaskCategory({
    required this.name,
    required this.color,
    required this.tasks,
    this.weeklyProgress = 0, // Default value
  });

  factory TaskCategory.fromJson(Map<String, dynamic> json) {
    var taskList = json['tasks'] as List;
    List<Task> tasks = taskList.map((i) => Task.fromJson(i)).toList();

    return TaskCategory(
      name: json['name'],
      color: _colorFromHex(json['color']),
      tasks: tasks,
    );
  }

  // Helper method to create a copy with updated progress
  TaskCategory copyWith({int? weeklyProgress}) {
    return TaskCategory(
      name: this.name,
      color: this.color,
      tasks: this.tasks,
      weeklyProgress: weeklyProgress ?? this.weeklyProgress,
    );
  }

  static Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}

// New lightweight model for displaying a single daily task
class DailyTaskDisplay {
  final Task task;
  final String categoryName;
  final Color categoryColor;

  DailyTaskDisplay({
    required this.task,
    required this.categoryName,
    required this.categoryColor,
  });
}