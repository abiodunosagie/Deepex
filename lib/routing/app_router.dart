import 'package:deepex/features/auth/login/login_screen.dart';
import 'package:deepex/features/auth/otp/otp_verification_screen.dart';
import 'package:deepex/features/auth/signup/register_screen.dart';
import 'package:deepex/features/onboarding/onboarding_screen.dart';
import 'package:deepex/screens/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/auth/forgot_password/forgot_password.dart';
import '../screens/add_money/add_money.dart';

// Simple router without complex redirects
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    debugLogDiagnostics: kDebugMode,
    initialLocation: '/onboarding',
    routes: [
      GoRoute(
        path: '/',
        redirect: (_, __) => '/onboarding',
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
        path: '/forgot-password',
        builder: (context, state) {
          // Get email from state.extra if provided
          final email = state.extra as String?;
          return ForgotPasswordScreen(email: email);
        },
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          // Get email from state.extra if provided
          final email = state.extra as String?;
          return OtpVerificationScreen(email: email);
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/add-money',
        builder: (context, state) => const AddMoneyScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route not found: ${state.matchedLocation}'),
      ),
    ),
  );
});
