// lib/features/onboarding/onboarding_screen.dart
import 'package:deepex/components/text_app_button.dart';
import 'package:deepex/features/onboarding/widgets/dot_indicator_row.dart';
import 'package:deepex/features/onboarding/widgets/onboarding_page.dart';
import 'package:deepex/models/Onboarding_item_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/onboarding_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  int _currentPage = 0;

  final List<OnboardingItem> _onboardingItems = [
    OnboardingItem(
      title: 'Welcome to Deepex',
      description:
          'Your platform for wallet management, bill payments and gift card redemptions.',
      isLottie: false,
      lottieAnimationPath: 'assets/logo/deepex logo-dark.png',
    ),
    OnboardingItem(
      title: 'Pay Bills Without The Hassle',
      description:
          'Settle utility bills, buy airtime, and handle payments, all in one place, anytime.',
      isLottie: true,
      lottieAnimationPath: 'assets/animation/walkingdog.json',
    ),
    OnboardingItem(
      title: 'Turn Gift cards To Cash',
      description:
          'Quick redemptions with transparent rates and immediate processing.',
      lottieAnimationPath: 'assets/animation/creditcard.json',
      isLottie: true,
    ),
    OnboardingItem(
        title: "Your Security Is Our Priority",
        description:
            "Built with bank-level encryption and protection for every transaction.",
        isLottie: true,
        lottieAnimationPath: 'assets/animation/security.json')
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Mark onboarding as completed
  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (mounted) {
      context.go('/login');
    }
  }

  void _navigateToRegister() {
    _completeOnboarding();
    context.go('/register');
  }

  void _navigateToLogin() {
    _completeOnboarding();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextAppButton(
                text: 'Skip',
                onPressed: _completeOnboarding,
              ),
            ),

            // Page view for onboarding content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingItems.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    item: _onboardingItems[index],
                    animationController: _animationController,
                  );
                },
              ),
            ),

            // Indicator dots
            DotIndicatorRow(
              currentPage: _currentPage,
              totalPages: _onboardingItems.length,
            ),
            const SizedBox(height: 20),

            // Navigation buttons
            OnboardingButtons(
              onCreateAccount: _navigateToRegister,
              onLogin: _navigateToLogin,
            ),
          ],
        ),
      ),
    );
  }
}
