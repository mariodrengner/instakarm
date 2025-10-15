import 'package:go_router/go_router.dart';
import 'package:instakarm/features/home/presentation/home_screen.dart';
import 'package:instakarm/features/onboarding/presentation/onboarding_screen.dart';
import 'package:instakarm/features/start/presentation/start_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const StartScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
