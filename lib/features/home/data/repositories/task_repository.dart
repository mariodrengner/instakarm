import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:instakarm/features/home/domain/models/task_category.dart';

class TaskRepository {
  // Private helper to load and parse the full data
  Future<List<TaskCategory>> _loadAllTaskCategories() async {
    final String response = await rootBundle.loadString('plan/mocks/daily_tasks.json');
    final data = await json.decode(response);
    final List<dynamic> categoriesJson = data['categories'];
    return categoriesJson.map((json) => TaskCategory.fromJson(json)).toList();
  }

  /// Fetches 7 daily tasks, one randomly selected from each category.
  Future<List<DailyTaskDisplay>> getDailyTasks() async {
    final allCategories = await _loadAllTaskCategories();
    final dailyTasks = <DailyTaskDisplay>[];
    final random = Random();

    for (var category in allCategories) {
      if (category.tasks.isNotEmpty) {
        final randomTask = category.tasks[random.nextInt(category.tasks.length)];
        dailyTasks.add(
          DailyTaskDisplay(
            task: randomTask,
            categoryName: category.name,
            categoryColor: category.color,
          ),
        );
      }
    }
    return dailyTasks;
  }

  /// Fetches the list of categories with a placeholder for weekly progress.
  Future<List<TaskCategory>> getWeeklyCategoryProgress() async {
    final allCategories = await _loadAllTaskCategories();
    
    // For now, we'll return the categories with a mock progress.
    // In the future, this progress would come from a database.
    return allCategories.map((category) {
      // Placeholder: progress is 3 out of 7 tasks.
      return category.copyWith(weeklyProgress: 3);
    }).toList();
  }
}