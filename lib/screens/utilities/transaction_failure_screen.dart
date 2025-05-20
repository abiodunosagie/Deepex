// lib/screens/utilities/transaction_failure_screen.dart
import 'package:deepex/components/button_base.dart';
import 'package:deepex/components/primary_button.dart';
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';

class TransactionFailureScreen extends StatefulWidget {
  final String transactionType;
  final String errorMessage;
  final String transactionId;
  final String returnPath;

  const TransactionFailureScreen({
    super.key,
    required this.transactionType,
    required this.errorMessage,
    required this.transactionId,
    required this.returnPath,
  });

  @override
  State<TransactionFailureScreen> createState() =>
      _TransactionFailureScreenState();
}

class _TransactionFailureScreenState extends State<TransactionFailureScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Failure animation
                      Lottie.asset(
                        'assets/animation/error.json',
                        width: 180,
                        height: 180,
                        repeat: false,
                        animate: true,
                      ),

                      Spacing.verticalL,

                      // Failure message
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            AppText.displaySmall(
                              'Transaction Failed',
                              textAlign: TextAlign.center,
                              color: isDarkMode
                                  ? AppColors.textDarkPrimary
                                  : AppColors.textLightPrimary,
                            ),
                            Spacing.verticalM,
                            AppText.bodyLarge(
                              'Your ${widget.transactionType} payment could not be completed',
                              textAlign: TextAlign.center,
                              color: isDarkMode
                                  ? AppColors.textDarkSecondary
                                  : AppColors.textLightSecondary,
                            ),
                          ],
                        ),
                      ),

                      Spacing.verticalXL,

                      // Error card
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildErrorDetailsCard(context, isDarkMode),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom buttons
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  PrimaryButton(
                    text: 'Try Again',
                    onPressed: () => context.go(widget.returnPath),
                    size: ButtonSize.large,
                    backgroundColor:
                        isDarkMode ? AppColors.primaryLight : AppColors.primary,
                  ),
                  Spacing.verticalM,
                  OutlinedButton(
                    onPressed: () => context.go('/home'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDarkMode
                          ? AppColors.textDarkPrimary
                          : AppColors.textLightPrimary,
                      side: BorderSide(
                        color: isDarkMode
                            ? Colors.grey.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.5),
                      ),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Back to Home'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorDetailsCard(BuildContext context, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.errorDark.withOpacity(0.1)
            : AppColors.errorLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode
              ? AppColors.errorLight.withOpacity(0.3)
              : AppColors.error.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Iconsax.info_circle,
                color: AppColors.error,
                size: 24,
              ),
              Spacing.horizontalS,
              Text(
                'Error Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                ),
              ),
            ],
          ),
          Spacing.verticalM,
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color:
                  isDarkMode ? AppColors.backgroundDarkSecondary : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDarkMode
                    ? Colors.grey.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
              ),
            ),
            child: Text(
              widget.errorMessage,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? AppColors.errorLight : AppColors.error,
              ),
            ),
          ),
          Spacing.verticalM,
          Row(
            children: [
              Text(
                'Transaction ID:',
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode
                      ? AppColors.textDarkSecondary
                      : AppColors.textLightSecondary,
                ),
              ),
              Spacing.horizontalS,
              Text(
                '#${widget.transactionId}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                ),
              ),
            ],
          ),
          Spacing.verticalL,
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.infoLight.withOpacity(0.1)
                  : AppColors.infoLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Iconsax.message_question,
                  size: 16,
                  color: AppColors.info,
                ),
                Spacing.horizontalS,
                Expanded(
                  child: Text(
                    'If this problem persists, please contact our support team for assistance.',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? AppColors.infoLight : AppColors.info,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
