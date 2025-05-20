// lib/widgets/transaction_history.dart (Updated)
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:deepex/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class TransactionHistorySection extends StatelessWidget {
  final List<TransactionModel>? transactions;
  final VoidCallback? onViewAll;
  final bool isLoading;

  const TransactionHistorySection({
    super.key,
    this.transactions,
    this.onViewAll,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final formatter = NumberFormat.currency(locale: 'en_NG', symbol: '₦');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.backgroundDarkSecondary : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDarkMode ? 51 : 13),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 24,
              bottom: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.headingMedium('Transaction History'),
                TextButton(
                  onPressed: onViewAll,
                  child: Text(
                    'View all',
                    style: TextStyle(
                      color: isDarkMode
                          ? AppColors.secondaryLight
                          : AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            _buildLoadingState()
          else if (transactions == null || transactions!.isEmpty)
            _buildEmptyState(context, isDarkMode)
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 30,
              ),
              itemCount: transactions!.length > 4 ? 4 : transactions!.length,
              separatorBuilder: (context, index) => Divider(
                height: 20,
                thickness: 1,
                color: isDarkMode
                    ? Colors.grey.withAlpha(51)
                    : Colors.grey.withAlpha(26),
              ),
              itemBuilder: (context, index) {
                final transaction = transactions![index];
                return _buildTransactionTile(
                  context,
                  transaction,
                  isDarkMode,
                  formatter,
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(
    BuildContext context,
    TransactionModel transaction,
    bool isDarkMode,
    NumberFormat formatter,
  ) {
    return InkWell(
      onTap: () {
        // Navigate to transaction details
        context.push('/transactions/details',
            extra: {'transactionId': transaction.id});
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Transaction category icon
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: _getCategoryColor(transaction.category, isDarkMode)
                    .withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getCategoryIcon(transaction.category),
                color: _getCategoryColor(transaction.category, isDarkMode),
                size: 22,
              ),
            ),
            Spacing.horizontalM,
            // Transaction details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isDarkMode
                          ? AppColors.textDarkPrimary
                          : AppColors.textLightPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _getStatusColor(transaction.status),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        transaction.status.toString().split('.').last,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode
                              ? AppColors.textDarkSecondary
                              : AppColors.textLightSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat.jm().format(transaction.date),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode
                              ? AppColors.textDarkSecondary
                              : AppColors.textLightSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Transaction amount
            Text(
              formatter.format(transaction.amount),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: transaction.type == TransactionType.credit
                    ? AppColors.success
                    : isDarkMode
                        ? AppColors.textDarkPrimary
                        : AppColors.textLightPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.receipt_search,
            size: 60,
            color: isDarkMode
                ? Colors.grey.withAlpha(128)
                : Colors.grey.withAlpha(77),
          ),
          Spacing.verticalM,
          Text(
            'No transactions yet',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDarkMode
                  ? AppColors.textDarkPrimary
                  : AppColors.textLightPrimary,
            ),
          ),
          Spacing.verticalS,
          Text(
            'When you make a transaction, it will show up here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode
                  ? AppColors.textDarkSecondary
                  : AppColors.textLightSecondary,
            ),
          ),
          Spacing.verticalL,
          ElevatedButton(
            onPressed: () {
              // Navigate to a transaction creation flow
              context.push('/utilities');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDarkMode ? AppColors.primaryLight : AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Make a Transaction'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        children: List.generate(
          3,
          (index) => Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Row(
              children: [
                const Skeleton(width: 45, height: 45, radius: 12),
                Spacing.horizontalM,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Skeleton(width: 120, height: 16, radius: 4),
                      const SizedBox(height: 8),
                      const Skeleton(width: 80, height: 12, radius: 4),
                    ],
                  ),
                ),
                const Skeleton(width: 60, height: 16, radius: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(TransactionCategory category, bool isDarkMode) {
    switch (category) {
      case TransactionCategory.airtime:
        return isDarkMode ? AppColors.airtimeLight : AppColors.airtime;
      case TransactionCategory.data:
        return isDarkMode ? AppColors.dataLight : AppColors.data;
      case TransactionCategory.utility:
        return isDarkMode ? AppColors.secondaryLight : AppColors.secondary;
      case TransactionCategory.electricity:
        return isDarkMode ? AppColors.electricityLight : AppColors.electricity;
      case TransactionCategory.bankTransfer:
        return isDarkMode ? AppColors.primaryLight : AppColors.primary;
      case TransactionCategory.giftCard:
        return isDarkMode ? AppColors.giftCardLight : AppColors.giftCard;
      case TransactionCategory.deposit:
        return isDarkMode
            ? const Color(0xFF66BB6A) // Light green for dark mode
            : const Color(0xFF43A047); // Green for light mode
    }
  }

  IconData _getCategoryIcon(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.airtime:
        return Iconsax.mobile;
      case TransactionCategory.data:
        return Iconsax.wifi;
      case TransactionCategory.utility:
        return Iconsax.building;
      case TransactionCategory.electricity:
        return Iconsax.electricity;
      case TransactionCategory.bankTransfer:
        return Iconsax.bank;
      case TransactionCategory.giftCard:
        return Iconsax.card;
      case TransactionCategory.deposit:
        return Iconsax.wallet_add; // Wallet with plus sign icon
    }
  }

  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return AppColors.success;
      case TransactionStatus.pending:
        return AppColors.warning;
      case TransactionStatus.failed:
        return AppColors.error;
    }
  }
}

// Skeleton loading widget
class Skeleton extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const Skeleton({
    super.key,
    required this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color:
            isDarkMode ? Colors.grey.withAlpha(51) : Colors.grey.withAlpha(26),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
