import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';

part 'user_profile.g.dart';

@immutable
@HiveType(typeId: 0)
class UserProfile {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int tasksPerDay;

  @HiveField(2)
  final int categoriesPerDay;

  @HiveField(3)
  final int karmaPoints;

  @HiveField(4)
  final String difficulty;

  const UserProfile({
    required this.name,
    required this.tasksPerDay,
    required this.categoriesPerDay,
    required this.difficulty,
    this.karmaPoints = 0,
  });

  // A default profile for users who skip onboarding
  factory UserProfile.defaultProfile() {
    return UserProfile(
      name: 'Karmic Explorer',
      tasksPerDay: 3,
      categoriesPerDay: 3,
      difficulty: 'medium', // Default difficulty
      karmaPoints: 0,
    );
  }

  UserProfile copyWith({
    String? name,
    int? tasksPerDay,
    int? categoriesPerDay,
    int? karmaPoints,
    String? difficulty,
  }) {
    return UserProfile(
      name: name ?? this.name,
      tasksPerDay: tasksPerDay ?? this.tasksPerDay,
      categoriesPerDay: categoriesPerDay ?? this.categoriesPerDay,
      karmaPoints: karmaPoints ?? this.karmaPoints,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}
