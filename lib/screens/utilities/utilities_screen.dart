// lib/screens/utilities/utilities_screen.dart
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:deepex/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class UtilitiesScreen extends StatelessWidget {
  const UtilitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: isDarkMode
                ? Color.alphaBlend(
                    Colors.white.withAlpha(153),
                    AppColors.backgroundDarkSecondary,
                  )
                : AppColors.backgroundLightSecondary,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDarkMode
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary,
                size: 20,
              ),
              onPressed: () => context.pop(),
            ),
          ),
        ),
        title: AppText.titleLarge(
          'Utilities',
          color: isDarkMode
              ? AppColors.textDarkPrimary
              : AppColors.textLightPrimary,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message and brief guide
              AppText.headingLarge(
                'Pay Your Bills Effortlessly',
                color: isDarkMode
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary,
              ),
              Spacing.verticalS,
              AppText.bodyLarge(
                'Select a utility type to get started with your payment',
                color: isDarkMode
                    ? AppColors.textDarkSecondary
                    : AppColors.textLightSecondary,
              ),
              Spacing.verticalXL,

              // Utility options
              _buildUtilityOption(
                context: context,
                icon: Iconsax.flash_1,
                title: 'Electricity Bill',
                description: 'Pay for prepaid or postpaid meters',
                color: isDarkMode
                    ? AppColors.electricityLight
                    : AppColors.electricity,
                onTap: () => context.push(AppRoutes.electricity),
                isDarkMode: isDarkMode,
              ),

              Spacing.verticalL,

              _buildUtilityOption(
                context: context,
                icon: Iconsax.monitor,
                title: 'TV Subscription',
                description: 'DSTV, GOTV, Startimes & more',
                color: const Color(0xFF5C6BC0),
                darkColor: const Color(0xFF7986CB),
                onTap: () {
                  debugPrint("Navigating to TV subscription screen");
                  context.push(AppRoutes.tvSubscription);
                },
                isDarkMode: isDarkMode,
              ),

              Spacing.verticalXXL,

              // Recent transactions section
              AppText.headingMedium('Recent Utility Payments'),
              Spacing.verticalM,

              // Display recent transactions or empty state
              _buildRecentTransactionsSection(context, isDarkMode),

              Spacing.verticalXL,

              // Help banner
              _buildHelpBanner(isDarkMode, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUtilityOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    Color? darkColor,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    final displayColor = isDarkMode ? (darkColor ?? color) : color;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.backgroundDarkSecondary
              : AppColors.backgroundLightSecondary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color.alphaBlend(
                Colors.black.withAlpha(13),
                Colors.transparent,
              ),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Color.alphaBlend(
              displayColor.withAlpha(51),
              Colors.transparent,
            ),
            width: 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color.alphaBlend(
                  displayColor.withAlpha(25),
                  Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: displayColor,
                size: 28,
              ),
            ),

            Spacing.horizontalM,

            // Service details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode
                          ? AppColors.textDarkPrimary
                          : AppColors.textLightPrimary,
                    ),
                  ),
                  Spacing.verticalXS,
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode
                          ? AppColors.textDarkSecondary
                          : AppColors.textLightSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow icon
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: displayColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactionsSection(
      BuildContext context, bool isDarkMode) {
    // Sample data - in a real app, this would come from a provider or repository
    final hasRecentTransactions = false;

    if (hasRecentTransactions) {
      // Display transactions here when you have them
      return const SizedBox.shrink();
    } else {
      // Empty state
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.backgroundDarkSecondary
              : AppColors.backgroundLightSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Color.alphaBlend(
              Colors.grey.withAlpha(isDarkMode ? 51 : 76),
              Colors.transparent,
            ),
          ),
        ),
        child: Column(
          children: [
            Icon(
              Iconsax.receipt,
              size: 48,
              color: isDarkMode ? AppColors.primaryLight : AppColors.primary,
            ),
            Spacing.verticalM,
            AppText.titleMedium(
              'No Recent Transactions',
              textAlign: TextAlign.center,
            ),
            Spacing.verticalS,
            AppText.bodyMedium(
              'Your recent utility bill payments will appear here',
              textAlign: TextAlign.center,
              color: isDarkMode
                  ? AppColors.textDarkSecondary
                  : AppColors.textLightSecondary,
            ),
          ],
        ),
      );
    }
  }

  Widget _buildHelpBanner(bool isDarkMode, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Color.alphaBlend(
                AppColors.infoLight.withAlpha(25),
                theme.colorScheme.surface,
              )
            : AppColors.infoLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Color.alphaBlend(
                      AppColors.info.withAlpha(51),
                      Colors.transparent,
                    )
                  : Color.alphaBlend(
                      Colors.white.withAlpha(153),
                      Colors.transparent,
                    ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconsax.info_circle,
              color: AppColors.info,
              size: 24,
            ),
          ),
          Spacing.horizontalM,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.titleSmall(
                  'Need Help?',
                  color: isDarkMode
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                ),
                Spacing.verticalXS,
                AppText.bodySmall(
                  'Contact our support team for assistance with your bill payments',
                  color: isDarkMode
                      ? AppColors.textDarkSecondary
                      : AppColors.textLightSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
