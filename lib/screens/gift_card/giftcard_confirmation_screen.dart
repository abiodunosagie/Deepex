// lib/screens/gift_card/gift_card_confirmation_screen.dart
import 'dart:io';

import 'package:deepex/components/primary_button.dart';
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:deepex/utilities/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class GiftCardConfirmationScreen extends StatefulWidget {
  final Map<String, dynamic> redemptionData;

  const GiftCardConfirmationScreen({
    super.key,
    required this.redemptionData,
  });

  @override
  State<GiftCardConfirmationScreen> createState() =>
      _GiftCardConfirmationScreenState();
}

class _GiftCardConfirmationScreenState
    extends State<GiftCardConfirmationScreen> {
  bool _isProcessing = false;
  bool _showCardDetails = false;
  final currencyFormatter = NumberFormat.currency(locale: 'en_NG', symbol: '₦');

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
                ? AppColors.backgroundDarkSecondary.withOpacity(0.6)
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
          'Review Gift Card',
          color: isDarkMode
              ? AppColors.textDarkPrimary
              : AppColors.textLightPrimary,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card image preview
              if (widget.redemptionData['cardImage'] != null) ...[
                AppText.titleMedium('Gift Card Image'),
                Spacing.verticalS,
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(widget.redemptionData['cardImage']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Spacing.verticalL,
              ],

              // Card redemption summary
              _buildSummarySection(isDarkMode),

              Spacing.verticalL,

              // Card details (hidden by default)
              _buildCardDetailsSection(isDarkMode),

              Spacing.verticalL,

              // Processing time notice
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.infoLight.withOpacity(0.1)
                      : AppColors.infoLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.info_circle,
                      color: AppColors.info,
                      size: 24,
                    ),
                    Spacing.horizontalM,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.titleSmall(
                            'Processing Time',
                            color: isDarkMode
                                ? AppColors.textDarkPrimary
                                : AppColors.textLightPrimary,
                          ),
                          Spacing.verticalXS,
                          Text(
                            'Your gift card will be processed within 5-10 minutes after submission.',
                            style: TextStyle(
                              color: isDarkMode
                                  ? AppColors.textDarkSecondary
                                  : AppColors.textLightSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Spacing.verticalXXL,

              // Action buttons
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isProcessing ? null : () => context.pop(),
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
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.primaryLight
                              : AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Spacing.horizontalM,
                  // Confirm button
                  Expanded(
                    child: PrimaryButton(
                      text: 'Confirm & Redeem',
                      onPressed: _isProcessing ? null : _processRedemption,
                      isLoading: _isProcessing,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummarySection(bool isDarkMode) {
    final amountUSD = widget.redemptionData['amountUSD'] as double;
    final amountNGN = widget.redemptionData['amountNGN'] as double;
    final conversionRate = widget.redemptionData['conversionRate'] as double;
    final cardTypeName = widget.redemptionData['cardTypeName'] as String;
    final cardSubtype = widget.redemptionData['cardSubtype'] as String;
    final currencyCode =
        widget.redemptionData['currencyCode'] as String? ?? 'USD';

    return Container(
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
          AppText.titleMedium('Redemption Summary'),
          Spacing.verticalM,

          // Card type row
          _buildInfoRow(
            label: 'Gift Card',
            value: '$cardTypeName (${_capitalize(cardSubtype)})',
            icon: Iconsax.card,
            isDarkMode: isDarkMode,
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),

          // USD amount row
          _buildInfoRow(
            label: 'Card Value',
            value: '${currencyCode}${amountUSD.toStringAsFixed(2)}',
            icon: Iconsax.dollar_circle,
            isDarkMode: isDarkMode,
          ),

          Spacing.verticalS,

          // Conversion rate row
          _buildInfoRow(
            label: 'Conversion Rate',
            value: '₦$conversionRate / ${currencyCode}1',
            icon: Iconsax.convert,
            isDarkMode: isDarkMode,
            valueColor: AppColors.info,
          ),

          Spacing.verticalS,

          // NGN amount row
          _buildInfoRow(
            label: 'You Receive',
            value: currencyFormatter.format(amountNGN),
            icon: Iconsax.money_recive,
            isDarkMode: isDarkMode,
            valueColor: AppColors.success,
            valueFontSize: 18,
            valueFontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildCardDetailsSection(bool isDarkMode) {
    final cardCode = widget.redemptionData['cardCode'] as String;
    final cardPin = widget.redemptionData['cardPin'] as String;
    final notes = widget.redemptionData['notes'] as String;

    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.titleMedium('Card Details'),
              IconButton(
                icon: Icon(
                  _showCardDetails ? Iconsax.eye_slash : Iconsax.eye,
                  color: isDarkMode
                      ? AppColors.textDarkSecondary
                      : AppColors.textLightSecondary,
                ),
                onPressed: () {
                  setState(() {
                    _showCardDetails = !_showCardDetails;
                  });
                },
              ),
            ],
          ),
          Spacing.verticalM,

          // Card code row
          _buildInfoRow(
            label: 'Card Code',
            value: _showCardDetails ? cardCode : '••••••••••••',
            icon: Iconsax.code_1,
            isDarkMode: isDarkMode,
          ),

          if (cardPin.isNotEmpty) ...[
            Spacing.verticalS,
            // Card PIN row
            _buildInfoRow(
              label: 'Card PIN',
              value: _showCardDetails ? cardPin : '••••••',
              icon: Iconsax.password_check,
              isDarkMode: isDarkMode,
            ),
          ],

          if (notes.isNotEmpty) ...[
            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(
                color: Colors.grey.withOpacity(0.2),
              ),
            ),

            // Notes row
            _buildInfoRow(
              label: 'Additional Notes',
              value: notes,
              icon: Iconsax.note_2,
              isDarkMode: isDarkMode,
              isMultiLine: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required IconData icon,
    required bool isDarkMode,
    Color? valueColor,
    double? valueFontSize,
    FontWeight? valueFontWeight,
    bool isMultiLine = false,
  }) {
    return Row(
      crossAxisAlignment:
          isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
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
            icon,
            color: isDarkMode ? AppColors.primaryLight : AppColors.primary,
            size: 20,
          ),
        ),
        Spacing.horizontalM,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode
                      ? AppColors.textDarkSecondary
                      : AppColors.textLightSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: valueFontSize ?? 14,
                  fontWeight: valueFontWeight ?? FontWeight.w500,
                  color: valueColor ??
                      (isDarkMode
                          ? AppColors.textDarkPrimary
                          : AppColors.textLightPrimary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper to capitalize first letter
  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  // Process redemption
  Future<void> _processRedemption() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        // Navigate to success screen
        final data = {
          'amount': widget.redemptionData['amountNGN'],
          'cardType': widget.redemptionData['cardTypeName'],
          'transactionId':
              'GC${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10)}',
        };

        context.go('/gift-cards/success', extra: data);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        SnackBarUtils.showError(context, 'Error processing gift card: $e');
      }
    }
  }
}
