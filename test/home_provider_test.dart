import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instakarm/core/data/models/daily_task_log.dart';
import 'package:instakarm/core/data/models/user_profile.dart';
import 'package:instakarm/features/home/domain/repositories/i_task_repository.dart';
import 'package:instakarm/features/home/presentation/providers/home_provider.dart';
import 'package:instakarm/features/onboarding/domain/repositories/i_user_profile_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockUserProfileRepository extends Mock implements IUserProfileRepository {}
class MockTaskRepository extends Mock implements ITaskRepository {}
class FakeUserProfile extends Fake implements UserProfile {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeUserProfile());
  });

  group('Home Notifier Test', () {
    late ProviderContainer container;
    late IUserProfileRepository mockUserProfileRepository;
    late ITaskRepository mockTaskRepository;

    setUp(() {
      mockUserProfileRepository = MockUserProfileRepository();
      mockTaskRepository = MockTaskRepository();

      container = ProviderContainer(
        overrides: [
          userProfileRepositoryProvider.overrideWith((ref) async => mockUserProfileRepository),
          taskRepositoryProvider.overrideWith((ref) async => mockTaskRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state is loaded correctly', () async {
      // ARRANGE
      final userProfile = UserProfile.defaultProfile();
      final tasks = [
        DailyTaskLog(id: '1', taskName: 'Task 1', categoryName: 'cat1', categoryColorHex: '#FFFFFF', date: DateTime.now()),
      ];
      when(() => mockUserProfileRepository.getProfile()).thenAnswer((_) async => userProfile);
      when(() => mockTaskRepository.getOrGenerateDailyTasks()).thenAnswer((_) async => tasks);

      // ACT
      final homeState = await container.read(homeProvider.future);

      // ASSERT
      expect(homeState.userProfile, userProfile);
      expect(homeState.tasks, tasks);
    });

    test('completeTask updates state and repositories', () async {
      // ARRANGE
      final userProfile = UserProfile.defaultProfile();
      final tasks = [
        DailyTaskLog(id: '1', taskName: 'Task 1', categoryName: 'cat1', categoryColorHex: '#FFFFFF', date: DateTime.now()),
      ];
      when(() => mockUserProfileRepository.getProfile()).thenAnswer((_) async => userProfile);
      when(() => mockTaskRepository.getOrGenerateDailyTasks()).thenAnswer((_) async => tasks);
      when(() => mockTaskRepository.updateTaskCompletion('1', true)).thenAnswer((_) async {});
      when(() => mockUserProfileRepository.saveProfile(any())).thenAnswer((_) async {});

      // ACT
      await container.read(homeProvider.future); // Initial load
      await container.read(homeProvider.notifier).completeTask('1');
      final homeState = container.read(homeProvider).value!;

      // ASSERT
      expect(homeState.tasks.first.isCompleted, isTrue);
      expect(homeState.userProfile.karmaPoints, 1);
      verify(() => mockTaskRepository.updateTaskCompletion('1', true)).called(1);
      verify(() => mockUserProfileRepository.saveProfile(any(that: predicate<UserProfile>((p) => p.karmaPoints == 1)))).called(1);
    });

    test('addMoreTasks adds a new task to the state', () async {
      // ARRANGE
      final userProfile = UserProfile.defaultProfile();
      final initialTasks = [
        DailyTaskLog(id: '1', taskName: 'Task 1', categoryName: 'cat1', categoryColorHex: '#FFFFFF', date: DateTime.now()),
      ];
      final newTask = DailyTaskLog(id: '2', taskName: 'Task 2', categoryName: 'cat2', categoryColorHex: '#000000', date: DateTime.now());

      when(() => mockUserProfileRepository.getProfile()).thenAnswer((_) async => userProfile);
      when(() => mockTaskRepository.getOrGenerateDailyTasks()).thenAnswer((_) async => initialTasks);
      when(() => mockTaskRepository.generateNewTask()).thenAnswer((_) async => newTask);

      // ACT
      await container.read(homeProvider.future); // Initial load
      await container.read(homeProvider.notifier).addMoreTasks();
      final homeState = container.read(homeProvider).value!;

      // ASSERT
      expect(homeState.tasks.length, 2);
      expect(homeState.tasks.last, newTask);
    });
  });
}
