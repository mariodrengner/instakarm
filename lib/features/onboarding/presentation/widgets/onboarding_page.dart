import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String text;

  const OnboardingPage({super.key, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      // margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text(text)),
          ),
        ],
      ),
    );
  }
}
