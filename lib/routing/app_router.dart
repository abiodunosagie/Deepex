// lib/routing/app_router.dart
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/onboarding/onboarding_screen.dart';
import '../providers/auth_provider.dart';
// ... other imports

// Create a simpler provider that's easier to debug
final onboardingCompletedProvider = Provider<bool>((ref) {
  // Default to false so new users always see onboarding
  return false;
});

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/onboarding', // Force initial location to onboarding
    debugLogDiagnostics: true, // Add this to see routing logs in debug console
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';
      final isOnboarding = state.matchedLocation == '/onboarding';

      // Debug prints to understand routing flow
      if (kDebugMode) {
        print('Current path: ${state.matchedLocation}');
        print('Auth state: ${authState.isAuthenticated}');
      }

      // *** SIMPLIFIED ROUTING LOGIC ***
      // For testing purposes, always show onboarding first
      // We'll implement the actual logic once onboarding is confirmed working

      // Only redirect away from onboarding if user is logged in
      if (isOnboarding && isLoggedIn) {
        return '/home';
      }

      // If not on onboarding or login/register and not logged in, go to login
      if (!isOnboarding && !isLoggingIn && !isRegistering && !isLoggedIn) {
        return '/login';
      }

      // If logged in but on auth screens, go to home
      if (isLoggedIn && (isLoggingIn || isRegistering)) {
        return '/home';
      }

      // Otherwise, don't redirect
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      // ... other routes
    ],
  );
});
