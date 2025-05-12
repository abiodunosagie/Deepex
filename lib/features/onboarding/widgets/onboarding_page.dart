// lib/widgets/onboarding/onboarding_page.dart
import 'package:deepex/models/Onboarding_item_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingItem item;
  final AnimationController animationController;

  const OnboardingPage({
    super.key,
    required this.item,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lottie Animation or Image
          item.isLottie
              ? Lottie.asset(
                  item.lottieAnimationPath,
                  height: MediaQuery.of(context).size.height * 0.3,
                  controller: animationController,
                  fit: BoxFit.contain,
                )
              : Image.asset(
                  item.lottieAnimationPath,
                  height: MediaQuery.of(context).size.height * 0.25,
                  fit: BoxFit.contain,
                ),
          const SizedBox(height: 40),

          // Title
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            item.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
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
