// lib/screens/gift_card/gift_cards_screen.dart
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class GiftCardsScreen extends StatefulWidget {
  const GiftCardsScreen({super.key});

  @override
  State<GiftCardsScreen> createState() => _GiftCardsScreenState();
}

class _GiftCardsScreenState extends State<GiftCardsScreen> {
  // Sample gift cards with different rates
  final List<Map<String, dynamic>> _supportedGiftCards = [
    {
      'name': 'Amazon',
      'icon': Iconsax.card,
      'color': const Color(0xFFFF9900),
      'physicalRate': 680.0,
      'digitalRate': 650.0,
      'minAmount': 25,
      'maxAmount': 2000,
    },
    {
      'name': 'iTunes',
      'icon': Iconsax.card,
      'color': const Color(0xFFEA4CC0),
      'physicalRate': 640.0,
      'digitalRate': 620.0,
      'minAmount': 10,
      'maxAmount': 500,
    },
    {
      'name': 'Google Play',
      'icon': Iconsax.card,
      'color': const Color(0xFF4CAF50),
      'physicalRate': 630.0,
      'digitalRate': 610.0,
      'minAmount': 10,
      'maxAmount': 500,
    },
    {
      'name': 'Steam',
      'icon': Iconsax.card,
      'color': const Color(0xFF1A2033),
      'physicalRate': 650.0,
      'digitalRate': 630.0,
      'minAmount': 20,
      'maxAmount': 1000,
    },
    {
      'name': 'Xbox',
      'icon': Iconsax.card,
      'color': const Color(0xFF107C10),
      'physicalRate': 620.0,
      'digitalRate': 600.0,
      'minAmount': 15,
      'maxAmount': 500,
    },
    {
      'name': 'PlayStation',
      'icon': Iconsax.card,
      'color': const Color(0xFF003791),
      'physicalRate': 630.0,
      'digitalRate': 610.0,
      'minAmount': 10,
      'maxAmount': 500,
    },
    {
      'name': 'Visa',
      'icon': Iconsax.card,
      'color': const Color(0xFF1A1F71),
      'physicalRate': 690.0,
      'digitalRate': 670.0,
      'minAmount': 25,
      'maxAmount': 5000,
    },
    {
      'name': 'Mastercard',
      'icon': Iconsax.card,
      'color': const Color(0xFFEB001B),
      'physicalRate': 685.0,
      'digitalRate': 665.0,
      'minAmount': 25,
      'maxAmount': 5000,
    },
  ];

  // Recent gift card transactions
  final List<Map<String, dynamic>> _recentTransactions = [
    {
      'id': 'GC1234567890',
      'date': DateTime.now().subtract(const Duration(hours: 3)),
      'cardType': 'Amazon',
      'amount': 50.0,
      'amountReceived': 32500.0,
      'status': 'completed',
    },
    {
      'id': 'GC0987654321',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'cardType': 'iTunes',
      'amount': 25.0,
      'amountReceived': 15500.0,
      'status': 'completed',
    },
    {
      'id': 'GC5432167890',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'cardType': 'Google Play',
      'amount': 20.0,
      'amountReceived': 12200.0,
      'status': 'completed',
    },
  ];

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
          'Gift Cards',
          color: isDarkMode
              ? AppColors.textDarkPrimary
              : AppColors.textLightPrimary,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner
                _buildPromotionBanner(isDarkMode),

                Spacing.verticalXL,

                // Main action buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        context: context,
                        icon: Iconsax.card_add,
                        title: 'Redeem Gift Card',
                        color: isDarkMode
                            ? AppColors.giftCardLight
                            : AppColors.giftCard,
                        onTap: () => context.push('/gift-cards/redeem'),
                        isDarkMode: isDarkMode,
                      ),
                    ),
                    Spacing.horizontalM,
                    Expanded(
                      child: _buildActionButton(
                        context: context,
                        icon: Iconsax.chart,
                        title: 'View Rates',
                        color:
                            isDarkMode ? AppColors.infoLight : AppColors.info,
                        onTap: () => _showRatesBottomSheet(context),
                        isDarkMode: isDarkMode,
                      ),
                    ),
                  ],
                ),

                Spacing.verticalXL,

                // Supported gift cards
                AppText.headingMedium('Supported Gift Cards'),
                Spacing.verticalM,
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _supportedGiftCards.length,
                  itemBuilder: (context, index) {
                    final card = _supportedGiftCards[index];
                    return _buildGiftCardLogo(card, isDarkMode);
                  },
                ),

                Spacing.verticalXL,

                // Recent transactions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.headingMedium('Recent Transactions'),
                    if (_recentTransactions.isNotEmpty)
                      TextButton(
                        onPressed: () => context.push('/transactions'),
                        child: Text(
                          'View All',
                          style: TextStyle(
                            color: isDarkMode
                                ? AppColors.secondaryLight
                                : AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),

                Spacing.verticalM,

                // Show recent transactions or empty state
                _recentTransactions.isNotEmpty
                    ? Column(
                        children: _recentTransactions.map((transaction) {
                          return _buildTransactionItem(transaction, isDarkMode);
                        }).toList(),
                      )
                    : _buildEmptyTransactions(isDarkMode),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/gift-cards/redeem'),
        backgroundColor:
            isDarkMode ? AppColors.primaryLight : AppColors.primary,
        foregroundColor: Colors.white,
        label: const Text('Redeem New Card'),
        icon: const Icon(Iconsax.card_add),
      ),
    );
  }

  Widget _buildPromotionBanner(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.giftCard,
            AppColors.giftCard.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.giftCard.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '30% Bonus',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'On your first gift card redemption',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.gift,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.backgroundDarkSecondary
              : AppColors.backgroundLightSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            Spacing.verticalS,
            Text(
              title,
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
    );
  }

  Widget _buildGiftCardLogo(Map<String, dynamic> card, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.backgroundDarkSecondary
            : AppColors.backgroundLightSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: card['color'].withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: card['color'],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              card['icon'],
              color: Colors.white,
              size: 24,
            ),
          ),
          Spacing.verticalS,
          Text(
            card['name'],
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDarkMode
                  ? AppColors.textDarkPrimary
                  : AppColors.textLightPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
      Map<String, dynamic> transaction, bool isDarkMode) {
    final DateTime date = transaction['date'] as DateTime;
    final bool isToday = date.day == DateTime.now().day &&
        date.month == DateTime.now().month &&
        date.year == DateTime.now().year;

    final String formattedDate = isToday
        ? 'Today, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}'
        : '${date.day}/${date.month}/${date.year}';

    final Color statusColor = transaction['status'] == 'completed'
        ? AppColors.success
        : transaction['status'] == 'pending'
            ? AppColors.warning
            : AppColors.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.backgroundDarkSecondary
            : AppColors.backgroundLightSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode
              ? Colors.grey.withOpacity(0.2)
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Card icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.giftCard.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Iconsax.card,
              color: AppColors.giftCard,
              size: 24,
            ),
          ),
          Spacing.horizontalM,

          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${transaction['cardType']} Gift Card',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isDarkMode
                        ? AppColors.textDarkPrimary
                        : AppColors.textLightPrimary,
                  ),
                ),
                Spacing.verticalXS,
                Row(
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode
                            ? AppColors.textDarkSecondary
                            : AppColors.textLightSecondary,
                      ),
                    ),
                    Spacing.horizontalS,
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        transaction['status'].toString().toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${transaction['amount']}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isDarkMode
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                ),
              ),
              Text(
                '₦${transaction['amountReceived'].toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.success,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTransactions(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.backgroundDarkSecondary
            : AppColors.backgroundLightSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode
              ? Colors.grey.withOpacity(0.2)
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.card,
            size: 48,
            color: isDarkMode ? AppColors.primaryLight : AppColors.primary,
          ),
          Spacing.verticalM,
          AppText.titleMedium(
            'No Gift Card Transactions Yet',
            textAlign: TextAlign.center,
          ),
          Spacing.verticalS,
          AppText.bodyMedium(
            'Redeem your first gift card to see your transaction history here.',
            textAlign: TextAlign.center,
            color: isDarkMode
                ? AppColors.textDarkSecondary
                : AppColors.textLightSecondary,
          ),
          Spacing.verticalL,
          ElevatedButton.icon(
            onPressed: () => context.push('/gift-cards/redeem'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDarkMode ? AppColors.primaryLight : AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Iconsax.card_add),
            label: const Text('Redeem Gift Card'),
          ),
        ],
      ),
    );
  }

  void _showRatesBottomSheet(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor:
          isDarkMode ? AppColors.backgroundDarkElevated : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.headingMedium('Current Rates'),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Spacing.verticalL,

              // Rates table header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.backgroundDarkSecondary
                      : AppColors.backgroundLightTertiary,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Gift Card',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? AppColors.textDarkPrimary
                              : AppColors.textLightPrimary,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Physical',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? AppColors.textDarkPrimary
                              : AppColors.textLightPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Digital',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? AppColors.textDarkPrimary
                              : AppColors.textLightPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              // Rates list
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _supportedGiftCards.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  itemBuilder: (context, index) {
                    final card = _supportedGiftCards[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppColors.backgroundDark
                            : Colors.white,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: card['color'],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    card['icon'],
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                Spacing.horizontalS,
                                Text(
                                  card['name'],
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? AppColors.textDarkPrimary
                                        : AppColors.textLightPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '₦${card['physicalRate']}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: isDarkMode
                                    ? AppColors.successLight
                                    : AppColors.success,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '₦${card['digitalRate']}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: isDarkMode
                                    ? AppColors.successLight
                                    : AppColors.success,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              Spacing.verticalM,

              // Note about rates
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
                            'Rate Information',
                            color: isDarkMode
                                ? AppColors.textDarkPrimary
                                : AppColors.textLightPrimary,
                          ),
                          Spacing.verticalXS,
                          Text(
                            'Rates are updated hourly and may vary based on market conditions. Physical cards typically have better rates than digital codes.',
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

              Spacing.verticalL,

              // Redeem button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push('/gift-cards/redeem');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDarkMode ? AppColors.primaryLight : AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Iconsax.card_add),
                  label: const Text('Redeem Gift Card'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
