import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:instakarm/core/data/models/daily_task_log.dart';
import 'package:instakarm/features/home/presentation/providers/home_provider.dart';
import 'package:instakarm/features/onboarding/domain/repositories/user_profile_repository_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _showTaskDetails(BuildContext context, WidgetRef ref, DailyTaskLog task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.4,
        maxChildSize: 0.9,
        minChildSize: 0.2,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: scrollController,
            children: [
              Text(task.categoryName, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(task.taskName, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  ref.read(homeProvider.notifier).completeTask(task.id);
                  Navigator.pop(context); // Close the modal
                },
                child: const Text('Als erledigt markieren'),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsyncState = ref.watch(homeProvider);

    return Scaffold(
      body: homeAsyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Fehler: $err')),
        data: (state) {
          final incompleteTasks = state.tasks.where((t) => !t.isCompleted).toList();

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text('Hallo, ${state.userProfile.name}!'),
                backgroundColor: Colors.transparent,
                elevation: 0,
                foregroundColor: Theme.of(context).colorScheme.onSurface,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Reset Onboarding',
                    onPressed: () async {
                      await ref.read(userProfileRepositoryProvider).clearProfile();
                      if (context.mounted) {
                        context.go('/');
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {},
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (incompleteTasks.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text('Super! Alle Aufgaben für heute erledigt.'),
                        ),
                      );
                    }
                    final task = incompleteTasks[index];
                    return ListTile(
                      title: Text(task.taskName),
                      subtitle: Text(task.categoryName),
                      onTap: () => _showTaskDetails(context, ref, task),
                    );
                  },
                  childCount: incompleteTasks.isEmpty ? 1 : incompleteTasks.length,
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: homeAsyncState.when(
        data: (state) => state.tasks.where((t) => !t.isCompleted).isEmpty
            ? FloatingActionButton(
                onPressed: () => ref.read(homeProvider.notifier).addMoreTasks(),
                child: const Icon(Icons.add),
              )
            : const SizedBox.shrink(),
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: homeAsyncState.when(
        data: (state) => _KarmaBottomBar(
          karmaPoints: state.userProfile.karmaPoints,
          tasksToday: state.userProfile.tasksPerDay,
        ),
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }
}

class _KarmaBottomBar extends StatelessWidget {
  final int karmaPoints;
  final int tasksToday;

  const _KarmaBottomBar({required this.karmaPoints, required this.tasksToday});

  @override
  Widget build(BuildContext context) {
    // Example: Level up every 10 points
    final currentLevel = (karmaPoints / 10).floor();
    final pointsInLevel = karmaPoints % 10;
    final progress = pointsInLevel / 10.0;

    return BottomAppBar(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Level $currentLevel', style: Theme.of(context).textTheme.titleMedium),
                Text('$pointsInLevel / 10 Karma', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          LinearProgressIndicator(
            value: progress,
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}
