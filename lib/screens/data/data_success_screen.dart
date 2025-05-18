// lib/screens/data/data_success_screen.dart
import 'package:deepex/components/primary_button.dart';
import 'package:deepex/components/text_app_button.dart';
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:deepex/models/data_plan_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../components/button_base.dart';

class DataSuccessScreen extends StatefulWidget {
  final String provider;
  final DataPlanModel plan;
  final String phoneNumber;

  const DataSuccessScreen({
    super.key,
    required this.provider,
    required this.plan,
    required this.phoneNumber,
  });

  @override
  State<DataSuccessScreen> createState() => _DataSuccessScreenState();
}

class _DataSuccessScreenState extends State<DataSuccessScreen>
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
                                ? AppColors.successDark.withAlpha(40)
                                : AppColors.successLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: 60,
                          ),
                        ),
                      ),

                      Spacing.verticalXL,

                      // Success message
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: AppText.displaySmall(
                          'Data Purchase Successful!',
                          textAlign: TextAlign.center,
                          color: isDarkMode
                              ? AppColors.textDarkPrimary
                              : AppColors.textLightPrimary,
                        ),
                      ),

                      Spacing.verticalM,

                      // Success description
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: AppText.bodyLarge(
                          'You have successfully purchased ${widget.plan.dataAmount} data for ${_formatPhoneNumber(widget.phoneNumber)}',
                          textAlign: TextAlign.center,
                          color: isDarkMode
                              ? AppColors.textDarkSecondary
                              : AppColors.textLightSecondary,
                        ),
                      ),

                      Spacing.verticalXL,

                      // Transaction details card
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child:
                            _buildTransactionDetailsCard(context, isDarkMode),
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
                    text: 'Buy Another Data Plan',
                    onPressed: () => context.go('/data'),
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
  Widget _buildTransactionDetailsCard(BuildContext context, bool isDarkMode) {
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
              ? Colors.grey.withAlpha(41) // ~0.16 opacity
              : Colors.grey.withAlpha(31), // ~0.12 opacity
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
            _getProviderName(widget.provider),
            isDarkMode,
          ),

          _buildDivider(isDarkMode),

          // Package
          _buildDetailRow(
            context,
            'Package',
            '${widget.plan.dataAmount} - ${widget.plan.duration}',
            isDarkMode,
          ),

          _buildDivider(isDarkMode),

          // Phone Number
          _buildDetailRow(
            context,
            'Phone Number',
            _formatPhoneNumber(widget.phoneNumber),
            isDarkMode,
          ),

          _buildDivider(isDarkMode),

          // Amount
          _buildDetailRow(
            context,
            'Amount',
            '₦${widget.plan.price.toInt()}',
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

  // Build divider
  Widget _buildDivider(bool isDarkMode) {
    return Divider(
      height: 20,
      thickness: 1,
      color: isDarkMode
          ? Colors.grey.withAlpha(41) // ~0.16 opacity
          : Colors.grey.withAlpha(31), // ~0.12 opacity
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

  // Format phone number for display
  String _formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length >= 11) {
      return '${phoneNumber.substring(0, 4)} ${phoneNumber.substring(4, 7)} ${phoneNumber.substring(7)}';
    }
    return phoneNumber;
  }

  // Get provider name from ID
  String _getProviderName(String providerId) {
    switch (providerId.toLowerCase()) {
      case 'mtn':
        return 'MTN';
      case 'airtel':
        return 'Airtel';
      case 'glo':
        return 'Glo';
      case '9mobile':
        return '9Mobile';
      default:
        return 'Unknown';
    }
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
