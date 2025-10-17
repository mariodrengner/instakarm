import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_test/hive_ce_test.dart';
import 'package:instakarm/app_shell/app.dart';
import 'package:instakarm/core/data/models/daily_task_log.dart';
import 'package:instakarm/core/data/models/user_profile.dart';
import 'package:instakarm/features/home/presentation/home_screen.dart';
import 'package:instakarm/features/home/presentation/providers/home_provider.dart';
import 'package:instakarm/features/onboarding/domain/repositories/i_user_profile_repository.dart';
import 'package:instakarm/features/start/presentation/start_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProviderContainer container;
  late IUserProfileRepository userProfileRepository;
  late Box<DailyTaskLog> dailyTaskLogBox;

  setUp(() async {
    await setUpTestHive();
    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(DailyTaskLogAdapter());
    await Hive.openBox<UserProfile>('user_profile_box');
    dailyTaskLogBox = await Hive.openBox<DailyTaskLog>('daily_task_log_box');

    container = ProviderContainer();
    userProfileRepository = await container.read(userProfileRepositoryProvider.future);
  });

  tearDown(() async {
    container.dispose();
    await tearDownTestHive();
  });

  testWidgets('Router navigates to HomeScreen when onboarding is complete', (WidgetTester tester) async {
    // ARRANGE:
    // 1. Mark onboarding as complete.
    await userProfileRepository.saveProfile(UserProfile.defaultProfile());

    // 2. CRITICAL FIX: Pre-populate the database with a task for today.
    // This prevents homeProvider from trying to load assets, which hangs the test.
    final todayTask = DailyTaskLog(
      id: '1',
      taskName: 'Test Task',
      categoryName: 'Test Category',
      categoryColorHex: '#FFFFFF',
      date: DateTime.now(),
    );
    await dailyTaskLogBox.put(todayTask.id, todayTask);

    // ACT:
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const App(),
      ),
    );

    // pumpAndSettle will now complete successfully.
    await tester.pumpAndSettle();

    // ASSERT:
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(StartScreen), findsNothing);
  });

  testWidgets('Router navigates to StartScreen when onboarding is not complete', (WidgetTester tester) async {
    // ARRANGE:
    await userProfileRepository.clearProfile();

    // ACT:
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    // ASSERT:
    expect(find.byType(StartScreen), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);
  });
}
