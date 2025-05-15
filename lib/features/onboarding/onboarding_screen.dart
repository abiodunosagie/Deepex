// Fixed onboarding_screen.dart with working navigation buttons
import 'package:deepex/components/text_app_button.dart';
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/features/onboarding/widgets/onboarding_page.dart';
import 'package:deepex/models/Onboarding_item_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/onboarding_state_provider.dart';
import 'widgets/onboarding_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  int _currentPage = 0;

  // Onboarding items with dark mode assets
  final List<OnboardingItem> _onboardingItems = [
    OnboardingItem(
      title: 'Welcome to Deepex',
      description:
          'Your platform for wallet management, bill payments and gift card redemptions.',
      isLottie: false,
      lottieAnimationPath: 'assets/logo/deepex logo-dark.png',
      // Light mode logo
      darkModeLottieAnimationPath:
          'assets/logo/deepex logo-light.png', // Dark mode logo
    ),
    OnboardingItem(
      title: 'Pay Bills Without The Hassle',
      description:
          'Settle utility bills, buy airtime, and handle payments, all in one place, anytime.',
      isLottie: true,
      lottieAnimationPath: 'assets/animation/walkingdog.json',
      // Example light animation
      darkModeLottieAnimationPath:
          'assets/animation/paybillsdark.json', // Example dark animation
    ),
    OnboardingItem(
      title: 'Turn Gift cards To Cash',
      description:
          'Quick redemptions with transparent rates and immediate processing.',
      isLottie: true,
      lottieAnimationPath: 'assets/animation/giftcard.json',
      // Example light animation
      darkModeLottieAnimationPath:
          'assets/animation/cashdark.json', // Example dark animation
    ),
    OnboardingItem(
      title: "Your Security Is Our Priority",
      description:
          "Built with bank-level encryption and protection for every transaction.",
      isLottie: true,
      lottieAnimationPath: 'assets/animation/security.json',
      // Example light animation
      darkModeLottieAnimationPath:
          'assets/animation/securitydark.json', // Example dark animation
    ),
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

  // Skip to the last page of onboarding
  void _skipToLastPage() {
    // Determine the index of the last page
    final lastPageIndex = _onboardingItems.length - 1;

    // Animate to the last page
    _pageController.animateToPage(
      lastPageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // This function handles navigation to the register screen
  void _navigateToRegister() {
    // Add debug print to trace execution
    debugPrint('Navigating to register screen');

    // First mark onboarding as completed
    ref.read(onboardingProvider.notifier).setOnboardingCompleted();

    // Use Future.micro task to ensure navigation happens after the current build cycle
    Future.microtask(() {
      // Check if context is still valid before navigating
      if (mounted) {
        GoRouter.of(context).go('/register');
      }
    });
  }

  // This function handles navigation to the login screen
  void _navigateToLogin() {
    // Add debug print to trace execution
    debugPrint('Navigating to login screen');

    // First mark onboarding as completed
    ref.read(onboardingProvider.notifier).setOnboardingCompleted();

    // Use Future.microtask to ensure navigation happens after the current build cycle
    Future.microtask(() {
      // Check if context is still valid before navigating
      if (mounted) {
        GoRouter.of(context).go('/login');
      }
    });
  }

  // Build dot indicators directly in this file
  Widget _buildDotIndicators() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final activeColor =
        isDarkMode ? AppColors.secondaryLight : AppColors.primary;
    final inactiveColor =
        isDarkMode ? AppColors.backgroundDarkTertiary : Colors.grey[300];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _onboardingItems.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 8,
          width: _currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextAppButton(
                text: 'Skip',
                textColor:
                    isDarkMode ? AppColors.secondaryLight : AppColors.primary,
                onPressed: _skipToLastPage,
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
                    isDarkMode: isDarkMode,
                  );
                },
              ),
            ),

            // Indicator dots
            _buildDotIndicators(),
            const SizedBox(height: 20),

            // Navigation buttons - pass direct references to navigation methods
            OnboardingButtons(
              onCreateAccount: _navigateToRegister,
              onLogin: _navigateToLogin,
              isDarkMode: isDarkMode,
            ),
          ],
        ),
      ),
    );
  }
}
