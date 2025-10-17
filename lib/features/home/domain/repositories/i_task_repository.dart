import 'package:instakarm/core/data/models/daily_task_log.dart';

/// Abstract repository for managing daily tasks.
///
/// This interface defines the contract for fetching, generating, updating,
/// and clearing daily tasks for the user.
abstract class ITaskRepository {
  /// Retrieves the tasks for the current day.
  ///
  /// If no tasks exist for today, it generates a new set based on the
  /// user's profile settings.
  Future<List<DailyTaskLog>> getOrGenerateDailyTasks();

  /// Updates the completion status of a specific task.
  ///
  /// - [taskId]: The unique identifier of the task to update.
  /// - [isCompleted]: The new completion status of the task.
  Future<void> updateTaskCompletion(String taskId, bool isCompleted);

  /// Generates a single new task for the current day.
  ///
  /// This is useful for features where the user can request additional tasks.
  Future<DailyTaskLog> generateNewTask();

  /// Clears all stored tasks.
  ///
  /// This is typically used when resetting user data.
  Future<void> clearTasks();
}
