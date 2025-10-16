import 'package:instakarm/core/data/models/user_profile.dart';

abstract class IUserProfileRepository {
  Future<void> saveProfile(UserProfile profile);
  Future<UserProfile> getProfile();
  Future<bool> hasCompletedOnboarding();
  Future<void> clearProfile();
}
