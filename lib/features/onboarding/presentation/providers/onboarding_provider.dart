import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instakarm/core/data/models/user_profile.dart';
import 'package:instakarm/features/onboarding/domain/repositories/i_user_profile_repository.dart';
import 'package:instakarm/features/onboarding/domain/repositories/user_profile_repository_provider.dart';

// State Notifier Provider for the Onboarding Logic
final onboardingViewModelProvider = StateNotifierProvider<OnboardingViewModel, OnboardingState>((ref) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return OnboardingViewModel(repository);
});


// State class for the OnboardingViewModel
class OnboardingState {
  final int tasksPerDay;
  final int categoriesPerDay;
  final String userName;
  final bool isLoading;

  OnboardingState({
    this.tasksPerDay = 3,
    this.categoriesPerDay = 3,
    this.userName = '',
    this.isLoading = false,
  });

  OnboardingState copyWith({
    int? tasksPerDay,
    int? categoriesPerDay,
    String? userName,
    bool? isLoading,
  }) {
    return OnboardingState(
      tasksPerDay: tasksPerDay ?? this.tasksPerDay,
      categoriesPerDay: categoriesPerDay ?? this.categoriesPerDay,
      userName: userName ?? this.userName,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}


// The ViewModel itself, now as a StateNotifier
class OnboardingViewModel extends StateNotifier<OnboardingState> {
  final IUserProfileRepository _userProfileRepository;

  OnboardingViewModel(this._userProfileRepository) : super(OnboardingState()) {
    regenerateRandomName();
  }

  void setDifficulty(int tasks, int categories) {
    state = state.copyWith(tasksPerDay: tasks, categoriesPerDay: categories);
  }

  void updateUserName(String name) {
    state = state.copyWith(userName: name);
  }

  void regenerateRandomName() {
    const adjectives = ['Happy', 'Brave', 'Clever', 'Sunny', 'Lucky'];
    const nouns = ['Panda', 'Lion', 'Tiger', 'Eagle', 'Fox'];
    final randomAdjective = adjectives[DateTime.now().millisecond % adjectives.length];
    final randomNoun = nouns[DateTime.now().millisecond % nouns.length];
    final randomNumber = DateTime.now().second;
    state = state.copyWith(userName: '$randomAdjective$randomNoun$randomNumber');
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(isLoading: true);
    final profile = UserProfile(
      name: state.userName,
      tasksPerDay: state.tasksPerDay,
      categoriesPerDay: state.categoriesPerDay,
    );
    await _userProfileRepository.saveProfile(profile);
    state = state.copyWith(isLoading: false);
  }
}