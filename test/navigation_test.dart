import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_test/hive_ce_test.dart';
import 'package:instakarm/app_shell/app_router.dart';
import 'package:instakarm/core/data/models/user_profile.dart';
import 'package:instakarm/features/home/presentation/home_screen.dart';
import 'package:instakarm/features/home/presentation/providers/home_provider.dart';
import 'package:instakarm/features/onboarding/data/repositories/hive_user_profile_repository.dart';
import 'package:instakarm/features/onboarding/domain/repositories/i_user_profile_repository.dart';
import 'package:instakarm/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:instakarm/features/start/presentation/start_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProviderContainer container;
  late IUserProfileRepository userProfileRepository;
  late Box<UserProfile> userProfileBox;

  setUp(() async {
    await setUpTestHive();
    Hive.registerAdapter(UserProfileAdapter());
    userProfileBox = await Hive.openBox<UserProfile>('user_profile_box');
    userProfileRepository = HiveUserProfileRepository(userProfileBox);

    // The container is created here, but the router is NOT read yet.
    container = ProviderContainer(
      overrides: [
        userProfileRepositoryProvider.overrideWith((ref) async => userProfileRepository),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await tearDownTestHive();
  });

  testWidgets('Router navigates to HomeScreen when onboarding is complete', (WidgetTester tester) async {
    // ARRANGE:
    // 1. Set the onboarding status to complete in the repository.
    await userProfileRepository.saveProfile(UserProfile.defaultProfile());
    // 2. Invalidate the provider so it re-reads the new state.
    container.invalidate(onboardingStateProvider);
    // 3. CRITICAL: Await the async provider to ensure it's initialized.
    await container.read(userProfileRepositoryProvider.future);
    // 4. Now it's safe to read the router.
    final router = container.read(goRouterProvider);

    // ACT: Pump the widget with the fully initialized router.
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );

    await tester.pumpAndSettle();

    // ASSERT: Verify that the HomeScreen is now displayed.
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(StartScreen), findsNothing);
  });

  testWidgets('Router navigates to StartScreen when onboarding is not complete', (WidgetTester tester) async {
    // ARRANGE:
    // 1. Ensure the profile is cleared.
    await userProfileRepository.clearProfile();
    // 2. Invalidate the provider.
    container.invalidate(onboardingStateProvider);
    // 3. CRITICAL: Await the async provider.
    await container.read(userProfileRepositoryProvider.future);
    // 4. Now read the router.
    final router = container.read(goRouterProvider);

    // ACT:
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // ASSERT:
    expect(find.byType(StartScreen), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);
  });
}

