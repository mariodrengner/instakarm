import 'package:flutter/material.dart';

/// A widget that displays a series of dots to indicate the current page
/// in a [PageView] or [TabController].
///
/// This indicator is visually connected to a [TabController] to reflect
/// the current tab's index.
class PageIndicator extends StatelessWidget {
  /// The controller for the tab view, which this indicator represents.
  final TabController tabController;

  /// The index of the currently selected page.
  final int currentPageIndex;

  /// Creates a [PageIndicator].
  const PageIndicator({
    super.key,
    required this.tabController,
    required this.currentPageIndex,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TabPageSelector(
        controller: tabController,
        color: colorScheme.surface,
        selectedColor: colorScheme.primary,
      ),
    );
  }
}
