// lib/widgets/transaction_history_section.dart

import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:deepex/models/transaction_model.dart';
import 'package:flutter/material.dart';
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
    // Determine widget state - loading, empty, or has transactions
    final bool isEmpty = transactions == null || transactions!.isEmpty;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with title and "View all" button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.headingMedium('Recent Transactions'),
                if (!isEmpty)
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
          Spacing.verticalM,

          // Main content area
          if (isLoading)
            _buildLoadingState(isDarkMode)
          else if (isEmpty)
            _buildEmptyState(context, isDarkMode)
          else
            _buildTransactionList(context, isDarkMode),
        ],
      ),
    );
  }

  // Loading state with shimmer effect
  Widget _buildLoadingState(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.backgroundDarkSecondary
            : AppColors.backgroundLightSecondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: List.generate(3, (index) {
          return _buildShimmerItem(isDarkMode);
        }),
      ),
    );
  }

  // Shimmer effect for loading state
  Widget _buildShimmerItem(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDarkMode
                ? Colors.grey.withOpacity(0.1)
                : Colors.grey.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          // Icon placeholder
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isDarkMode
                  ? Colors.grey.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.3),
            ),
          ),
          const SizedBox(width: 12),
          // Text placeholders
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: isDarkMode
                        ? Colors.grey.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.3),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 80,
                  height: 12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: isDarkMode
                        ? Colors.grey.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ),
          // Amount placeholder
          Container(
            width: 70,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: isDarkMode
                  ? Colors.grey.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  // Empty state with illustration and message
  Widget _buildEmptyState(BuildContext context, bool isDarkMode) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.backgroundDarkSecondary
            : AppColors.backgroundLightSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode
              ? Colors.grey.withOpacity(0.1)
              : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated illustration - can be replaced with a Lottie animation
          Container(
            width: screenWidth * 0.4,
            height: screenWidth * 0.4,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.primaryDark.withOpacity(0.1)
                  : AppColors.primaryLightest.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Iconsax.card,
                size: screenWidth * 0.15,
                color: isDarkMode ? AppColors.primaryLight : AppColors.primary,
              ),
            ),
          ),
          Spacing.verticalM,
          AppText.headingMedium(
            'Ready for Your First Move?',
            textAlign: TextAlign.center,
          ),
          Spacing.verticalS,
          AppText.bodyMedium(
            'Complete your first transaction to see it displayed here.',
            textAlign: TextAlign.center,
            color: isDarkMode
                ? AppColors.textDarkSecondary
                : AppColors.textLightSecondary,
          ),
          Spacing.verticalL,
          // Add transaction button for better UX
          SizedBox(
            width: screenWidth * 0.6,
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDarkMode ? AppColors.primaryLight : AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Iconsax.add),
              label: const Text('Add Money'),
            ),
          ),
        ],
      ),
    );
  }

  // Transaction list with items
  Widget _buildTransactionList(BuildContext context, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.backgroundDarkSecondary
            : AppColors.backgroundLightSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode
              ? Colors.grey.withOpacity(0.1)
              : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: transactions!.length > 5 ? 5 : transactions!.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: isDarkMode
              ? Colors.grey.withOpacity(0.1)
              : Colors.grey.withOpacity(0.2),
        ),
        itemBuilder: (context, index) {
          return _buildTransactionItem(
            transactions![index],
            isDarkMode,
            isLast: index ==
                (transactions!.length > 5 ? 4 : transactions!.length - 1),
          );
        },
      ),
    );
  }

  // Individual transaction item
  Widget _buildTransactionItem(
    TransactionModel transaction,
    bool isDarkMode, {
    bool isLast = false,
  }) {
    // Format the amount with currency symbol and comma separators
    final amountFormatter = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    );

    // Format date to "Apr 15, 2025" or "Today" if today
    final dateFormatter = DateFormat('MMM d, yyyy');
    final today = DateTime.now();
    final formattedDate = transaction.date.year == today.year &&
            transaction.date.month == today.month &&
            transaction.date.day == today.day
        ? 'Today'
        : dateFormatter.format(transaction.date);

    // Get appropriate icon and colors based on transaction type and category
    IconData icon;
    Color iconBgColor;

    switch (transaction.category) {
      case TransactionCategory.airtime:
        icon = Iconsax.mobile;
        iconBgColor = isDarkMode ? AppColors.airtimeLight : AppColors.airtime;
        break;
      case TransactionCategory.data:
        icon = Iconsax.wifi;
        iconBgColor = isDarkMode ? AppColors.dataLight : AppColors.data;
        break;
      case TransactionCategory.electricity:
        icon = Iconsax.flash_1;
        iconBgColor =
            isDarkMode ? AppColors.electricityLight : AppColors.electricity;
        break;
      case TransactionCategory.giftCard:
        icon = Iconsax.card;
        iconBgColor = isDarkMode ? AppColors.giftCardLight : AppColors.giftCard;
        break;
      case TransactionCategory.bankTransfer:
        icon = Iconsax.bank;
        iconBgColor = isDarkMode
            ? AppColors.primaryLight.withOpacity(0.8)
            : AppColors.primary.withOpacity(0.8);
        break;
      case TransactionCategory.deposit:
        icon = Iconsax.money_recive;
        iconBgColor = isDarkMode ? AppColors.successLight : AppColors.success;
        break;
      case TransactionCategory.utility:
        icon = Iconsax.building_3;
        iconBgColor = isDarkMode
            ? const Color(0xFFB4A7D6) // Light purple for dark mode
            : const Color(0xFF674EA7); // Medium purple for light mode
        break;
      default:
        icon = Iconsax.wallet;
        iconBgColor = isDarkMode ? AppColors.primaryLight : AppColors.primary;
    }

    // Determine amount color based on transaction type
    final amountColor = transaction.type == TransactionType.credit
        ? (isDarkMode ? AppColors.successLight : AppColors.success)
        : (isDarkMode ? AppColors.errorLight : AppColors.error);

    // Determine status indicator
    Widget statusIndicator = const SizedBox();
    if (transaction.status == TransactionStatus.pending) {
      statusIndicator = Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.warningDark.withOpacity(0.1)
              : AppColors.warningLight,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'Pending',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? AppColors.warningLight : AppColors.warning,
          ),
        ),
      );
    } else if (transaction.status == TransactionStatus.failed) {
      statusIndicator = Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.errorDark.withOpacity(0.1)
              : AppColors.errorLight,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'Failed',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? AppColors.errorLight : AppColors.error,
          ),
        ),
      );
    }

    return InkWell(
      onTap: () {
        // Handle transaction tap - navigate to details
      },
      borderRadius: isLast
          ? const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Transaction icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconBgColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Transaction details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          transaction.description,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode
                                ? AppColors.textDarkPrimary
                                : AppColors.textLightPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      statusIndicator,
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode
                          ? AppColors.textDarkSecondary
                          : AppColors.textLightSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Transaction amount
            Text(
              '${transaction.type == TransactionType.credit ? '+' : '-'} ${amountFormatter.format(transaction.amount)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: amountColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
