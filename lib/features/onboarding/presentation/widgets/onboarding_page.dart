import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String text;
  final String image;

  const OnboardingPage({super.key, required this.title, required this.text, this.image = ''});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white54,
      shadowColor: Colors.transparent,
      elevation: 0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
          ),
          if (image != '')
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Image.asset(image),
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
