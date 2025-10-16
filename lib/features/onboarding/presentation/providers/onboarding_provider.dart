import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:instakarm/core/data/models/user_profile.dart';
import 'package:instakarm/features/home/domain/repositories/i_task_repository.dart';
import 'package:instakarm/features/home/presentation/providers/home_provider.dart';
import 'package:instakarm/features/onboarding/domain/repositories/i_user_profile_repository.dart';

part 'onboarding_provider.g.dart';

/// Provider to asynchronously determine if onboarding has been completed.
final onboardingStateProvider = FutureProvider<bool>((ref) async {
  final repository = await ref.watch(userProfileRepositoryProvider.future);
  return repository.hasCompletedOnboarding();
});

// The Notifier class
@riverpod
class OnboardingViewModel extends _$OnboardingViewModel {
  late IUserProfileRepository _userProfileRepository;
  late ITaskRepository _taskRepository;

  @override
  Future<OnboardingState> build() async {
    _userProfileRepository = await ref.watch(userProfileRepositoryProvider.future);
    _taskRepository = await ref.watch(taskRepositoryProvider.future);

    // Generate an initial random name.
    const adjectives = ['Happy', 'Brave', 'Clever', 'Sunny', 'Lucky'];
    const nouns = ['Panda', 'Lion', 'Tiger', 'Eagle', 'Fox'];
    final randomAdjective = adjectives[DateTime.now().millisecond % adjectives.length];
    final randomNoun = nouns[DateTime.now().millisecond % nouns.length];
    final randomNumber = DateTime.now().second;
    final initialName = '$randomAdjective$randomNoun$randomNumber';

    // Initial state with a random name.
    return OnboardingState(userName: initialName);
  }

  void setDifficulty(String difficulty, int tasks, int categories) {
    final currentState = state.value;
    if (currentState == null) return;
    state = AsyncData(currentState.copyWith(
      difficulty: difficulty,
      tasksPerDay: tasks,
      categoriesPerDay: categories,
    ));
  }

  void updateUserName(String name) {
    final currentState = state.value;
    if (currentState == null) return;
    state = AsyncData(currentState.copyWith(userName: name));
  }

  void regenerateRandomName() {
    final currentState = state.value;
    if (currentState == null) return;
    const adjectives = ['Happy', 'Brave', 'Clever', 'Sunny', 'Lucky'];
    const nouns = ['Panda', 'Lion', 'Tiger', 'Eagle', 'Fox'];
    final randomAdjective = adjectives[DateTime.now().millisecond % adjectives.length];
    final randomNoun = nouns[DateTime.now().millisecond % nouns.length];
    final randomNumber = DateTime.now().second;
    state = AsyncData(currentState.copyWith(userName: '$randomAdjective$randomNoun$randomNumber'));
  }

  Future<void> completeOnboarding() async {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncData(currentState.copyWith(isLoading: true));

    // Use default values if the user skipped the steps
    final defaultProfile = UserProfile.defaultProfile();

    final profile = UserProfile(
      name: currentState.userName,
      tasksPerDay: currentState.tasksPerDay,
      categoriesPerDay: currentState.categoriesPerDay,
      difficulty: currentState.difficulty,
    );
    await _userProfileRepository.saveProfile(profile);

    // Invalidate the provider to force a re-fetch of the onboarding status
    ref.invalidate(onboardingStateProvider);

    state = AsyncData(currentState.copyWith(isLoading: false));
  }

  Future<void> resetOnboarding() async {
    // Fetch repositories directly to avoid dependency on the build method's initialization.
    final userProfileRepo = await ref.read(userProfileRepositoryProvider.future);
    final taskRepo = await ref.read(taskRepositoryProvider.future);

    // Clear all user-related data.
    await userProfileRepo.clearProfile();
    await taskRepo.clearTasks();

    // After async gaps, check if the provider is still mounted before using ref.
    if (!ref.mounted) return;

    // Invalidate providers to trigger a full state refresh and navigation.
    ref.invalidate(onboardingStateProvider);
    ref.invalidate(homeProvider);
  }
}

// State class for the OnboardingViewModel
class OnboardingState {
  final int tasksPerDay;
  final int categoriesPerDay;
  final String userName;
  final bool isLoading;
  final String difficulty;

  OnboardingState({
    this.tasksPerDay = 3,
    this.categoriesPerDay = 3,
    this.userName = '',
    this.isLoading = false,
    this.difficulty = 'medium',
  });

  OnboardingState copyWith({
    int? tasksPerDay,
    int? categoriesPerDay,
    String? userName,
    bool? isLoading,
    String? difficulty,
  }) {
    return OnboardingState(
      tasksPerDay: tasksPerDay ?? this.tasksPerDay,
      categoriesPerDay: categoriesPerDay ?? this.categoriesPerDay,
      userName: userName ?? this.userName,
      isLoading: isLoading ?? this.isLoading,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}