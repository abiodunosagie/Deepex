// lib/screens/utilities/tv/tv_success_screen.dart
import 'package:deepex/components/button_base.dart';
import 'package:deepex/components/primary_button.dart';
import 'package:deepex/components/text_app_button.dart';
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class TvSubscriptionSuccessScreen extends StatefulWidget {
  final String provider;
  final String smartCardNumber;
  final String packageName;
  final double amount;
  final int validityDays;

  const TvSubscriptionSuccessScreen({
    super.key,
    required this.provider,
    required this.smartCardNumber,
    required this.packageName,
    required this.amount,
    required this.validityDays,
  });

  @override
  State<TvSubscriptionSuccessScreen> createState() =>
      _TvSubscriptionSuccessScreenState();
}

class _TvSubscriptionSuccessScreenState
    extends State<TvSubscriptionSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
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
    final formatter = NumberFormat.currency(locale: 'en_NG', symbol: '₦');

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
                      // Success animation
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? const Color(0xFF5C6BC0).withOpacity(0.15)
                                : const Color(0xFF7986CB).withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Color(0xFF5C6BC0),
                            size: 60,
                          ),
                        ),
                      ),

                      Spacing.verticalXL,

                      // Success message
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            AppText.displaySmall(
                              'Subscription Successful!',
                              textAlign: TextAlign.center,
                              color: isDarkMode
                                  ? AppColors.textDarkPrimary
                                  : AppColors.textLightPrimary,
                            ),
                            Spacing.verticalM,
                            AppText.bodyLarge(
                              'Your ${widget.provider} subscription has been renewed successfully',
                              textAlign: TextAlign.center,
                              color: isDarkMode
                                  ? AppColors.textDarkSecondary
                                  : AppColors.textLightSecondary,
                            ),
                          ],
                        ),
                      ),

                      Spacing.verticalXL,

                      // Transaction details card
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildTransactionDetailsCard(
                          context,
                          isDarkMode,
                          formatter,
                        ),
                      ),

                      Spacing.verticalL,

                      // Validity info card
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildValidityInfoCard(context, isDarkMode),
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
                    text: 'Go to Dashboard',
                    onPressed: () => context.go('/home'),
                    size: ButtonSize.large,
                    backgroundColor:
                        isDarkMode ? AppColors.primaryLight : AppColors.primary,
                  ),
                  Spacing.verticalM,
                  TextAppButton(
                    text: 'Make Another Subscription',
                    onPressed: () => context.go('/utilities/tv'),
                    textColor: isDarkMode
                        ? AppColors.secondaryLight
                        : AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build transaction details card
  Widget _buildTransactionDetailsCard(
    BuildContext context,
    bool isDarkMode,
    NumberFormat formatter,
  ) {
    return Container(
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
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          AppText.titleMedium(
            'Transaction Details',
            color: isDarkMode
                ? AppColors.textDarkPrimary
                : AppColors.textLightPrimary,
          ),

          Spacing.verticalM,

          // Transaction ID
          _buildDetailRow(
            context,
            'Transaction ID',
            '#${_generateTransactionId()}',
            isDarkMode,
            showCopy: true,
          ),

          _buildDivider(isDarkMode),

          // Provider
          _buildDetailRow(
            context,
            'Provider',
            widget.provider,
            isDarkMode,
          ),

          _buildDivider(isDarkMode),

          // Smart Card Number
          _buildDetailRow(
            context,
            'Smart Card Number',
            widget.smartCardNumber,
            isDarkMode,
          ),

          _buildDivider(isDarkMode),

          // Package
          _buildDetailRow(
            context,
            'Package',
            widget.packageName,
            isDarkMode,
          ),

          _buildDivider(isDarkMode),

          // Amount
          _buildDetailRow(
            context,
            'Amount',
            formatter.format(widget.amount),
            isDarkMode,
            valueColor: isDarkMode
                ? AppColors.textDarkPrimary
                : AppColors.textLightPrimary,
            valueFontWeight: FontWeight.bold,
          ),

          _buildDivider(isDarkMode),

          // Date & Time
          _buildDetailRow(
            context,
            'Date & Time',
            _getCurrentDateTime(),
            isDarkMode,
          ),
        ],
      ),
    );
  }

  // Build validity info card
  Widget _buildValidityInfoCard(BuildContext context, bool isDarkMode) {
    // Calculate expiry date
    final now = DateTime.now();
    final expiryDate = now.add(Duration(days: widget.validityDays));

    // Format dates
    final dateFormatter = DateFormat('MMM dd, yyyy');
    final formattedStartDate = dateFormatter.format(now);
    final formattedExpiryDate = dateFormatter.format(expiryDate);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF5C6BC0).withOpacity(0.1)
            : const Color(0xFF7986CB).withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode
              ? const Color(0xFF7986CB).withOpacity(0.3)
              : const Color(0xFF5C6BC0).withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Iconsax.calendar,
                color: isDarkMode
                    ? const Color(0xFF7986CB)
                    : const Color(0xFF5C6BC0),
                size: 24,
              ),
              Spacing.horizontalS,
              Text(
                'Subscription Validity',
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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start Date',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode
                            ? AppColors.textDarkSecondary
                            : AppColors.textLightSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedStartDate,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode
                            ? AppColors.textDarkPrimary
                            : AppColors.textLightPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 40,
                width: 1,
                color: isDarkMode
                    ? Colors.grey.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.3),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Expiry Date',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode
                            ? AppColors.textDarkSecondary
                            : AppColors.textLightSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedExpiryDate,
                      style: TextStyle(
                        fontSize: 16,
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.successDark.withOpacity(0.1)
                  : AppColors.successLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Iconsax.timer_1,
                  size: 16,
                  color: AppColors.success,
                ),
                Spacing.horizontalS,
                Expanded(
                  child: Text(
                    'Your subscription is active and valid for ${widget.validityDays} days',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.success,
                      fontWeight: FontWeight.w500,
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

  // Build divider
  Widget _buildDivider(bool isDarkMode) {
    return Divider(
      height: 20,
      thickness: 1,
      color: isDarkMode
          ? Colors.grey.withOpacity(0.16)
          : Colors.grey.withOpacity(0.12),
    );
  }

  // Build detail row
  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    bool isDarkMode, {
    bool showCopy = false,
    Color? valueColor,
    FontWeight? valueFontWeight,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode
                  ? AppColors.textDarkSecondary
                  : AppColors.textLightSecondary,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: valueFontWeight ?? FontWeight.normal,
                  color: valueColor ??
                      (isDarkMode
                          ? AppColors.textDarkPrimary
                          : AppColors.textLightPrimary),
                ),
              ),
              if (showCopy) ...[
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value)).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Copied to clipboard'),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    });
                  },
                  child: Icon(
                    Iconsax.copy,
                    size: 16,
                    color:
                        isDarkMode ? AppColors.primaryLight : AppColors.primary,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // Generate a random transaction ID
  String _generateTransactionId() {
    // In a real app, this would come from the backend
    return '${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
  }

  // Get formatted current date and time
  String _getCurrentDateTime() {
    final now = DateTime.now();

    // Format: May 18, 2025 - 14:30
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');

    return '${months[now.month - 1]} ${now.day}, ${now.year} - $hour:$minute';
  }
}
