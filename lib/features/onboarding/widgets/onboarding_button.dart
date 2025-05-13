// Check if OnboardingButtons is correctly implemented
import 'package:deepex/components/button_base.dart';
import 'package:deepex/components/primary_button.dart';
import 'package:deepex/components/secondary_button.dart';
import 'package:deepex/constants/app_colors.dart';
import 'package:flutter/material.dart';

class OnboardingButtons extends StatelessWidget {
  final VoidCallback onCreateAccount;
  final VoidCallback onLogin;
  final bool isDarkMode;

  const OnboardingButtons({
    super.key,
    required this.onCreateAccount,
    required this.onLogin,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Create account button - using backgroundColor parameter
          PrimaryButton(
            size: ButtonSize.large,
            text: 'Open new account',
            onPressed: onCreateAccount,
            backgroundColor:
                isDarkMode ? AppColors.primaryLight : AppColors.primary,
          ),
          const SizedBox(height: 10),

          // Login button - using backgroundColor and textColor parameters
          SecondaryButton(
            size: ButtonSize.large,
            text: 'I have an account',
            onPressed: onLogin,
            backgroundColor: isDarkMode
                ? AppColors.backgroundDarkTertiary
                : Colors.grey[200],
            textColor: isDarkMode
                ? AppColors.textDarkPrimary
                : AppColors.textLightPrimary,
          ),
        ],
      ),
    );
  }
}
