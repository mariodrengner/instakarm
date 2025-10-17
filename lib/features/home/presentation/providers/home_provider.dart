import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:instakarm/core/data/models/daily_task_log.dart';
import 'package:instakarm/core/data/models/user_profile.dart';
import 'package:instakarm/features/home/data/repositories/hive_task_repository.dart';
import 'package:instakarm/features/home/domain/repositories/i_task_repository.dart';
import 'package:instakarm/features/onboarding/data/repositories/hive_user_profile_repository.dart';
import 'package:instakarm/features/onboarding/domain/repositories/i_user_profile_repository.dart';

part 'home_provider.g.dart';

/// Provider for the [IUserProfileRepository].
///
/// This provider is responsible for creating and providing an instance of the
/// user profile repository, which handles data related to the user's profile.
/// It's kept alive to ensure the repository instance persists throughout the app's lifecycle.
@Riverpod(keepAlive: true)
Future<IUserProfileRepository> userProfileRepository(Ref ref) async {
  final box = await Hive.openBox<UserProfile>('user_profile_box');
  return HiveUserProfileRepository(box);
}

/// Provider for the [ITaskRepository].
///
/// This provider creates and provides an instance of the task repository,
/// which depends on the user profile repository to function correctly.
@riverpod
Future<ITaskRepository> taskRepository(Ref ref) async {
  final userProfileRepository = await ref.watch(userProfileRepositoryProvider.future);
  return HiveTaskRepository(userProfileRepository);
}

/// Represents the state of the home screen.
///
/// It holds the user's profile and the list of daily tasks.
@immutable
class HomeState {
  final UserProfile userProfile;
  final List<DailyTaskLog> tasks;

  const HomeState({
    required this.userProfile,
    required this.tasks,
  });

  HomeState copyWith({
    UserProfile? userProfile,
    List<DailyTaskLog>? tasks,
  }) {
    return HomeState(
      userProfile: userProfile ?? this.userProfile,
      tasks: tasks ?? this.tasks,
    );
  }
}

/// The notifier for the home screen's state.
///
/// This class is responsible for fetching the initial data for the home screen
/// and handling user actions, such as completing a task.
@Riverpod(keepAlive: true)
class Home extends _$Home {
  @override
  Future<HomeState> build() async {
    final userProfile = await (await ref.watch(userProfileRepositoryProvider.future)).getProfile();
    final tasks = await (await ref.watch(taskRepositoryProvider.future)).getOrGenerateDailyTasks();
    return HomeState(userProfile: userProfile, tasks: tasks);
  }

  /// Marks a task as complete and updates the user's karma points.
  Future<void> completeTask(String taskId) async {
    final taskRepo = await ref.read(taskRepositoryProvider.future);
    final profileRepo = await ref.read(userProfileRepositoryProvider.future);

    // Optimistically update the state for a responsive UI.
    final currentState = state.value;
    if (currentState != null) {
      final updatedTasks = currentState.tasks.map((t) {
        if (t.id == taskId) {
          return t.copyWith(isCompleted: true);
        }
        return t;
      }).toList();

      final updatedProfile = currentState.userProfile.copyWith(
        karmaPoints: currentState.userProfile.karmaPoints + 1,
      );
      state = AsyncData(currentState.copyWith(tasks: updatedTasks, userProfile: updatedProfile));
    }

    // Persist the changes to the repositories.
    await taskRepo.updateTaskCompletion(taskId, true);
    await profileRepo.saveProfile(state.value!.userProfile);
  }

  /// Adds a new, randomly generated task to the current list of tasks.
  Future<void> addMoreTasks() async {
    final taskRepo = await ref.read(taskRepositoryProvider.future);
    final newTask = await taskRepo.generateNewTask();

    final currentState = state.value;
    if (currentState != null) {
      state = AsyncData(currentState.copyWith(tasks: [...currentState.tasks, newTask]));
    }
  }
}
