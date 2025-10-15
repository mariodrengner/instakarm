import 'package:flutter/material.dart';
import 'package:instakarm/core/theme/app_theme.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String text;
  final String image;

  const OnboardingPage(
      {super.key, required this.title, required this.text, this.image = ''});

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
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
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
