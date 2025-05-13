// lib/features/onboarding/widgets/onboarding_page.dart (updated for dark/light mode assets)
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/models/Onboarding_item_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingItem item;
  final AnimationController animationController;
  final bool isDarkMode;

  const OnboardingPage({
    super.key,
    required this.item,
    required this.animationController,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine which animation/image path to use based on dark mode
    final assetPath = isDarkMode && item.darkModeLottieAnimationPath != null
        ? item.darkModeLottieAnimationPath!
        : item.lottieAnimationPath;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lottie Animation or Image with dark/light mode support
          item.isLottie
              ? Lottie.asset(
                  assetPath,
                  height: MediaQuery.of(context).size.height * 0.3,
                  controller: animationController,
                  fit: BoxFit.contain,
                )
              : Image.asset(
                  assetPath,
                  height: MediaQuery.of(context).size.height * 0.25,
                  fit: BoxFit.contain,
                ),
          const SizedBox(height: 40),

          // Title
          Text(
            item.title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDarkMode
                  ? AppColors.textDarkPrimary
                  : AppColors.textLightPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            item.description,
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode
                  ? AppColors.textDarkSecondary
                  : AppColors.textLightSecondary,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
