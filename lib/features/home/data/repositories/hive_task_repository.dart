import 'dart:convert';
import 'dart:math';


import 'package:flutter/services.dart';
import 'package:hive_ce/hive.dart';
import 'package:instakarm/core/data/models/daily_task_log.dart';
import 'package:instakarm/core/data/models/user_profile.dart';
import 'package:instakarm/features/home/domain/models/category.dart';
import 'package:instakarm/features/home/domain/repositories/i_task_repository.dart';
import 'package:instakarm/features/onboarding/domain/repositories/i_user_profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:instakarm/features/home/domain/models/task_category.dart';
import 'package:instakarm/core/theme/app_theme.dart';
import 'package:uuid/uuid.dart';

/// A Hive-based implementation of the [ITaskRepository].
///
/// This class uses the Hive database to persist daily tasks locally.
class HiveTaskRepository implements ITaskRepository {
  static const _dailyTasksBoxName = 'daily_task_log_box';
  final Future<Box<DailyTaskLog>> _dailyTasksBoxFuture = Hive.openBox<DailyTaskLog>(_dailyTasksBoxName);
  final _uuid = const Uuid();
  final IUserProfileRepository _userProfileRepository;

  /// Creates a new instance of [HiveTaskRepository].
  ///
  /// Requires an [IUserProfileRepository] to access user settings for task generation.
  HiveTaskRepository(this._userProfileRepository);

  Future<Box<DailyTaskLog>> _getTaskBox() async => _dailyTasksBoxFuture;

  @override
  Future<List<DailyTaskLog>> getOrGenerateDailyTasks() async {
    try {
      final dailyTasksBox = await _getTaskBox();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Filter tasks that are for today
      final tasksForToday = dailyTasksBox.values.where((task) {
        final taskDate = DateTime(task.date.year, task.date.month, task.date.day);
        return taskDate == today;
      }).toList();

      if (tasksForToday.isNotEmpty) {
        return tasksForToday;
      } else {
        // No tasks for today, generate new ones
        final profile = await _userProfileRepository.getProfile();
        final generatedTasks = await _generateTasksForDay(profile);
        for (var task in generatedTasks) {
          await dailyTasksBox.put(task.id, task);
        }
        return generatedTasks;
      }
    } catch (e) {
      // Handle potential errors, e.g., issues with Hive box
      debugPrint('Error in getOrGenerateDailyTasks: $e');
      return [];
    }
  }

  /// Generates a list of tasks for the day based on the user's profile.
  Future<List<DailyTaskLog>> _generateTasksForDay(UserProfile userProfile) async {
    final allCategories = await _loadSourceCategories();
    final random = Random();
    final selectedLogs = <DailyTaskLog>[];

    if (allCategories.isEmpty) {
      return []; // No categories available
    }

    for (int i = 0; i < userProfile.tasksPerDay; i++) {
      // Select a random category from all available categories
      final randomCategory = allCategories[random.nextInt(allCategories.length)];
      if (randomCategory.tasks.isEmpty) {
        continue; // Skip if a category has no tasks
      }
      final randomTask = randomCategory.tasks[random.nextInt(randomCategory.tasks.length)];
      final color = AppTheme.categoryColors[randomCategory.category]!;

      final newLog = DailyTaskLog(
        id: _uuid.v4(),
        taskName: randomTask.name,
        categoryName: randomCategory.category.localizationKey, // Store the key
        categoryColorHex: '#${color.toARGB32().toRadixString(16).padLeft(8, '0')}',
        date: DateUtils.dateOnly(DateTime.now()),
      );
      selectedLogs.add(newLog);
    }
    return selectedLogs;
  }



  @override
  Future<void> updateTaskCompletion(String taskId, bool isCompleted) async {
    final taskBox = await _getTaskBox();
    final task = taskBox.get(taskId);
    if (task != null) {
      final updatedTask = task.copyWith(isCompleted: isCompleted);
      await taskBox.put(taskId, updatedTask);
    }
  }
  
  @override
  Future<DailyTaskLog> generateNewTask() async {
    final taskBox = await _getTaskBox();
    final allCategories = await _loadSourceCategories();
    final random = Random();
    final randomCategory = allCategories[random.nextInt(allCategories.length)];
    final randomTask = randomCategory.tasks[random.nextInt(randomCategory.tasks.length)];
    final color = AppTheme.categoryColors[randomCategory.category]!;
    
    final newLog = DailyTaskLog(
      id: const Uuid().v4(),
      taskName: randomTask.name,
      categoryName: randomCategory.category.localizationKey, // Store the key
      categoryColorHex: '#${color.toARGB32().toRadixString(16).padLeft(8, '0')}',
      date: DateUtils.dateOnly(DateTime.now()),
    );
    await taskBox.put(newLog.id, newLog);
    return newLog;
  }

  /// Loads the source categories and tasks from the JSON asset file.
  Future<List<TaskCategory>> _loadSourceCategories() async {
    final String response = await rootBundle.loadString('assets/data/daily_tasks.json');
    final data = json.decode(response);
    final List<dynamic> categoriesJson = data['categories'];
    return categoriesJson.map((json) => TaskCategory.fromJson(json)).toList();
  }

  @override
  Future<void> clearTasks() async {
    final taskBox = await _getTaskBox();
    await taskBox.clear();
  }
}
