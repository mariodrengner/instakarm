import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:instakarm/core/data/models/user_profile.dart';

import 'package:instakarm/features/home/presentation/providers/home_provider.dart';
import 'package:instakarm/features/onboarding/domain/repositories/i_user_profile_repository.dart';

part 'onboarding_provider.g.dart';

/// Provider to asynchronously determine if onboarding has been completed.
///
/// This is used by the router to decide which screen to show when the app starts.
final onboardingStateProvider = FutureProvider<bool>((ref) async {
  final repository = await ref.watch(userProfileRepositoryProvider.future);
  return repository.hasCompletedOnboarding();
});

/// The view model for the onboarding process.
///
/// This notifier manages the state of the onboarding flow, including user selections
/// for difficulty and username, and handles the logic for completing or resetting
/// the onboarding process.
@riverpod
class OnboardingViewModel extends _$OnboardingViewModel {
  late IUserProfileRepository _userProfileRepository;

  @override
  Future<OnboardingState> build() async {
    _userProfileRepository = await ref.watch(userProfileRepositoryProvider.future);
    return OnboardingState(userName: _generateRandomName());
  }

  /// Generates a random username.
  String _generateRandomName() {
    const adjectives = ['Happy', 'Brave', 'Clever', 'Sunny', 'Lucky'];
    const nouns = ['Panda', 'Lion', 'Tiger', 'Eagle', 'Fox'];
    final randomAdjective =
        adjectives[DateTime.now().millisecond % adjectives.length];
    final randomNoun = nouns[DateTime.now().millisecond % nouns.length];
    final randomNumber = DateTime.now().second;
    return '$randomAdjective$randomNoun$randomNumber';
  }

  /// Sets the difficulty level for the tasks.
  void setDifficulty(String difficulty, int tasks, int categories) {
    final currentState = state.value;
    if (currentState == null) return;
    state = AsyncData(currentState.copyWith(
      difficulty: difficulty,
      tasksPerDay: tasks,
      categoriesPerDay: categories,
    ));
  }

  /// Updates the user's chosen name.
  void updateUserName(String name) {
    final currentState = state.value;
    if (currentState == null) return;
    state = AsyncData(currentState.copyWith(userName: name));
  }

  /// Generates a new random name for the user.
  void regenerateRandomName() {
    final currentState = state.value;
    if (currentState == null) return;
    state = AsyncData(currentState.copyWith(userName: _generateRandomName()));
  }

  /// Completes the onboarding process by saving the user's profile.
  Future<void> completeOnboarding() async {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncData(currentState.copyWith(isLoading: true));

    final profile = UserProfile(
      name: currentState.userName,
      tasksPerDay: currentState.tasksPerDay,
      categoriesPerDay: currentState.categoriesPerDay,
      difficulty: currentState.difficulty,
    );
    await _userProfileRepository.saveProfile(profile);

    // Invalidate the onboarding state to trigger navigation.
    ref.invalidate(onboardingStateProvider);

    state = AsyncData(currentState.copyWith(isLoading: false));
  }

  /// Resets the onboarding status and clears all user data.
  Future<void> resetOnboarding() async {
    final userProfileRepo =
        await ref.read(userProfileRepositoryProvider.future);
    final taskRepo = await ref.read(taskRepositoryProvider.future);

    await userProfileRepo.clearProfile();
    await taskRepo.clearTasks();

    if (!ref.mounted) return;

    // Invalidate providers to refresh the app's state.
    ref.invalidate(onboardingStateProvider);
    ref.invalidate(homeProvider);
  }
}

/// Represents the state of the onboarding screen.
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