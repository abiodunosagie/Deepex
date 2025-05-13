// lib/routing/app_router.dart
import 'package:deepex/features/auth/login_screen.dart';
import 'package:deepex/features/auth/register_screen.dart';
import 'package:deepex/features/onboarding/onboarding_screen.dart';
import 'package:deepex/screens/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/auth_provider.dart';
import '../providers/onboarding_state_provider.dart';

// Router provider that manages app navigation
final routerProvider = Provider<GoRouter>(
  (ref) {
    final authState = ref.watch(authProvider);
    final onboardingState = ref.watch(onboardingProvider);

    return GoRouter(
      debugLogDiagnostics: kDebugMode,
      // Show logs only in debug mode
      initialLocation: '/',
      // Start at root for proper redirection logic
      redirect: (context, state) {
        final isLoggedIn = authState.isAuthenticated;
        final hasCompletedOnboarding = onboardingState.isCompleted;
        final isLoggingIn = state.matchedLocation == '/login';
        final isRegistering = state.matchedLocation == '/register';
        final isOnboarding = state.matchedLocation == '/onboarding';
        final isHome = state.matchedLocation == '/home';
        final isInitialRoute = state.matchedLocation == '/';

        if (kDebugMode) {
          print('Current path: ${state.matchedLocation}');
          print('Auth state: $isLoggedIn');
          print('Onboarding completed: $hasCompletedOnboarding');
        }

        // ROUTING LOGIC:
        // 1. If at root path, redirect based on auth and onboarding status
        if (isInitialRoute) {
          // First, check if onboarding is completed
          if (!hasCompletedOnboarding) {
            return '/onboarding';
          }
          // If onboarding is done but not logged in, go to login
          if (!isLoggedIn) {
            return '/login';
          }
          // If both onboarding is done and logged in, go to home
          return '/home';
        }

        // 2. If logged in but trying to access auth screens, redirect to home
        if (isLoggedIn && (isLoggingIn || isRegistering || isOnboarding)) {
          return '/home';
        }

        // 3. If not logged in and not on auth screens or onboarding, redirect to login
        if (!isLoggedIn &&
            !isLoggingIn &&
            !isRegistering &&
            !isOnboarding &&
            !isInitialRoute) {
          return '/login';
        }

        // 4. If onboarding is not completed and not on onboarding, redirect to onboarding
        if (!hasCompletedOnboarding && !isOnboarding && !isInitialRoute) {
          return '/onboarding';
        }

        // No redirect needed
        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const OnboardingScreen(), // This is just a placeholder since redirect will handle it
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    );
  },
);
