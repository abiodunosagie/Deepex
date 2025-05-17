import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:share_plus/share_plus.dart'; // lib/screens/add_money/bank_transfer_screen.dart

class BankTransferScreen extends StatefulWidget {
  const BankTransferScreen({super.key});

  @override
  State<BankTransferScreen> createState() => _BankTransferScreenState();
}

class _BankTransferScreenState extends State<BankTransferScreen>
    with SingleTickerProviderStateMixin {
  final String _accountNumber = "8063524189";
  final String _accountName = "Adewole Mary";
  final String _bankName = "Deepex";

  // Animation controller for copy feedback
  late AnimationController _copyAnimationController;
  late Animation<double> _copyAnimation;
  bool _showCopySuccess = false;

  @override
  void initState() {
    super.initState();
    _copyAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _copyAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _copyAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _copyAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showCopySuccess = false;
        });
        _copyAnimationController.reset();
      }
    });
  }

  @override
  void dispose() {
    _copyAnimationController.dispose();
    super.dispose();
  }

  void _copyAccountNumber() {
    Clipboard.setData(ClipboardData(text: _accountNumber)).then((_) {
      setState(() {
        _showCopySuccess = true;
      });
      _copyAnimationController.forward();
    });
  }

  void _shareAccountDetails() {
    try {
      final String shareText = "Bank Transfer Details\n\n"
          "Bank Name: $_bankName\n"
          "Account Number: $_accountNumber\n"
          "Account Name: $_accountName\n\n"
          "Please use these details to transfer money to my Deepex account.";

      Share.share(shareText, subject: 'Deepex Account Details')
          .catchError((error) {
        // Show fallback UI when sharing fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Sharing not available. Account details copied to clipboard instead.'),
            backgroundColor: AppColors.info,
          ),
        );
        // Fall back to just copying to clipboard
        Clipboard.setData(ClipboardData(text: shareText));
      });
    } catch (e) {
      // Fallback for when sharing isn't available
      Clipboard.setData(ClipboardData(text: _accountNumber));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to share. Account number copied to clipboard.'),
          backgroundColor: AppColors.info,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDarkMode ? AppColors.textDarkPrimary : AppColors.textLightPrimary;
    final secondaryTextColor =
        isDarkMode ? AppColors.textDarkSecondary : AppColors.textLightSecondary;
    final cardBgColor =
        isDarkMode ? AppColors.backgroundDarkSecondary : Colors.white;
    final stepBgColor = isDarkMode
        ? AppColors.primaryDarker.withAlpha(40)
        : AppColors.primaryLightest;

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
                color: textColor,
                size: 20,
              ),
              onPressed: () => context.pop(),
            ),
          ),
        ),
        title: Text(''),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                AppText.displaySmall(
                  'Bank transfer to Deepex',
                  color: textColor,
                ),
                Spacing.verticalL,

                // Account Details Card
                Container(
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(10),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Account Number Section
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Deepex account number',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _accountNumber,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                AnimatedBuilder(
                                  animation: _copyAnimation,
                                  builder: (context, child) {
                                    return GestureDetector(
                                      onTap: _copyAccountNumber,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: _showCopySuccess
                                              ? AppColors.successLight
                                                  .withAlpha(40)
                                              : AppColors.primary.withAlpha(20),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              _showCopySuccess
                                                  ? Icons.check
                                                  : Icons.copy,
                                              color: _showCopySuccess
                                                  ? AppColors.success
                                                  : AppColors.primary,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              _showCopySuccess
                                                  ? 'Copied'
                                                  : 'Copy',
                                              style: TextStyle(
                                                color: _showCopySuccess
                                                    ? AppColors.success
                                                    : AppColors.primary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const Divider(height: 1),

                      // Bank Section
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bank Name',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Container(
                                  height: 38,
                                  width: 38,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Iconsax.bank,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _bankName,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const Divider(height: 1),

                      // Recipient Section
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Recipient',
                                  style: TextStyle(
                                    color: secondaryTextColor,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _accountName,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Spacer()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Spacing.verticalL,

                // Share Account Button
                ElevatedButton(
                  onPressed: _shareAccountDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    minimumSize: Size(double.infinity, 56),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Share Account Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Iconsax.share, size: 20),
                    ],
                  ),
                ),

                Spacing.verticalXL,

                // Instructions
                AppText.headingMedium(
                  'How to transfer to Deepex',
                  color: textColor,
                ),
                Spacing.verticalM,

                // Steps
                _buildTransferStep(
                  context: context,
                  number: 1,
                  text: 'Copy the Deepex account number above',
                  stepBgColor: stepBgColor,
                  textColor: textColor,
                ),

                _buildTransferStep(
                  context: context,
                  number: 2,
                  text: 'Open the bank app you want to transfer from',
                  stepBgColor: stepBgColor,
                  textColor: textColor,
                ),

                _buildTransferStep(
                  context: context,
                  number: 3,
                  text: 'Paste the details in the bank app',
                  stepBgColor: stepBgColor,
                  textColor: textColor,
                ),

                _buildTransferStep(
                  context: context,
                  number: 4,
                  text: 'Select Deepex and make the transfer',
                  stepBgColor: stepBgColor,
                  textColor: textColor,
                ),

                Spacing.verticalXXL,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransferStep({
    required BuildContext context,
    required int number,
    required String text,
    required Color stepBgColor,
    required Color textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Number
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: stepBgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Step Text
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
