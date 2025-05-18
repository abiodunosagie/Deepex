// lib/screens/gift_card/country_selection_screen.dart
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class CountrySelectionScreen extends StatefulWidget {
  const CountrySelectionScreen({super.key});

  @override
  State<CountrySelectionScreen> createState() => _CountrySelectionScreenState();
}

class _CountrySelectionScreenState extends State<CountrySelectionScreen> {
  // Search controller
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // List of available countries with their gift cards
  final List<Map<String, dynamic>> _countries = [
    {
      'code': 'us',
      'name': 'United States',
      'flag': '🇺🇸',
      'currency': 'USD',
      'giftCards': [
        'Amazon',
        'Apple',
        'Google Play',
        'iTunes',
        'Steam',
        'Xbox',
        'PlayStation',
        'Netflix',
        'Walmart',
        'eBay',
        'Target'
      ],
      'conversionRate': 680.0, // Base rate to NGN
    },
    {
      'code': 'uk',
      'name': 'United Kingdom',
      'flag': '🇬🇧',
      'currency': 'GBP',
      'giftCards': [
        'Amazon',
        'Apple',
        'Google Play',
        'iTunes',
        'Steam',
        'Xbox',
        'PlayStation',
        'Netflix',
        'Tesco',
        'Argos',
        'Sainsbury\'s'
      ],
      'conversionRate': 850.0, // Base rate to NGN
    },
    {
      'code': 'ca',
      'name': 'Canada',
      'flag': '🇨🇦',
      'currency': 'CAD',
      'giftCards': [
        'Amazon',
        'Apple',
        'Google Play',
        'iTunes',
        'Steam',
        'Xbox',
        'PlayStation',
        'Netflix',
        'Tim Hortons',
        'Canadian Tire',
        'Shoppers Drug Mart'
      ],
      'conversionRate': 500.0, // Base rate to NGN
    },
    {
      'code': 'eu',
      'name': 'European Union',
      'flag': '🇪🇺',
      'currency': 'EUR',
      'giftCards': [
        'Amazon',
        'Apple',
        'Google Play',
        'iTunes',
        'Steam',
        'Xbox',
        'PlayStation',
        'Netflix',
        'Carrefour',
        'Media Markt',
        'IKEA'
      ],
      'conversionRate': 740.0, // Base rate to NGN
    },
    {
      'code': 'au',
      'name': 'Australia',
      'flag': '🇦🇺',
      'currency': 'AUD',
      'giftCards': [
        'Amazon',
        'Apple',
        'Google Play',
        'iTunes',
        'Steam',
        'Xbox',
        'PlayStation',
        'Netflix',
        'Woolworths',
        'Coles',
        'JB Hi-Fi'
      ],
      'conversionRate': 450.0, // Base rate to NGN
    },
    {
      'code': 'ae',
      'name': 'United Arab Emirates',
      'flag': '🇦🇪',
      'currency': 'AED',
      'giftCards': [
        'Amazon',
        'Apple',
        'Google Play',
        'iTunes',
        'Steam',
        'Xbox',
        'PlayStation',
        'Netflix',
        'Carrefour',
        'Noon',
        'Sharaf DG'
      ],
      'conversionRate': 185.0, // Base rate to NGN
    },
    {
      'code': 'jp',
      'name': 'Japan',
      'flag': '🇯🇵',
      'currency': 'JPY',
      'giftCards': [
        'Amazon',
        'Apple',
        'Google Play',
        'iTunes',
        'Steam',
        'PlayStation',
        'Nintendo',
        'Rakuten',
        'Seven-Eleven',
        'Lawson',
        'Family Mart'
      ],
      'conversionRate': 4.5, // Base rate to NGN
    },
    {
      'code': 'cn',
      'name': 'China',
      'flag': '🇨🇳',
      'currency': 'CNY',
      'giftCards': [
        'WeChat',
        'Alipay',
        'Taobao',
        'JD.com',
        'Tencent',
        'NetEase',
        'Baidu',
        'Steam',
        'Apple',
        'Google Play'
      ],
      'conversionRate': 95.0, // Base rate to NGN
    },
  ];

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

  // Filter countries based on search query
  List<Map<String, dynamic>> get _filteredCountries {
    if (_searchQuery.isEmpty) {
      return _countries;
    }

    return _countries.where((country) {
      final name = country['name'].toString().toLowerCase();
      return name.contains(_searchQuery);
    }).toList();
  }

  // Navigate to the gift cards screen with selected country
  void _selectCountry(Map<String, dynamic> country) {
    context.push('/gift-cards/list', extra: country);
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
          'Select Country',
          color: isDarkMode
              ? AppColors.textDarkPrimary
              : AppColors.textLightPrimary,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.backgroundDarkSecondary
                    : AppColors.backgroundLightSecondary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDarkMode
                      ? Colors.grey.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.3),
                ),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search countries...',
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

          // List of countries
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filteredCountries.length,
              itemBuilder: (context, index) {
                final country = _filteredCountries[index];
                return _buildCountryCard(country, isDarkMode);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryCard(Map<String, dynamic> country, bool isDarkMode) {
    final availableCards = country['giftCards'].length;
    final exchangeRate = country['conversionRate'];
    final currencyCode = country['currency'];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: isDarkMode
          ? AppColors.backgroundDarkSecondary
          : AppColors.backgroundLightSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDarkMode
              ? Colors.grey.withOpacity(0.2)
              : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: InkWell(
        onTap: () => _selectCountry(country),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Country flag
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.backgroundDarkTertiary
                      : AppColors.backgroundLightTertiary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    country['flag'],
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              Spacing.horizontalM,

              // Country details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      country['name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? AppColors.textDarkPrimary
                            : AppColors.textLightPrimary,
                      ),
                    ),
                    Spacing.verticalXS,
                    Row(
                      children: [
                        Icon(
                          Iconsax.card,
                          size: 14,
                          color: isDarkMode
                              ? AppColors.textDarkSecondary
                              : AppColors.textLightSecondary,
                        ),
                        Spacing.horizontalXS,
                        Text(
                          '$availableCards Gift Cards Available',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode
                                ? AppColors.textDarkSecondary
                                : AppColors.textLightSecondary,
                          ),
                        ),
                      ],
                    ),
                    Spacing.verticalXS,
                    Row(
                      children: [
                        Icon(
                          Iconsax.convert,
                          size: 14,
                          color: isDarkMode
                              ? AppColors.textDarkSecondary
                              : AppColors.textLightSecondary,
                        ),
                        Spacing.horizontalXS,
                        Text(
                          '1 $currencyCode = ₦$exchangeRate',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode
                                ? AppColors.successLight
                                : AppColors.success,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow icon
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isDarkMode
                    ? AppColors.textDarkSecondary
                    : AppColors.textLightSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
