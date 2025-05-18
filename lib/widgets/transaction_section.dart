// lib/widgets/promotional_offers.dart

import 'package:deepex/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class PromotionalOffers extends StatefulWidget {
  const PromotionalOffers({super.key});

  @override
  State<PromotionalOffers> createState() => _PromotionalOffersState();
}

class _PromotionalOffersState extends State<PromotionalOffers> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _promotions = [
    {
      'title': '🎁 Refer & Earn',
      'description': 'Get ₦1,000 when your friend signs up',
      'buttonText': 'Invite',
      'gradient': const LinearGradient(
        colors: [Color(0xFF8E24AA), Color(0xFFCB6CE6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'icon': Iconsax.user_tag,
    },
    {
      'title': '💰 30% Cashback',
      'description': 'On all gift card trades this weekend',
      'buttonText': 'Trade Now',
      'gradient': const LinearGradient(
        colors: [Color(0xFF1565C0), Color(0xFF64B5F6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'icon': Iconsax.card,
    },
    {
      'title': '⚡ 5% Off Electricity',
      'description': 'Pay bills and get instant discount',
      'buttonText': 'Pay Now',
      'gradient': const LinearGradient(
        colors: [Color(0xFFEF6C00), Color(0xFFFFB74D)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'icon': Iconsax.flash_1,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Auto scroll the promotional cards
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        final nextPage = (_currentPage + 1) % _promotions.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _promotions.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final promo = _promotions[index];
              return Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                decoration: BoxDecoration(
                  gradient: promo['gradient'],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (promo['gradient'] as LinearGradient)
                          .colors
                          .first
                          .withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Background pattern
                    Positioned(
                      right: -20,
                      bottom: -20,
                      child: Icon(
                        promo['icon'],
                        size: 120,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  promo['title'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  promo['description'],
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                                const Spacer(),
                                OutlinedButton(
                                  onPressed: () {
                                    // Handle button press
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(color: Colors.white),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Text(promo['buttonText']),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              promo['icon'],
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Page indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_promotions.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 8,
              width: _currentPage == index ? 24 : 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? isDarkMode
                        ? AppColors.primaryLight
                        : AppColors.primary
                    : isDarkMode
                        ? Colors.grey.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}
