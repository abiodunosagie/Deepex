// lib/screens/support_screen.dart
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  late final TextEditingController _searchController;
  final List<FAQItem> _faqItems = [
    FAQItem(
      question: 'How do I add money to my wallet?',
      answer:
          'You can add money to your wallet through bank transfer, debit card, or by using a gift card. Go to Home > Add Money and select your preferred method.',
      category: 'Payments',
    ),
    FAQItem(
      question: 'How long does a transaction take to complete?',
      answer:
          'Most transactions are processed instantly. However, bank transfers may take up to 24 hours depending on your bank.',
      category: 'Transactions',
    ),
    FAQItem(
      question: 'Can I cancel a pending transaction?',
      answer:
          'Yes, you can cancel a pending transaction by going to Transactions > Select the transaction > Cancel. Note that completed transactions cannot be cancelled.',
      category: 'Transactions',
    ),
    FAQItem(
      question: 'Is my personal information secure?',
      answer:
          'Yes, we use industry-standard encryption and security measures to protect your personal information. We also comply with all relevant data protection regulations.',
      category: 'Security',
    ),
    FAQItem(
      question: 'How do I update my account details?',
      answer:
          'Go to Profile > Edit Profile to update your personal information. For security reasons, some changes may require additional verification.',
      category: 'Account',
    ),
  ];

  bool _isExpanded = false;
  int _selectedFaqIndex = -1;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFaq(int index) {
    setState(() {
      if (_selectedFaqIndex == index) {
        _selectedFaqIndex = -1;
      } else {
        _selectedFaqIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define our UI colors based on theme mode
    final backgroundColor =
        isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight;
    final cardColor =
        isDarkMode ? AppColors.backgroundDarkElevated : Colors.white;
    final primaryTextColor =
        isDarkMode ? AppColors.textDarkPrimary : AppColors.textLightPrimary;
    final secondaryTextColor =
        isDarkMode ? AppColors.textDarkSecondary : AppColors.textLightSecondary;
    final accentColor = isDarkMode ? AppColors.primaryLight : AppColors.primary;
    final dividerColor =
        isDarkMode ? Colors.grey.withAlpha(51) : Colors.grey.withAlpha(26);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Help & Support',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: primaryTextColor,
          ),
        ),
      ),
      body: Column(
        children: [
          // Support banner with live chat option
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accentColor.withAlpha(26),
                  accentColor.withAlpha(77),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withAlpha(26),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(153),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Iconsax.support,
                        color: accentColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Need Help?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Our support team is available 24/7',
                            style: TextStyle(
                              fontSize: 14,
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildSupportButton(
                        icon: Iconsax.message,
                        label: 'Live Chat',
                        onTap: () {
                          // Open live chat
                        },
                        backgroundColor: accentColor,
                        textColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSupportButton(
                        icon: Iconsax.call,
                        label: 'Call Us',
                        onTap: () {
                          // Make call
                        },
                        backgroundColor: Colors.white,
                        textColor: accentColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(isDarkMode ? 26 : 13),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: primaryTextColor),
                decoration: InputDecoration(
                  hintText: 'Search for help',
                  hintStyle: TextStyle(color: secondaryTextColor),
                  prefixIcon: Icon(Iconsax.search_normal,
                      color: secondaryTextColor, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),

          // FAQ Categories
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.titleSmall('Common Topics'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTopicChip(
                      icon: Iconsax.wallet,
                      label: 'Payments',
                      isDarkMode: isDarkMode,
                      accentColor: accentColor,
                    ),
                    _buildTopicChip(
                      icon: Iconsax.security,
                      label: 'Security',
                      isDarkMode: isDarkMode,
                      accentColor: accentColor,
                    ),
                    _buildTopicChip(
                      icon: Iconsax.profile_2user,
                      label: 'Account',
                      isDarkMode: isDarkMode,
                      accentColor: accentColor,
                    ),
                    _buildTopicChip(
                      icon: Iconsax.card,
                      label: 'Cards',
                      isDarkMode: isDarkMode,
                      accentColor: accentColor,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // FAQ Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.titleSmall('Frequently Asked Questions'),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                      _selectedFaqIndex = _isExpanded ? 0 : -1;
                    });
                  },
                  child: Text(
                    _isExpanded ? 'Collapse All' : 'Expand All',
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // FAQ List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: _faqItems.length,
              itemBuilder: (context, index) {
                final faq = _faqItems[index];
                final isExpanded = _isExpanded || _selectedFaqIndex == index;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(isDarkMode ? 26 : 13),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      title: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: accentColor.withAlpha(26),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              'Q',
                              style: TextStyle(
                                color: accentColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              faq.question,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: primaryTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: isExpanded
                              ? accentColor.withAlpha(26)
                              : isDarkMode
                                  ? Colors.grey.withAlpha(26)
                                  : Colors.grey.withAlpha(13),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isExpanded ? Icons.remove : Icons.add,
                          color: isExpanded ? accentColor : secondaryTextColor,
                          size: 18,
                        ),
                      ),
                      initiallyExpanded: isExpanded,
                      onExpansionChanged: (expanded) {
                        _toggleFaq(index);
                      },
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(
                                color: dividerColor,
                                thickness: 1,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withAlpha(26),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Text(
                                      'A',
                                      style: TextStyle(
                                        color: AppColors.success,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      faq.answer,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: secondaryTextColor,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Was this helpful?',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: secondaryTextColor,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          // Handle thumbs up
                                        },
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: isDarkMode
                                                ? AppColors
                                                    .backgroundDarkSecondary
                                                : AppColors
                                                    .backgroundLightSecondary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.thumb_up_outlined,
                                            size: 16,
                                            color: secondaryTextColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      InkWell(
                                        onTap: () {
                                          // Handle thumbs down
                                        },
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: isDarkMode
                                                ? AppColors
                                                    .backgroundDarkSecondary
                                                : AppColors
                                                    .backgroundLightSecondary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.thumb_down_outlined,
                                            size: 16,
                                            color: secondaryTextColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicChip({
    required IconData icon,
    required String label,
    required bool isDarkMode,
    required Color accentColor,
  }) {
    return InkWell(
      onTap: () {
        // Handle topic selection
      },
      borderRadius: BorderRadius.circular(30),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.backgroundDarkSecondary
                  : AppColors.backgroundLightSecondary,
              shape: BoxShape.circle,
              border: Border.all(
                color: accentColor.withAlpha(77),
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 20,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode
                  ? AppColors.textDarkSecondary
                  : AppColors.textLightSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;
  final String category;

  FAQItem({
    required this.question,
    required this.answer,
    required this.category,
  });
}
