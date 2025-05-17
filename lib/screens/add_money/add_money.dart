import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:share_plus/share_plus.dart'; // lib/screens/add_money/add_money.dart (Updated)

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
    try {
      final String shareText = "Deepex Account Details\n\n"
          "Account Number: $accountNumber\n\n"
          "Bank Name: Deepex Bank\n\n"
          "Please use this account number to send money to my Deepex wallet.";

      Share.share(shareText, subject: 'My Deepex Account Details')
          .catchError((error) {
        // Show fallback UI when sharing fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Sharing not available in this environment. Account number copied instead.'),
            backgroundColor: AppColors.info,
          ),
        );
        // Fall back to just copying to clipboard
        Clipboard.setData(ClipboardData(text: shareText));
      });
    } catch (e) {
      // Fallback for emulators or when sharing isn't available
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Sharing not available. Account details copied to clipboard instead.'),
          backgroundColor: AppColors.info,
        ),
      );
      // Copy to clipboard as fallback
      Clipboard.setData(ClipboardData(text: accountNumber));

      // For debugging - show custom bottom sheet in development
      _showDebugShareSheet();
    }
  }

  // Development only - show simulated share sheet
  void _showDebugShareSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.backgroundDarkSecondary
          : AppColors.backgroundLightSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Share Account Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 16),
              const Text('This is a simulated share sheet for development.'),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildShareOption(Icons.message, 'SMS'),
                  _buildShareOption(Icons.email, 'Email'),
                  _buildShareOption(Icons.copy, 'Copy'),
                  _buildShareOption(Icons.chat_bubble, 'WhatsApp'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShareOption(IconData icon, String label) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
          radius: 25,
          child: Icon(icon, color: isDarkMode ? Colors.white : Colors.black87),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  // Navigate to card top-up screen
  void _navigateToCardTopUp() {
    context.push('/card-topup');
  }

  // Navigate to bank transfer screen
  void _bankTransfer() {
    context.push('/bank-transfer');
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
                ? AppColors.backgroundDarkSecondary
                    .withAlpha(153) // ~0.6 opacity
                : AppColors.backgroundLightSecondary,
            child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: isDarkMode
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                  size: 20,
                ),
                onPressed: () {
                  context.pop();
                }),
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
                  title: 'Via bank transfer',
                  subtitle: 'Instant bank funding',
                  onTap: _bankTransfer,
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

                // Card/Account Option with updated onTap handler
                _buildFundingOptionCard(
                  context: context,
                  icon: Iconsax.card,
                  iconBackgroundColor: AppColors.primary,
                  title: 'Top up with card/account',
                  subtitle: 'Add money from your card/account',
                  onTap: _navigateToCardTopUp,
                  // Updated to navigate to the new screen
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
                ? Colors.grey.withAlpha(41) // ~0.16 opacity
                : Colors.grey.withAlpha(31), // ~0.12 opacity
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
