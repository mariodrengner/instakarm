import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:instakarm/features/home/presentation/home_screen.dart';
import 'package:instakarm/features/onboarding/presentation/onboarding_screen.dart';
import 'package:instakarm/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:instakarm/features/start/presentation/start_screen.dart';

/// A [ChangeNotifier] that notifies GoRouter to refresh its route when the
/// onboarding state changes.
///
/// This allows the router to reactively redirect users based on whether they
/// have completed the onboarding process.
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  /// Creates a new instance of [RouterNotifier].
  ///
  /// It listens to the [onboardingStateProvider] and calls [notifyListeners]
  /// whenever the state changes, triggering a route refresh.
  RouterNotifier(this._ref) {
    _ref.listen<AsyncValue<bool>>(
      onboardingStateProvider,
      (_, __) => notifyListeners(),
    );
  }
}

/// Provider for the [RouterNotifier].
final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

/// Provider that creates and configures the [GoRouter] instance.
final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: notifier,
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
      final onboardingState = ref.read(onboardingStateProvider);

      // While loading or if there's an error, don't redirect.
      if (onboardingState.isLoading || onboardingState.hasError) {
        return null;
      }

      final hasCompletedOnboarding = onboardingState.requireValue;
      final location = state.uri.toString();

      final isGoingToOnboarding = location == '/onboarding';
      final isGoingToStart = location == '/';

      // If onboarding is complete, redirect from start/onboarding to home.
      if (hasCompletedOnboarding && (isGoingToStart || isGoingToOnboarding)) {
        return '/home';
      }

      // If onboarding is not complete, prevent access to home.
      if (!hasCompletedOnboarding && location == '/home') {
        return '/';
      }

      // No redirect needed in other cases.
      return null;
    },
  );
});
