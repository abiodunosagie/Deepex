// lib/routing/app_router.dart
import 'package:deepex/screens/data_screen.dart';
import 'package:deepex/screens/electricity_screen.dart';
import 'package:deepex/screens/gift_card_screen.dart';
import 'package:deepex/screens/home_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../providers/auth_provider.dart';
import '../screens/airtime_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      // If the user is not logged in and not on the login or register page,
      // redirect to the login page
      final isLoggedIn = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';

      if (!isLoggedIn && !isLoggingIn && !isRegistering) {
        return '/login';
      }

      // If the user is logged in and on the login or register page,
      // redirect to the home page
      if (isLoggedIn && (isLoggingIn || isRegistering)) {
        return '/home';
      }

      return null;
    },
    routes: [
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
      GoRoute(
        path: '/gift-card',
        builder: (context, state) => const GiftCardScreen(),
      ),
      GoRoute(
        path: '/airtime',
        builder: (context, state) => const AirtimeScreen(),
      ),
      GoRoute(
        path: '/data',
        builder: (context, state) => const DataScreen(),
      ),
      GoRoute(
        path: '/electricity',
        builder: (context, state) => const ElectricityScreen(),
      ),
    ],
  );
});
