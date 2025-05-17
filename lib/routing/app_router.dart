// lib/routing/app_router.dart - Updated with named routes
import 'package:deepex/features/auth/forgot_password/forgot_password.dart';
import 'package:deepex/features/auth/login/login_screen.dart';
import 'package:deepex/features/auth/otp/otp_verification_screen.dart';
import 'package:deepex/features/auth/signup/register_screen.dart';
import 'package:deepex/features/onboarding/onboarding_screen.dart';
import 'package:deepex/screens/add_money/add_money.dart';
import 'package:deepex/screens/add_money/bank_transfer_screen.dart';
import 'package:deepex/screens/add_money/card_topup_screen.dart';
import 'package:deepex/screens/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Route names for easy reference
class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String addMoney = '/add-money';
  static const String bankTransfer = '/bank-transfer';
  static const String cardTopup = '/card-topup';
  static const String giftCards = '/gift-cards';
  static const String airtime = '/airtime';
  static const String data = '/data';
  static const String electricity = '/electricity';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    debugLogDiagnostics: kDebugMode,
    initialLocation: AppRoutes.onboarding,
    routes: [
      // Base redirect
      GoRoute(
        path: '/',
        redirect: (_, __) => AppRoutes.onboarding,
      ),

      // Authentication flows
      GoRoute(
        name: 'onboarding',
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        name: 'login',
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: 'register',
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        name: 'forgot-password',
        path: AppRoutes.forgotPassword,
        builder: (context, state) {
          // Get email from state.extra if provided
          final email = state.extra as String?;
          return ForgotPasswordScreen(email: email);
        },
      ),
      GoRoute(
        name: 'otp',
        path: AppRoutes.otp,
        builder: (context, state) {
          // Get email from state.extra if provided
          final email = state.extra as String?;
          return OtpVerificationScreen(email: email);
        },
      ),

      // Main app screens
      GoRoute(
        name: 'home',
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),

      // Money management screens
      GoRoute(
        name: 'add-money',
        path: AppRoutes.addMoney,
        builder: (context, state) => const AddMoneyScreen(),
      ),
      GoRoute(
        name: 'bank-transfer',
        path: AppRoutes.bankTransfer,
        builder: (context, state) => const BankTransferScreen(),
      ),
      GoRoute(
        name: 'card-topup',
        path: AppRoutes.cardTopup,
        builder: (context, state) => const CardTopUpScreen(),
      ),

      // Add placeholder routes for other sections
      GoRoute(
        name: 'gift-cards',
        path: AppRoutes.giftCards,
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Gift Cards'),
      ),
      GoRoute(
        name: 'airtime',
        path: AppRoutes.airtime,
        builder: (context, state) => const PlaceholderScreen(title: 'Airtime'),
      ),
      GoRoute(
        name: 'data',
        path: AppRoutes.data,
        builder: (context, state) => const PlaceholderScreen(title: 'Data'),
      ),
      GoRoute(
        name: 'electricity',
        path: AppRoutes.electricity,
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Electricity'),
      ),
    ],

    // Error handling for invalid routes
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Route not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.matchedLocation,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.goNamed('home'),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
  );
});

// Placeholder screen for routes that don't have implementations yet
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$title Screen',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.goNamed('home'),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
