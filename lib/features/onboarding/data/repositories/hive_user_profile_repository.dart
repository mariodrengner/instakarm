import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:instakarm/core/data/models/user_profile.dart';
import 'package:instakarm/features/onboarding/domain/repositories/i_user_profile_repository.dart';

class HiveUserProfileRepository implements IUserProfileRepository {
  static const String _boxName = 'user_profile_box';
  static const String _profileKey = 'current_user_profile';

  // Private constructor
  HiveUserProfileRepository._();

  // Static instance
  static final HiveUserProfileRepository _instance = HiveUserProfileRepository._();

  // Factory constructor to return the instance
  factory HiveUserProfileRepository() {
    return _instance;
  }

  late Box<UserProfile> _profileBox;

  Future<void> init() async {
    _profileBox = await Hive.openBox<UserProfile>(_boxName);
  }

  @override
  Future<UserProfile> getProfile() async {
    // Return the saved profile, or a default one if none exists.
    return _profileBox.get(_profileKey) ?? UserProfile.defaultProfile();
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    await _profileBox.put(_profileKey, profile);
  }

  @override
  Future<bool> hasCompletedOnboarding() async {
    return _profileBox.containsKey(_profileKey);
  }

  @override
  Future<void> clearProfile() async {
    await _profileBox.clear();
  }
}
