// lib/screens/gift_card/gift_card_success_screen.dart
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class GiftCardSuccessScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const GiftCardSuccessScreen({
    super.key,
    required this.data,
  });

  @override
  State<GiftCardSuccessScreen> createState() => _GiftCardSuccessScreenState();
}

class _GiftCardSuccessScreenState extends State<GiftCardSuccessScreen> {
  final currencyFormatter = NumberFormat.currency(locale: 'en_NG', symbol: '₦');
  bool _showCopiedMessage = false;

  @override
  void initState() {
    super.initState();

    // Auto-navigate to home after some time
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        _goToHome();
      }
    });
  }

  void _goToHome() {
    context.go('/home');
  }

  void _copyTransactionId() {
    Clipboard.setData(
            ClipboardData(text: widget.data['transactionId'] as String))
        .then((_) {
      setState(() {
        _showCopiedMessage = true;
      });

      // Hide copied message after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showCopiedMessage = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final amount = widget.data['amount'] as double;
    final cardType = widget.data['cardType'] as String;
    final transactionId = widget.data['transactionId'] as String;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Success animation
                    SizedBox(
                      height: 200,
                      child: Lottie.asset(
                        'assets/animation/success.json',
                        repeat: false,
                        animate: true,
                      ),
                    ),

                    // Success message
                    AppText.displaySmall(
                      'Gift Card Redeemed!',
                      textAlign: TextAlign.center,
                    ),
                    Spacing.verticalM,

                    AppText.bodyLarge(
                      'Your $cardType gift card has been successfully redeemed.',
                      textAlign: TextAlign.center,
                      color: isDarkMode
                          ? AppColors.textDarkSecondary
                          : AppColors.textLightSecondary,
                    ),

                    Spacing.verticalL,

                    // Amount card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppColors.successDark.withOpacity(0.1)
                            : AppColors.successLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          AppText.bodyLarge(
                            'You Received',
                            color: isDarkMode
                                ? AppColors.textDarkSecondary
                                : AppColors.textLightSecondary,
                          ),
                          Spacing.verticalS,
                          AppText.displayLarge(
                            currencyFormatter.format(amount),
                            color: AppColors.success,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),

                    Spacing.verticalL,

                    // Transaction details
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppColors.backgroundDarkSecondary
                            : AppColors.backgroundLightSecondary,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDarkMode
                              ? Colors.grey.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.titleMedium('Transaction Details'),
                          Spacing.verticalM,

                          // Transaction ID row
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? AppColors.primaryLight.withOpacity(0.1)
                                      : AppColors.primaryLightest,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Iconsax.receipt_item,
                                  color: isDarkMode
                                      ? AppColors.primaryLight
                                      : AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              Spacing.horizontalM,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Transaction ID',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDarkMode
                                            ? AppColors.textDarkSecondary
                                            : AppColors.textLightSecondary,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          transactionId,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: isDarkMode
                                                ? AppColors.textDarkPrimary
                                                : AppColors.textLightPrimary,
                                          ),
                                        ),
                                        Spacing.horizontalS,
                                        GestureDetector(
                                          onTap: _copyTransactionId,
                                          child: Icon(
                                            _showCopiedMessage
                                                ? Iconsax.tick_circle
                                                : Iconsax.copy,
                                            size: 16,
                                            color: _showCopiedMessage
                                                ? AppColors.success
                                                : isDarkMode
                                                    ? AppColors.primaryLight
                                                    : AppColors.primary,
                                          ),
                                        ),
                                        if (_showCopiedMessage) ...[
                                          Spacing.horizontalXS,
                                          const Text(
                                            'Copied!',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.success,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Spacing.verticalM,

                          // Date and time row
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? AppColors.primaryLight.withOpacity(0.1)
                                      : AppColors.primaryLightest,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Iconsax.calendar,
                                  color: isDarkMode
                                      ? AppColors.primaryLight
                                      : AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              Spacing.horizontalM,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Date & Time',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDarkMode
                                            ? AppColors.textDarkSecondary
                                            : AppColors.textLightSecondary,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('MMM dd, yyyy • hh:mm a')
                                          .format(DateTime.now()),
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
                              ),
                            ],
                          ),

                          Spacing.verticalM,

                          // Status row
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? AppColors.successDark.withOpacity(0.1)
                                      : AppColors.successLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Iconsax.tick_circle,
                                  color: AppColors.success,
                                  size: 20,
                                ),
                              ),
                              Spacing.horizontalM,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Status',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDarkMode
                                            ? AppColors.textDarkSecondary
                                            : AppColors.textLightSecondary,
                                      ),
                                    ),
                                    const Text(
                                      'Successful',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.success,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom buttons
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.backgroundDarkElevated
                    : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // View transactions button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.go('/transactions'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: isDarkMode
                              ? AppColors.primaryLight
                              : AppColors.primary,
                        ),
                      ),
                      child: const Text('View Transactions'),
                    ),
                  ),
                  Spacing.horizontalM,
                  // Home button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _goToHome,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode
                            ? AppColors.primaryLight
                            : AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Go to Home'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
