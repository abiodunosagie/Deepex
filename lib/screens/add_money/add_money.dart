import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final String accountNumber = "8063524189";

  // Method to copy account number to clipboard
  void _copyAccountNumber() {
    Clipboard.setData(ClipboardData(text: accountNumber)).then((_) {
      // Show snack bar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account number copied to clipboard'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  // Method to share account details
  void _shareAccount() {
    // Implementation for sharing account (would use share package)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing account details...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
                ? AppColors.backgroundDarkSecondary.withAlpha(150)
                : AppColors.backgroundLightSecondary,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDarkMode
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(''),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                AppText.displaySmall(
                  'Add money to wallet',
                  color: isDarkMode
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                ),
                Spacing.verticalXL,

                // Bank Details Option
                _buildFundingOption(
                  context: context,
                  icon: Iconsax.bank,
                  iconBackgroundColor: AppColors.primary,
                  title: 'Via bank details',
                  subtitle: 'Instant bank funding',
                  onTap: () {
                    // Handle bank details option
                  },
                  isDarkMode: isDarkMode,
                ),

                Spacing.verticalL,
                _buildDivider(isDarkMode),
                Spacing.verticalL,

                // Account Number Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.labelMedium(
                      'Deepex Account number',
                      color: isDarkMode
                          ? AppColors.textDarkSecondary
                          : AppColors.textLightSecondary,
                    ),
                    Spacing.verticalS,
                    Row(
                      children: [
                        Expanded(
                          child: AppText.headingLarge(
                            accountNumber,
                            color: isDarkMode
                                ? AppColors.textDarkPrimary
                                : AppColors.textLightPrimary,
                          ),
                        ),
                        IconButton(
                          onPressed: _copyAccountNumber,
                          icon: Icon(
                            Iconsax.copy,
                            color: AppColors.primary,
                            size: 22,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ],
                ),

                Spacing.verticalL,

                // Share Account Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _shareAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Iconsax.share),
                    label: const Text(
                      'Share Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                Spacing.verticalXL,

                // OR Divider
                Row(
                  children: [
                    Expanded(child: _buildDivider(isDarkMode)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode
                              ? AppColors.textDarkSecondary
                              : AppColors.textLightSecondary,
                        ),
                      ),
                    ),
                    Expanded(child: _buildDivider(isDarkMode)),
                  ],
                ),

                Spacing.verticalXL,

                // Card/Account Option
                _buildFundingOptionCard(
                  context: context,
                  icon: Iconsax.card,
                  iconBackgroundColor: AppColors.primary,
                  title: 'Top up with card/account',
                  subtitle: 'Add money from your card/account',
                  onTap: () {
                    // Handle card/account option
                  },
                  isDarkMode: isDarkMode,
                ),

                Spacing.verticalXXXL,
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for the funding options
  Widget _buildFundingOption({
    required BuildContext context,
    required IconData icon,
    required Color iconBackgroundColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            // Icon with circular background
            CircleAvatar(
              radius: 32,
              backgroundColor: iconBackgroundColor,
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // Title and subtitle
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
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
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
            // Chevron icon
            Icon(
              Icons.chevron_right,
              color: isDarkMode
                  ? AppColors.textDarkSecondary
                  : AppColors.textLightSecondary,
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for the card-style funding option
  Widget _buildFundingOptionCard({
    required BuildContext context,
    required IconData icon,
    required Color iconBackgroundColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.backgroundDarkSecondary
              : AppColors.backgroundLightSecondary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDarkMode
                ? Colors.grey.withAlpha(40)
                : Colors.grey.withAlpha(30),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon with circular background
            CircleAvatar(
              radius: 32,
              backgroundColor: iconBackgroundColor,
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // Title and subtitle
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
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
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
            // Chevron icon
            Icon(
              Icons.chevron_right,
              color: isDarkMode
                  ? AppColors.textDarkSecondary
                  : AppColors.textLightSecondary,
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for dividers
  Widget _buildDivider(bool isDarkMode) {
    return Divider(
      height: 1,
      thickness: 1,
      color: isDarkMode ? Colors.grey.withAlpha(40) : Colors.grey.withAlpha(30),
    );
  }
}
