import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instakarm/features/start/presentation/start_screen.dart';
import 'package:instakarm/features/onboarding/presentation/onboarding_screen.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const StartScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (_, _) => const OnboardingScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
