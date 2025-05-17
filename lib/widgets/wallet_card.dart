import 'package:deepex/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import 'circle_pattern_painter.dart';

class WalletCard extends StatefulWidget {
  final String balance;
  final VoidCallback? onAddMoney;

  const WalletCard({
    super.key,
    required this.balance,
    this.onAddMoney,
  });

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  /// Controls whether balance is visible or hidden
  bool _isBalanceVisible = true;

  /// Toggles balance visibility
  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define gradients for light and dark mode
    final lightGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.primary,
        const Color(0xFF3267E9), // Slightly lighter shade
      ],
    );

    // Cool ash/gray gradient for dark mode
    final darkGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0xFF303339), // Dark ash/slate color
        const Color(0xFF1F2124), // Deeper dark shade
      ],
    );

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: isDarkMode ? darkGradient : lightGradient,
        borderRadius: BorderRadius.circular(20),
        // Add stylish border for both modes
        border: Border.all(
          color: isDarkMode
              ? AppColors.secondaryLight
                  .withAlpha(80) // Subtle cyan border in dark mode
              : Colors.white.withAlpha(40),
          // Very subtle white glow in light mode
          width: isDarkMode ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withAlpha(77) // 0.3 opacity
                : AppColors.primary.withAlpha(77), // 0.3 opacity
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background circuit pattern - optimized
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CustomPaint(
                painter: CircuitPatternPainter(
                  lineColor: isDarkMode
                      ? const Color(
                          0x1AFFFFFF) // White with low opacity for dark mode
                      : Colors.white.withAlpha(40), // Lighter for light mode
                  strokeWidth: 1.2,
                  lineCount: 14,
                  nodeCount: 20,
                ),
              ),
            ),
          ),

          // Card content
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Wallet label row (without eye icon)
                Row(
                  children: [
                    Icon(
                      Iconsax.wallet_3,
                      color:
                          isDarkMode ? AppColors.secondaryLight : Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Wallet Balance',
                      style: TextStyle(
                        color: Colors.white.withAlpha(230), // 0.9 opacity
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Balance amount with visibility toggle next to it
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Balance with animated switching (no Expanded)
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      child: _isBalanceVisible
                          ? Text(
                              widget.balance,
                              key: const ValueKey('visible_balance'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            )
                          : Text(
                              '• • • • • • •',
                              key: const ValueKey('hidden_balance'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3.0,
                              ),
                            ),
                    ),

                    const SizedBox(width: 6),
                    // Small space between balance and icon

                    // Eye icon next to balance
                    IconButton(
                      onPressed: _toggleBalanceVisibility,
                      icon: Icon(
                        _isBalanceVisible ? Iconsax.eye : Iconsax.eye_slash,
                        color: isDarkMode
                            ? AppColors.secondaryLight
                                .withAlpha(204) // Cyan-ish in dark mode
                            : Colors.white.withAlpha(204),
                        // White in light mode
                        size: 22,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip:
                          _isBalanceVisible ? 'Hide balance' : 'Show balance',
                    ),
                  ],
                ),

                const Spacer(),

                // Add Money button - with theme-aware styling
                GestureDetector(
                  onTap: () {
                    context.go('/add-money');
                  },
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color(0xFF3D4047) // Dark gray for dark mode
                          : Colors.white, // White for light mode
                      borderRadius: BorderRadius.circular(12),
                      // Add subtle border to button in both modes
                      border: Border.all(
                        color: isDarkMode
                            ? AppColors.secondaryLight.withAlpha(60)
                            : AppColors.primary.withAlpha(30),
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(26), // 0.1 opacity
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 16),
                        Icon(
                          Iconsax.add,
                          color: isDarkMode
                              ? AppColors.secondaryLight // Cyan for dark mode
                              : AppColors.primary,
                          // Primary blue for light mode
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Add Money',
                          style: TextStyle(
                            color: isDarkMode
                                ? AppColors.secondaryLight // Cyan for dark mode
                                : AppColors.primary,
                            // Primary blue for light mode
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
