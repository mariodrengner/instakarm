import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instakarm/core/data/models/daily_task_log.dart';
import 'package:instakarm/features/home/presentation/providers/home_provider.dart';
import 'package:instakarm/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:instakarm/l10n/app_localizations.dart';
import 'package:instakarm/shared/widgets/glass_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getCategoryDisplayName(AppLocalizations l10n, String categoryKey) {
    switch (categoryKey) {
      case 'category_grounding':
        return l10n.category_grounding;
      case 'category_creativity':
        return l10n.category_creativity;
      case 'category_confidence':
        return l10n.category_confidence;
      case 'category_compassion':
        return l10n.category_compassion;
      case 'category_expression':
        return l10n.category_expression;
      case 'category_intuition':
        return l10n.category_intuition;
      case 'category_awareness':
        return l10n.category_awareness;
      default:
        return categoryKey; // Fallback to key if not found
    }
  }

  void _showTaskDetails(BuildContext context, WidgetRef ref, DailyTaskLog task) {
    final l10n = AppLocalizations.of(context)!;
    // Temporarily display the key itself
    final categoryDisplayName = _getCategoryDisplayName(l10n, task.categoryName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFEDAFB8),
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
              Text(categoryDisplayName, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(task.taskName, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  ref.read(homeProvider.notifier).completeTask(task.id);
                  Navigator.pop(context); // Close the modal
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7E1D7),
      body: homeAsyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Fehler: $err')),
        data: (state) {
          final incompleteTasks = state.tasks.where((t) => !t.isCompleted).toList();

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text('Hallo, ${state.userProfile.name}!'),
                backgroundColor: const Color(0xFFF7E1D7),
                elevation: 0,
                foregroundColor: Colors.black87,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    tooltip: 'Reset Onboarding',
                    onPressed: () {
                      ref.read(onboardingViewModelProvider.notifier).resetOnboarding();
                    },
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
                    // Temporarily display the key itself
                    final categoryDisplayName = _getCategoryDisplayName(l10n, task.categoryName);
                    final color = _colorFromHex(task.categoryColorHex);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: GlassCard(
                        color: color,
                        child: ListTile(
                          title: Text(task.taskName),
                          subtitle: Text(categoryDisplayName),
                          onTap: () => _showTaskDetails(context, ref, task),
                        ),
                      ),
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
        error: (_, _) => const SizedBox.shrink(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: homeAsyncState.when(
        data: (state) => KarmaBottomBar(
          karmaPoints: state.userProfile.karmaPoints,
          tasksToday: state.userProfile.tasksPerDay,
        ),
        loading: () => const SizedBox.shrink(),
        error: (_, _) => const SizedBox.shrink(),
      ),
    );
  }
}

Color _colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  // Handle potential parsing errors with a fallback color
  try {
    // Use the hex code for full opacity
    return Color(int.parse('FF$hexCode', radix: 16));
  } catch (e) {
    return Colors.transparent;
  }
}

class KarmaBottomBar extends StatelessWidget {
  final int karmaPoints;
  final int tasksToday;

  const KarmaBottomBar({super.key, required this.karmaPoints, required this.tasksToday});

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
