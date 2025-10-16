import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instakarm/core/data/models/daily_task_log.dart';
import 'package:instakarm/core/data/models/user_profile.dart';
import 'package:instakarm/features/home/data/repositories/hive_task_repository.dart';
import 'package:instakarm/features/onboarding/domain/repositories/user_profile_repository_provider.dart';

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
class HomeNotifier extends AsyncNotifier<HomeState> {
  @override
  Future<HomeState> build() async {
    final userProfile = await ref.watch(userProfileRepositoryProvider).getProfile();
    final tasks = await ref.watch(taskRepositoryProvider).getOrGenerateDailyTasks();
    return HomeState(userProfile: userProfile, tasks: tasks);
  }

  Future<void> completeTask(String taskId) async {
    final taskRepo = ref.read(taskRepositoryProvider);
    final profileRepo = ref.read(userProfileRepositoryProvider);

    // Update the state optimistically to feel faster
    final currentState = state.value;
    if (currentState != null) {
      final updatedTasks = currentState.tasks.where((t) => t.id != taskId).toList();
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
    final taskRepo = ref.read(taskRepositoryProvider);
    final newTask = await taskRepo.generateNewTask();

    final currentState = state.value;
    if (currentState != null) {
      state = AsyncData(currentState.copyWith(tasks: [...currentState.tasks, newTask]));
    }
  }
}

// 3. Provider Declaration
final homeProvider = AsyncNotifierProvider<HomeNotifier, HomeState>(() {
  return HomeNotifier();
});
