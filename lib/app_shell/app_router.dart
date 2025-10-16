import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:instakarm/features/home/presentation/home_screen.dart';
import 'package:instakarm/features/onboarding/presentation/onboarding_screen.dart';
import 'package:instakarm/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:instakarm/features/start/presentation/start_screen.dart';

/// A Notifier that notifies GoRouter to refresh its route when the onboarding state changes.
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    // Listen to the onboarding state provider.
    // Any change in this provider will trigger a notification to the router.
    _ref.listen<AsyncValue<bool>>(
      onboardingStateProvider,
      (_, _) => notifyListeners(),
    );
  }
}

// Provider for the RouterNotifier.
final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: notifier, // This is the key to reactive routing!
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
    redirect: (context, state) {
      // Always read the latest state directly from the provider inside the redirect.
      final onboardingState = ref.read(onboardingStateProvider);

      // While the onboarding status is loading, don't redirect.
      if (onboardingState.isLoading || onboardingState.hasError) {
        return null;
      }

      final hasCompletedOnboarding = onboardingState.requireValue;
      final location = state.uri.toString();

      final isGoingToOnboarding = location == '/onboarding';
      final isGoingToStart = location == '/';

      // If onboarding is complete and the user is on the start/onboarding page, redirect to home.
      if (hasCompletedOnboarding && (isGoingToStart || isGoingToOnboarding)) {
        return '/home';
      }

      // If onboarding is not complete and the user tries to access home, redirect to start.
      if (!hasCompletedOnboarding && location == '/home') {
        return '/';
      }

      // No redirect needed.
      return null;
    },
  );
});
