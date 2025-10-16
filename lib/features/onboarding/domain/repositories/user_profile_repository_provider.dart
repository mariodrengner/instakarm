import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instakarm/features/onboarding/data/repositories/hive_user_profile_repository.dart';
import 'package:instakarm/features/onboarding/domain/repositories/i_user_profile_repository.dart';

// Provider for the Repository implementation
final userProfileRepositoryProvider = Provider<IUserProfileRepository>((ref) {
  return HiveUserProfileRepository();
});
