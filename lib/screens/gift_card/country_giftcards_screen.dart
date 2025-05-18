// lib/screens/gift_card/country_gift_cards_screen.dart
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class CountryGiftCardsScreen extends StatefulWidget {
  final Map<String, dynamic> country;

  const CountryGiftCardsScreen({
    super.key,
    required this.country,
  });

  @override
  State<CountryGiftCardsScreen> createState() => _CountryGiftCardsScreenState();
}

class _CountryGiftCardsScreenState extends State<CountryGiftCardsScreen> {
  // Search controller
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Gift card details for the selected country - same as before
  final Map<String, Map<String, dynamic>> _giftCardDetails = {
    'Amazon': {
      'name': 'Amazon',
      'icon': Iconsax.card,
      'color': const Color(0xFFFF9900),
      'physicalRate': 1.0, // Multiplier for country's base rate
      'digitalRate': 0.95, // Multiplier for country's base rate
      'minAmount': 25,
      'maxAmount': 2000,
    },
    // ... other gift cards (no changes needed here)
  };

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  // Get gift cards available for this country
  List<Map<String, dynamic>> get _availableGiftCards {
    final countryCards = widget.country['giftCards'] as List;
    final List<Map<String, dynamic>> cards = [];

    for (var cardName in countryCards) {
      if (_giftCardDetails.containsKey(cardName)) {
        final cardDetails = _giftCardDetails[cardName]!;

        // Calculate specific rates for this country
        final baseRate = widget.country['conversionRate'] as double;
        final physicalRate = (cardDetails['physicalRate'] as double) * baseRate;
        final digitalRate = (cardDetails['digitalRate'] as double) * baseRate;

        // Create a new map with all the details
        final cardWithRates = {
          ...cardDetails,
          'countryCode': widget.country['code'],
          'currency': widget.country['currency'],
          'actualPhysicalRate': physicalRate,
          'actualDigitalRate': digitalRate,
        };

        cards.add(cardWithRates);
      }
    }

    return cards;
  }

  // Filter gift cards based on search query
  List<Map<String, dynamic>> get _filteredGiftCards {
    if (_searchQuery.isEmpty) {
      return _availableGiftCards;
    }

    return _availableGiftCards.where((card) {
      final name = card['name'].toString().toLowerCase();
      return name.contains(_searchQuery);
    }).toList();
  }

  // Navigate to redemption screen with selected card
  void _selectGiftCard(Map<String, dynamic> card) {
    final Map<String, dynamic> redemptionData = {
      'cardDetails': card,
      'country': widget.country,
    };

    context.push('/gift-cards/redeem-card', extra: redemptionData);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final countryName = widget.country['name'];
    final countryFlag = widget.country['flag'];
    final currencyCode = widget.country['currency'];

    // Background and card colors adjusted for better contrast in both modes
    final bgColor =
        isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight;
    final cardBgColor = isDarkMode
        ? AppColors.backgroundDarkSecondary
        : AppColors.backgroundLightSecondary;
    final searchBorderColor = isDarkMode
        ? Colors.grey.withAlpha(51)
        : Colors.grey.withAlpha(77); // 0.2 and 0.3 opacity

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: isDarkMode
                ? AppColors.backgroundDarkSecondary
                    .withAlpha(153) // 0.6 opacity
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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              countryFlag,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 8),
            AppText.titleLarge(
              countryName,
              color: isDarkMode
                  ? AppColors.textDarkPrimary
                  : AppColors.textLightPrimary,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Country info banner
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.giftCard.withAlpha(26) // 0.1 opacity
                  : AppColors.giftCardLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Iconsax.info_circle,
                  color: AppColors.giftCard,
                  size: 24,
                ),
                Spacing.horizontalM,
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.textDarkSecondary
                            : AppColors.textLightSecondary,
                        fontSize: 14,
                      ),
                      children: [
                        const TextSpan(
                            text:
                                'Select a gift card to redeem. Rates shown are in '),
                        TextSpan(
                          text: 'Nigerian Naira (₦)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? AppColors.textDarkPrimary
                                : AppColors.textLightPrimary,
                          ),
                        ),
                        TextSpan(text: ' per $currencyCode.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: searchBorderColor,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search gift cards...',
                  hintStyle: TextStyle(
                    color: isDarkMode
                        ? AppColors.textDarkSecondary
                        : AppColors.textLightSecondary,
                  ),
                  prefixIcon: Icon(
                    Iconsax.search_normal,
                    color: isDarkMode
                        ? AppColors.textDarkSecondary
                        : AppColors.textLightSecondary,
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),
          Spacing.verticalM,

          // Gift card grid
          Expanded(
            child: _filteredGiftCards.isEmpty
                ? _buildEmptyState(isDarkMode)
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _filteredGiftCards.length,
                    itemBuilder: (context, index) {
                      final card = _filteredGiftCards[index];
                      return _buildGiftCardItem(card, isDarkMode);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Improved gift card item with better rates display
  Widget _buildGiftCardItem(Map<String, dynamic> card, bool isDarkMode) {
    final String cardName = card['name'];
    final Color cardColor = card['color'];
    final double physicalRate = card['actualPhysicalRate'];
    final double digitalRate = card['actualDigitalRate'];

    // Card styling improvements
    final cardBgColor = isDarkMode
        ? AppColors.backgroundDarkSecondary
        : AppColors.backgroundLightSecondary;
    final cardBorderColor = cardColor.withAlpha(77); // 0.3 opacity
    final tagBgColor = isDarkMode
        ? AppColors.backgroundDarkTertiary
        : AppColors.backgroundLightTertiary;

    // Text colors
    final primaryTextColor =
        isDarkMode ? AppColors.textDarkPrimary : AppColors.textLightPrimary;
    final secondaryTextColor =
        isDarkMode ? AppColors.textDarkSecondary : AppColors.textLightSecondary;

    // Rate colors - more vibrant in dark mode
    final physicalRateColor =
        isDarkMode ? AppColors.successLight : AppColors.success;
    final digitalRateColor = isDarkMode ? AppColors.infoLight : AppColors.info;

    return InkWell(
      onTap: () => _selectGiftCard(card),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: cardBorderColor,
            width: 1.5,
          ),
          boxShadow: isDarkMode
              ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(40), // 0.15 opacity
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(15), // 0.06 opacity
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Card logo
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Iconsax.card,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              Spacing.verticalM,

              // Card name
              Text(
                cardName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Spacing.verticalS,

              // Improved Rate Tags
              // Physical rate tag
              _buildRateTag(
                icon: Iconsax.card_tick,
                label: 'Physical',
                rate: '₦${physicalRate.toStringAsFixed(0)}',
                backgroundColor: tagBgColor,
                labelColor: secondaryTextColor,
                valueColor: physicalRateColor,
              ),

              const SizedBox(height: 4),

              // Digital rate tag
              _buildRateTag(
                icon: Iconsax.code,
                label: 'Digital',
                rate: '₦${digitalRate.toStringAsFixed(0)}',
                backgroundColor: tagBgColor,
                labelColor: secondaryTextColor,
                valueColor: digitalRateColor,
              ),

              Spacing.verticalM,

              // Redeem button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _selectGiftCard(card),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cardColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Redeem',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // New widget for rate tags to avoid duplication and ensure consistency
  Widget _buildRateTag({
    required IconData icon,
    required String label,
    required String rate,
    required Color backgroundColor,
    required Color labelColor,
    required Color valueColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 12,
            color: labelColor,
          ),
          const SizedBox(width: 4),
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 10,
              color: labelColor,
            ),
          ),
          const Spacer(),
          Text(
            rate,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.card_slash,
            size: 64,
            color: isDarkMode
                ? AppColors.textDarkSecondary
                : AppColors.textLightSecondary,
          ),
          Spacing.verticalL,
          AppText.titleMedium(
            'No Gift Cards Found',
            textAlign: TextAlign.center,
          ),
          Spacing.verticalS,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: AppText.bodyMedium(
              'We couldn\'t find any gift cards matching your search criteria.',
              textAlign: TextAlign.center,
              color: isDarkMode
                  ? AppColors.textDarkSecondary
                  : AppColors.textLightSecondary,
            ),
          ),
          Spacing.verticalL,
          ElevatedButton(
            onPressed: () {
              _searchController.clear();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDarkMode ? AppColors.primaryLight : AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Clear Search'),
          ),
        ],
      ),
    );
  }
}
