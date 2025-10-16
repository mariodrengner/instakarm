import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_test/hive_ce_test.dart';
import 'package:instakarm/app_shell/app.dart';
import 'package:instakarm/core/data/models/daily_task_log.dart';
import 'package:instakarm/core/data/models/user_profile.dart';
import 'package:instakarm/features/home/presentation/providers/home_provider.dart';
import 'package:instakarm/features/onboarding/domain/repositories/i_user_profile_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('App Reset Flow Test', () {
    late ProviderContainer container;
    late IUserProfileRepository userProfileRepository;

    setUp(() async {
      await setUpTestHive();

      Hive.registerAdapter(UserProfileAdapter());
      Hive.registerAdapter(DailyTaskLogAdapter());

      await Hive.openBox<UserProfile>('user_profile_box');
      await Hive.openBox<DailyTaskLog>('daily_task_log_box');

      container = ProviderContainer();
      userProfileRepository = container.read(userProfileRepositoryProvider);
    });

    tearDown(() async {
      container.dispose();
      await tearDownTestHive();
    });

    testWidgets('Tapping reset button clears data and navigates to StartScreen', (WidgetTester tester) async {
      // ARRANGE: Set up the app state as if onboarding has been completed.
      final initialProfile = UserProfile(
        name: 'Test User',
        karmaPoints: 100,
        tasksPerDay: 3,
        categoriesPerDay: 3,
        difficulty: 'medium',
      );
      await userProfileRepository.saveProfile(initialProfile);

      final taskBox = Hive.box<DailyTaskLog>('daily_task_log_box');
      final testTask = DailyTaskLog(
        id: '1',
        taskName: 'Test Task',
        categoryName: 'Test Category',
        categoryColorHex: '#FFFFFF',
        date: DateTime.now(),
      );
      await taskBox.put(testTask.id, testTask);
      expect(await userProfileRepository.hasCompletedOnboarding(), isTrue);

      // ACT:
      // 1. Render the app and wait for initial navigation to complete.
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();

      // 2. Verify we are on the HomeScreen.
      expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);

      // 3. Tap the reset button to trigger the reset and navigation.
      await tester.tap(find.byIcon(Icons.refresh_rounded));

      // 4. pumpAndSettle waits for all asynchronous operations (DB writes),
      //    provider invalidations, and navigation animations to complete.
      await tester.pumpAndSettle();

      // ASSERT:
      // 1. Verify the StartScreen is now visible.
      expect(find.text('Level up your Mind'), findsOneWidget);
      expect(find.byIcon(Icons.refresh_rounded), findsNothing);

      // 2. Verify data is cleared.
      expect(await userProfileRepository.hasCompletedOnboarding(), isFalse);
      expect(taskBox.isEmpty, isTrue);
    });
  });
}