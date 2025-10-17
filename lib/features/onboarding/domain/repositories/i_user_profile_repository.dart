import 'package:instakarm/core/data/models/user_profile.dart';

/// Abstract repository for managing user profile data.
///
/// This interface defines the contract for saving, retrieving, and checking
/// the onboarding status of a user's profile.
abstract class IUserProfileRepository {
  /// Saves the user's profile data.
  ///
  /// The [profile] object contains all the necessary information about the user.
  Future<void> saveProfile(UserProfile profile);

  /// Retrieves the current user's profile.
  ///
  /// If no profile is found, it should return a default profile.
  Future<UserProfile> getProfile();

  /// Checks if the user has completed the onboarding process.
  ///
  /// Returns `true` if a profile has been saved, `false` otherwise.
  Future<bool> hasCompletedOnboarding();

  /// Clears all user profile data.
  ///
  /// This is useful for resetting the app's state, for example, during a logout
  /// or a full data reset.
  Future<void> clearProfile();
}
