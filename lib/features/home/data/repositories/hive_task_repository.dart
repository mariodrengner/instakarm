import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:instakarm/core/data/models/daily_task_log.dart';
import 'package:instakarm/features/home/domain/models/task_category.dart';
import 'package:instakarm/features/home/domain/repositories/i_task_repository.dart';
import 'package:instakarm/features/onboarding/domain/repositories/user_profile_repository_provider.dart';
import 'package:uuid/uuid.dart';

// 1. Provider that creates an instance of the repository
final taskRepositoryProvider = Provider<ITaskRepository>((ref) {
  return HiveTaskRepository(ref);
});


// 2. The actual Hive implementation
class HiveTaskRepository implements ITaskRepository {
  final Ref _ref; // Riverpod's service locator

  HiveTaskRepository(this._ref);

  Future<Box<DailyTaskLog>> _getTaskBox() async {
    // Use a separate init method or ensure box is open before use
    if (!Hive.isBoxOpen('daily_task_log_box')) {
      return await Hive.openBox<DailyTaskLog>('daily_task_log_box');
    }
    return Hive.box<DailyTaskLog>('daily_task_log_box');
  }

  @override
  Future<List<DailyTaskLog>> getOrGenerateDailyTasks() async {
    final taskBox = await _getTaskBox();
    final today = DateUtils.dateOnly(DateTime.now());
    final tasksForToday = taskBox.values.where((task) => task.date == today).toList();

    if (tasksForToday.isNotEmpty) {
      return tasksForToday;
    } else {
      // Clear old tasks
      await taskBox.clear();

      // Generate new tasks
      final userProfile = await _ref.read(userProfileRepositoryProvider).getProfile();
      final allCategories = await _loadSourceCategories();
      final dailyTasks = <DailyTaskLog>[];
      final random = Random();

      allCategories.shuffle();
      final selectedCategories = allCategories.take(userProfile.categoriesPerDay);

      for (var category in selectedCategories) {
        if (category.tasks.isNotEmpty) {
          final randomTask = category.tasks[random.nextInt(category.tasks.length)];
          final newLog = DailyTaskLog(
            id: const Uuid().v4(),
            taskName: randomTask.name,
            categoryName: category.name,
            categoryColorHex: '#${category.color.value.toRadixString(16).substring(2)}',
            date: today,
          );
          dailyTasks.add(newLog);
          await taskBox.put(newLog.id, newLog);
        }
      }
      return dailyTasks;
    }
  }

  @override
  Future<void> updateTaskCompletion(String taskId, bool isCompleted) async {
    final taskBox = await _getTaskBox();
    final task = taskBox.get(taskId);
    if (task != null) {
      final updatedTask = DailyTaskLog(
        id: task.id,
        taskName: task.taskName,
        categoryName: task.categoryName,
        categoryColorHex: task.categoryColorHex,
        date: task.date,
        isCompleted: isCompleted,
      );
      await taskBox.put(taskId, updatedTask);
    }
  }
  
  @override
  Future<DailyTaskLog> generateNewTask() async {
    final taskBox = await _getTaskBox();
    // This is a simplified example. A real implementation would need to avoid duplicates.
    final allCategories = await _loadSourceCategories();
    final random = Random();
    final randomCategory = allCategories[random.nextInt(allCategories.length)];
    final randomTask = randomCategory.tasks[random.nextInt(randomCategory.tasks.length)];
    
    final newLog = DailyTaskLog(
      id: const Uuid().v4(),
      taskName: randomTask.name,
      categoryName: randomCategory.name,
      categoryColorHex: '#${randomCategory.color.value.toRadixString(16).substring(2)}',
      date: DateUtils.dateOnly(DateTime.now()),
    );
    await taskBox.put(newLog.id, newLog);
    return newLog;
  }

  // Helper to load the source JSON
  Future<List<TaskCategory>> _loadSourceCategories() async {
    final String response = await rootBundle.loadString('plan/mocks/daily_tasks.json');
    final data = json.decode(response);
    final List<dynamic> categoriesJson = data['categories'];
    return categoriesJson.map((json) => TaskCategory.fromJson(json)).toList();
  }
}
