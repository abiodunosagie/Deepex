// lib/routing/app_router.dart (Updated)
import 'package:deepex/features/auth/forgot_password/forgot_password.dart';
import 'package:deepex/features/auth/login/login_screen.dart';
import 'package:deepex/features/auth/otp/otp_verification_screen.dart';
import 'package:deepex/features/auth/signup/register_screen.dart';
import 'package:deepex/features/onboarding/onboarding_screen.dart';
import 'package:deepex/navigation/main_scaffold.dart';
import 'package:deepex/screens/add_money/add_money.dart';
import 'package:deepex/screens/add_money/bank_transfer_screen.dart';
import 'package:deepex/screens/add_money/card_topup_screen.dart';
import 'package:deepex/screens/gift_card/gift_card_redemption_screen.dart';
import 'package:deepex/screens/home_screen.dart';
import 'package:deepex/screens/profile_screen.dart';
import 'package:deepex/screens/support_screen.dart';
import 'package:deepex/screens/transactions_screen.dart';
import 'package:deepex/screens/utilities/transaction_failure_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/data_plan_model.dart';
import '../screens/airtime/airtime_purchase_screen.dart';
import '../screens/data/data_purchase_screen.dart';
import '../screens/data/data_success_screen.dart';
import '../screens/gift_card/country_giftcards_screen.dart';
import '../screens/gift_card/giftcard_confirmation_screen.dart';
import '../screens/gift_card/giftcard_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/security/security_settings.dart';
import '../screens/utilities/electricity_screen.dart';
import '../screens/utilities/electricity_success_screen.dart';
import '../screens/utilities/tv_cable_screen.dart';
import '../screens/utilities/tv_success_screen.dart';
import '../screens/utilities/utilities_screen.dart';

// Route names for easy reference
class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String transactions = '/transactions';
  static const String support = '/support';
  static const String addMoney = '/add-money';
  static const String bankTransfer = '/bank-transfer';
  static const String cardTopup = '/card-topup';
  static const String giftCards = '/gift-cards';
  static const String giftCardCountries = '/gift-cards/countries';
  static const String giftCardList = '/gift-cards/list';
  static const String giftCardRedeem = '/gift-cards/redeem';
  static const String giftCardRedeemCard = '/gift-cards/redeem-card';
  static const String giftCardConfirmation = '/gift-cards/confirmation';
  static const String giftCardSuccess = '/gift-cards/success';
  static const String airtime = '/airtime';
  static const String data = '/data';
  static const String dataSuccess = '/data/success';
  static const String electricity = '/utilities/electricity';
  static const String electricitySuccess = '/utilities/electricity/success';
  static const String electricityFailure = '/utilities/electricity/failure';
  static const String utilities = '/utilities';
  static const String securitySettings = '/security-settings';
  static const String notifications = '/notifications';

  // Make the route paths consistent - changing from tvSubscription to tv for consistency
  static const String tvSubscription = '/utilities/tv';
  static const String tvSuccess = '/utilities/tv/success';
  static const String tvFailure = '/utilities/tv/failure';

  static const String offers = '/offers';
  static const String transactionDetails = '/transactions/details';
}

// Helper to determine if a route is among the bottom navigation tabs
int _getSelectedIndex(String location) {
  if (location.startsWith('/home')) {
    return 0;
  } else if (location.startsWith('/transactions')) {
    return 1;
  } else if (location.startsWith('/profile')) {
    return 2;
  } else if (location.startsWith('/support')) {
    return 3;
  }
  return 0; // Default to home tab
}

// Shell route branch
ShellRoute _shellRoute() {
  return ShellRoute(
    builder: (context, state, child) {
      return MainScaffold(
        child: child,
        currentIndex: _getSelectedIndex(state.uri.toString()),
      );
    },
    routes: [
      GoRoute(
        name: 'home',
        path: AppRoutes.home,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: HomeScreen(),
        ),
      ),
      GoRoute(
        name: 'transactions',
        path: AppRoutes.transactions,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: TransactionsScreen(),
        ),
      ),
      GoRoute(
        name: 'profile',
        path: AppRoutes.profile,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ProfileScreen(),
        ),
      ),
      GoRoute(
        name: 'support',
        path: AppRoutes.support,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SupportScreen(),
        ),
      ),
    ],
  );
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

      // Main app shell with bottom navigation
      _shellRoute(),

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

      // Gift Card Screens
      GoRoute(
        name: 'gift-cards',
        path: AppRoutes.giftCards,
        builder: (context, state) => const GiftCardsScreen(),
      ),
      GoRoute(
        name: 'gift-card-countries',
        path: AppRoutes.giftCardCountries,
        builder: (context, state) {
          // Country data would be passed here
          final country = state.extra as Map<String, dynamic>;
          return CountryGiftCardsScreen(country: country);
        },
      ),
      GoRoute(
          name: 'gift-card-redeem',
          path: AppRoutes.giftCardRedeem,
          builder: (context, state) {
            final redemptionData = state.extra as Map<String, dynamic>?;
            return GiftCardRedemptionScreen(redemptionData: redemptionData);
          }),
      GoRoute(
        name: 'gift-card-redeem-card',
        path: AppRoutes.giftCardRedeemCard,
        builder: (context, state) {
          // Get redemption data from state.extra
          final redemptionData = state.extra as Map<String, dynamic>;
          return GiftCardRedemptionScreen(redemptionData: redemptionData);
        },
      ),
      GoRoute(
        name: 'gift-card-confirmation',
        path: AppRoutes.giftCardConfirmation,
        builder: (context, state) {
          // Get redemption data from state.extra
          final redemptionData = state.extra as Map<String, dynamic>;
          return GiftCardConfirmationScreen(redemptionData: redemptionData);
        },
      ),

      // Utilities screens
      GoRoute(
        name: 'utilities',
        path: AppRoutes.utilities,
        builder: (context, state) => const UtilitiesScreen(),
      ),

      // TV Subscription screens - match name and path exactly
      GoRoute(
        name: 'tv',
        path: AppRoutes.tvSubscription,
        builder: (context, state) => const TvSubscriptionScreen(),
      ),
      GoRoute(
        name: 'tv-success',
        path: AppRoutes.tvSuccess,
        builder: (context, state) {
          try {
            final Map<String, dynamic> data =
                state.extra as Map<String, dynamic>? ?? {};

            return TvSubscriptionSuccessScreen(
              provider: data['provider'] ?? 'Unknown Provider',
              smartCardNumber: data['smartCardNumber'] ?? '0000000000',
              packageName: data['packageName'] ?? 'Unknown Package',
              amount: data['amount'] ?? 0.0,
              validityDays: data['validityDays'] ?? 30,
            );
          } catch (e) {
            debugPrint('Error creating TvSubscriptionSuccessScreen: $e');
            // Fallback for debugging
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: Center(child: Text('Error: $e')),
            );
          }
        },
      ),
      GoRoute(
        name: 'tv-failure',
        path: AppRoutes.tvFailure,
        builder: (context, state) {
          final Map<String, dynamic> data =
              state.extra as Map<String, dynamic>? ?? {};

          return TransactionFailureScreen(
            transactionType: 'TV subscription',
            errorMessage: data['errorMessage'] ??
                'An error occurred while processing your TV subscription',
            transactionId: data['transactionId'] ??
                DateTime.now().millisecondsSinceEpoch.toString().substring(5),
            returnPath: data['returnPath'] ?? AppRoutes.tvSubscription,
          );
        },
      ),

      // Electricity screens
      GoRoute(
        name: 'electricity',
        path: AppRoutes.electricity,
        builder: (context, state) => const ElectricityScreen(),
      ),
      GoRoute(
        name: 'electricity-success',
        path: AppRoutes.electricitySuccess,
        builder: (context, state) {
          final Map<String, dynamic> data =
              state.extra as Map<String, dynamic>? ?? {};

          return ElectricitySuccessScreen(
            provider: data['provider'] ?? 'Unknown Provider',
            meterNumber: data['meterNumber'] ?? '0000000000',
            meterType: data['meterType'] ?? 'Prepaid',
            amount: data['amount'] ?? 0.0,
            token: data['token'],
          );
        },
      ),
      GoRoute(
        name: 'electricity-failure',
        path: AppRoutes.electricityFailure,
        builder: (context, state) {
          final Map<String, dynamic> data =
              state.extra as Map<String, dynamic>? ?? {};

          return TransactionFailureScreen(
            transactionType: 'electricity',
            errorMessage: data['errorMessage'] ??
                'An error occurred while processing your electricity payment',
            transactionId: data['transactionId'] ??
                DateTime.now().millisecondsSinceEpoch.toString().substring(5),
            returnPath: data['returnPath'] ?? AppRoutes.electricity,
          );
        },
      ),

      // Airtime and Data screens
      GoRoute(
        name: 'airtime',
        path: AppRoutes.airtime,
        builder: (context, state) => const AirtimePurchaseScreen(),
      ),
      GoRoute(
        name: 'data',
        path: AppRoutes.data,
        builder: (context, state) => const DataPurchaseScreen(),
      ),
      GoRoute(
        name: 'data-success',
        path: AppRoutes.dataSuccess,
        builder: (context, state) {
          // Get params from extra
          final Map<String, dynamic> data =
              state.extra as Map<String, dynamic>? ?? {};

          return DataSuccessScreen(
            provider: data['provider'] ?? 'unknown',
            plan: data['plan'] as DataPlanModel? ??
                DataPlanModel(
                  id: 'unknown',
                  provider: 'unknown',
                  name: 'Unknown',
                  description: 'Unknown plan',
                  price: 0,
                  duration: 'N/A',
                  dataAmount: 'N/A',
                ),
            phoneNumber: data['phoneNumber'] ?? '0000000000',
          );
        },
      ),

      // Other placeholder routes
      GoRoute(
        name: 'offers',
        path: AppRoutes.offers,
        builder: (context, state) =>
            const PlaceholderScreen(title: 'All Offers'),
      ),
      GoRoute(
        name: 'transaction-details',
        path: AppRoutes.transactionDetails,
        builder: (context, state) {
          final Map<String, dynamic> data =
              state.extra as Map<String, dynamic>? ??
                  {
                    'transactionId': 'Unknown',
                  };

          return PlaceholderScreen(
              title: 'Transaction ${data['transactionId']}');
        },
      ),
      GoRoute(
        name: 'security-settings',
        path: '/security-settings',
        builder: (context, state) => const SecuritySettingsScreen(),
      ),
      GoRoute(
        name: 'notifications',
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],

    // Error handling for invalid routes with more debugging info
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
              'Path: ${state.matchedLocation}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (state.error != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Error: ${state.error}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.red),
                ),
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
