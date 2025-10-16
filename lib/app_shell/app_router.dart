import 'package:go_router/go_router.dart';
import 'package:instakarm/features/home/presentation/home_screen.dart';
import 'package:instakarm/features/onboarding/data/repositories/hive_user_profile_repository.dart';
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
    redirect: (context, state) async {
      final hasCompletedOnboarding = await HiveUserProfileRepository().hasCompletedOnboarding();
      final isGoingToOnboarding = state.matchedLocation == '/onboarding';
      final isGoingToStart = state.matchedLocation == '/';

      // If onboarding is complete and the user is on the start/onboarding page, redirect to home
      if (hasCompletedOnboarding && (isGoingToStart || isGoingToOnboarding)) {
        return '/home';
      }

      // If onboarding is not complete and the user tries to access home, redirect to start
      if (!hasCompletedOnboarding && state.matchedLocation == '/home') {
        return '/';
      }

      // No redirect needed
      return null;
    },
  );
}
