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

// Provider for the User Profile Repository
@Riverpod(keepAlive: true)
Future<IUserProfileRepository> userProfileRepository(Ref ref) async {
  final box = await Hive.openBox<UserProfile>('user_profile_box');
  return HiveUserProfileRepository(box);
}

// Provider for the Task Repository
@riverpod
Future<ITaskRepository> taskRepository(Ref ref) async {
  final userProfileRepository = await ref.watch(userProfileRepositoryProvider.future);
  return HiveTaskRepository(userProfileRepository);
}

// 1. State Class
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

// 2. Notifier Class
@Riverpod(keepAlive: true)
class Home extends _$Home {
  @override
  Future<HomeState> build() async {
    final userProfile = await (await ref.watch(userProfileRepositoryProvider.future)).getProfile();
    final tasks = await (await ref.watch(taskRepositoryProvider.future)).getOrGenerateDailyTasks();
    return HomeState(userProfile: userProfile, tasks: tasks);
  }

  Future<void> completeTask(String taskId) async {
    final taskRepo = await ref.read(taskRepositoryProvider.future);
    final profileRepo = await ref.read(userProfileRepositoryProvider.future);

    // Update the state optimistically to feel faster
    final currentState = state.value;
    if (currentState != null) {
      final updatedTasks = currentState.tasks.map((t) {
        if (t.id == taskId) {
          return t.copyWith(isCompleted: true);
        }
        return t;
      }).toList();

      final updatedProfile = currentState.userProfile.copyWith(
        karmaPoints: currentState.userProfile.karmaPoints + 1, // Assuming 1 point per task
      );
      state = AsyncData(currentState.copyWith(tasks: updatedTasks, userProfile: updatedProfile));
    }

    // Perform the actual repository updates
    await taskRepo.updateTaskCompletion(taskId, true);
    await profileRepo.saveProfile(state.value!.userProfile); // Save the updated profile
  }

  Future<void> addMoreTasks() async {
    final taskRepo = await ref.read(taskRepositoryProvider.future);
    final newTask = await taskRepo.generateNewTask();

    final currentState = state.value;
    if (currentState != null) {
      state = AsyncData(currentState.copyWith(tasks: [...currentState.tasks, newTask]));
    }
  }
}
