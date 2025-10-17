import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instakarm/core/data/models/daily_task_log.dart';
import 'package:instakarm/core/theme/app_theme.dart';
import 'package:instakarm/core/utils/extensions/color_extensions.dart';
import 'package:instakarm/features/home/presentation/providers/home_provider.dart';
import 'package:instakarm/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:instakarm/l10n/app_localizations.dart';
import 'package:instakarm/shared/widgets/glass_card.dart';

/// Extension to provide a localized display name for a category key.
extension CategoryLocalization on String {
  /// Returns the localized display name for a category key.
  String toCategoryDisplayName(AppLocalizations l10n) {
    switch (this) {
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
        return this; // Fallback to key if not found
    }
  }
}

/// The main screen of the app, displaying the user's daily tasks.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _showTaskDetails(BuildContext context, WidgetRef ref, DailyTaskLog task) {
    final l10n = AppLocalizations.of(context)!;
    final categoryDisplayName = task.categoryName.toCategoryDisplayName(l10n);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.modalBackground,
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
                  Navigator.pop(context);
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
      backgroundColor: AppTheme.scaffoldBackground,
      body: homeAsyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Fehler: $err')),
        data: (state) {
          final incompleteTasks = state.tasks.where((t) => !t.isCompleted).toList();

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text('Hallo, ${state.userProfile.name}!'),
                backgroundColor: AppTheme.scaffoldBackground,
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
                    final categoryDisplayName = task.categoryName.toCategoryDisplayName(l10n);
                    final color = task.categoryColorHex.toColor();
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
                backgroundColor: Colors.white,
                onPressed: () => ref.read(homeProvider.notifier).addMoreTasks(),
                child: const Icon(Icons.add),
              )
            : const SizedBox.shrink(),
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: homeAsyncState.when(
        data: (state) => KarmaBottomBar(
          karmaPoints: state.userProfile.karmaPoints,
        ),
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }
}

/// A bottom navigation bar that displays the user's karma points and level.
class KarmaBottomBar extends StatelessWidget {
  final int karmaPoints;

  const KarmaBottomBar({super.key, required this.karmaPoints});

  @override
  Widget build(BuildContext context) {
    final currentLevel = (karmaPoints / 10).floor();
    final pointsInLevel = karmaPoints % 10;
    final progress = pointsInLevel / 10.0;

    return BottomAppBar(
      color: '#b0c4b1'.toColor(),
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
            backgroundColor: '#dedbd2'.toColor(),
            color: '#4a5759'.toColor(),

            value: progress,
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}
