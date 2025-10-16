import 'package:flutter/material.dart';
import 'package:instakarm/core/data/models/user_profile.dart';
import 'package:instakarm/features/onboarding/domain/repositories/i_user_profile_repository.dart';

class OnboardingViewModel extends ChangeNotifier {
  final IUserProfileRepository _userProfileRepository;

  OnboardingViewModel(this._userProfileRepository);

  // State
  int _tasksPerDay = 3;
  int _categoriesPerDay = 3;
  String _userName = '';
  bool _isLoading = false;

  // Getters
  int get tasksPerDay => _tasksPerDay;
  int get categoriesPerDay => _categoriesPerDay;
  String get userName => _userName;
  bool get isLoading => _isLoading;

  // Methods
  void initialize() {
    _generateRandomName();
  }

  void setDifficulty(int tasks, int categories) {
    _tasksPerDay = tasks;
    _categoriesPerDay = categories;
    notifyListeners();
  }

  void updateUserName(String name) {
    _userName = name;
  }

  void _generateRandomName() {
    const adjectives = ['Happy', 'Brave', 'Clever', 'Sunny', 'Lucky'];
    const nouns = ['Panda', 'Lion', 'Tiger', 'Eagle', 'Fox'];
    final randomAdjective = adjectives[DateTime.now().millisecond % adjectives.length];
    final randomNoun = nouns[DateTime.now().millisecond % nouns.length];
    final randomNumber = DateTime.now().second;
    _userName = '$randomAdjective$randomNoun$randomNumber';
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _setLoading(true);
    final profile = UserProfile(
      name: _userName,
      tasksPerDay: _tasksPerDay,
      categoriesPerDay: _categoriesPerDay,
    );
    await _userProfileRepository.saveProfile(profile);
    _setLoading(false);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
