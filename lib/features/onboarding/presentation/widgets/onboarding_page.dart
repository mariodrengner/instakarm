import 'package:flutter/material.dart';
import 'package:instakarm/core/theme/app_theme.dart';

/// A widget that displays a single page of the onboarding flow.
///
/// It typically contains a title, a descriptive text, and an optional image,
/// all styled within a consistent layout.
class OnboardingPage extends StatelessWidget {
  /// The main title of the onboarding page.
  final String title;

  /// The descriptive text that provides more details.
  final String text;

  /// The path to the image asset to be displayed.
  ///
  /// If the image path is empty, no image will be shown.
  final String image;

  /// Creates an [OnboardingPage].
  const OnboardingPage({
    super.key,
    required this.title,
    required this.text,
    this.image = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.glassCardDecoration(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          if (image != '')
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Image.asset(image),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha((255 * 0.8).round()),
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
