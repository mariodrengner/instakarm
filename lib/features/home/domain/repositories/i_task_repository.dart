import 'package:instakarm/core/data/models/daily_task_log.dart';

abstract class ITaskRepository {
  Future<List<DailyTaskLog>> getOrGenerateDailyTasks();
  Future<void> updateTaskCompletion(String taskId, bool isCompleted);
  Future<DailyTaskLog> generateNewTask(); // Example method for adding one new task
}
