import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:instakarm/core/data/models/user_profile.dart';
import 'package:instakarm/features/onboarding/domain/repositories/i_user_profile_repository.dart';

class HiveUserProfileRepository implements IUserProfileRepository {
  static const String _profileKey = 'current_user_profile';

  final Box<UserProfile> _box;

  HiveUserProfileRepository(this._box);

  @override
  Future<UserProfile> getProfile() async {
    // Return the saved profile, or a default one if none exists.
    return _box.get(_profileKey) ?? UserProfile.defaultProfile();
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    await _box.put(_profileKey, profile);
  }

  @override
  Future<bool> hasCompletedOnboarding() async {
    return _box.containsKey(_profileKey);
  }

  @override
  Future<void> clearProfile() async {
    await _box.clear();
  }
}
