import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_test/hive_ce_test.dart';
import 'package:instakarm/core/data/models/daily_task_log.dart';
import 'package:instakarm/core/data/models/user_profile.dart';
import 'package:instakarm/features/home/presentation/providers/home_provider.dart';
import 'package:instakarm/features/onboarding/domain/repositories/i_user_profile_repository.dart';

void main() {
  // Initialize the Flutter test binding
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Profile Reset Logic Test', () {
    late ProviderContainer container;
    late IUserProfileRepository repository;

    setUp(() async {
      // Use an in-memory Hive implementation for testing
      await setUpTestHive();

      // Register adapters, crucial for storing custom objects
      Hive.registerAdapter(UserProfileAdapter());
      Hive.registerAdapter(DailyTaskLogAdapter());

      // Create a new ProviderContainer for each test.
      container = ProviderContainer();

      // Get the repository from the container
      repository = container.read(userProfileRepositoryProvider);
    });

    tearDown(() async {
      // Dispose the container to prevent state from leaking between tests
      container.dispose();
      // Clean up the in-memory Hive database
      await tearDownTestHive();
    });

    test('Clearing profile resets repository and homeProvider state', () async {
      // ARRANGE
      // 1. Create and save a dummy user profile
      final initialProfile = UserProfile(
        name: 'Test User',
        difficulty: 'easy',
        tasksPerDay: 5,
        categoriesPerDay: 3,
        karmaPoints: 100,
      );
      await repository.saveProfile(initialProfile);

      // 2. Verify that onboarding is now marked as completed
      expect(await repository.hasCompletedOnboarding(), isTrue);

      // 3. Read the homeProvider for the first time to load the saved profile
      final initialState = await container.read(homeProvider.future);
      expect(initialState.userProfile.name, 'Test User');
      expect(initialState.userProfile.karmaPoints, 100);

      // ACT
      // 1. Clear the profile from the database
      await repository.clearProfile();

      // 2. Refresh the homeProvider to force it to re-fetch the data
      final refreshedState = await container.refresh(homeProvider.future);

      // ASSERT
      // 1. Verify that the repository now reports onboarding as not completed
      expect(await repository.hasCompletedOnboarding(), isFalse);

      // 2. Verify that the refreshed homeProvider state has reverted to the default profile
      final defaultProfile = UserProfile.defaultProfile();
      expect(refreshedState.userProfile.name, defaultProfile.name);
      expect(refreshedState.userProfile.karmaPoints, defaultProfile.karmaPoints);
      expect(refreshedState.userProfile.difficulty, defaultProfile.difficulty);
    });
  });
}
