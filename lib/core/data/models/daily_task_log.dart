import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';

part 'daily_task_log.g.dart';

@immutable
@HiveType(typeId: 1)
class DailyTaskLog {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String taskName;

  @HiveField(2)
  final String categoryName;

  @HiveField(3)
  final String categoryColorHex;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final bool isCompleted;

  const DailyTaskLog({
    required this.id,
    required this.taskName,
    required this.categoryName,
    required this.categoryColorHex,
    required this.date,
    this.isCompleted = false,
  });

  DailyTaskLog copyWith({
    String? id,
    String? taskName,
    String? categoryName,
    String? categoryColorHex,
    DateTime? date,
    bool? isCompleted,
  }) {
    return DailyTaskLog(
      id: id ?? this.id,
      taskName: taskName ?? this.taskName,
      categoryName: categoryName ?? this.categoryName,
      categoryColorHex: categoryColorHex ?? this.categoryColorHex,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
