// lib/widgets/onboarding/onboarding_buttons.dart
import 'package:deepex/components/button_base.dart';
import 'package:deepex/components/primary_button.dart';
import 'package:deepex/components/secondary_button.dart';
import 'package:flutter/material.dart';

class OnboardingButtons extends StatelessWidget {
  final VoidCallback onCreateAccount;
  final VoidCallback onLogin;

  const OnboardingButtons({
    super.key,
    required this.onCreateAccount,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PrimaryButton(
            size: ButtonSize.large,
            text: 'Open new account',
            onPressed: onCreateAccount,
          ),
          const SizedBox(height: 10),
          SecondaryButton(
            size: ButtonSize.large,
            text: 'I have an account',
            onPressed: onLogin,
          ),
        ],
      ),
    );
  }
}
