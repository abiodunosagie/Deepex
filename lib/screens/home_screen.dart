// lib/screens/home_screen.dart
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:deepex/widgets/circle_pattern_painter.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State variable to track notification status
  bool hasNotifications = true;

  // Toggle method to change notification state
  void toggleNotification() {
    setState(() {
      hasNotifications = !hasNotifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Detect if dark mode is active
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Custom AppBar with our layout
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        // No shadow
        toolbarHeight: 80,
        // Taller than default for better spacing
        automaticallyImplyLeading: false,
        // Don't show back button
        title: Row(
          children: [
            // CircleAvatar with theme-aware background
            CircleAvatar(
              radius: 25,
              backgroundColor: isDarkMode
                  ? AppColors.backgroundDarkSecondary
                  : AppColors.backgroundLightSecondary,
              child: Icon(
                Icons.person,
                color: isDarkMode ? AppColors.primaryLight : AppColors.primary,
              ),
            ),
            Spacing.horizontal(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Important for AppBar
              children: [
                AppText.titleLarge(
                  'Hi Smith',
                  color: isDarkMode
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                ),
                AppText.bodySmall(
                  'How are you doing today?',
                  color: isDarkMode
                      ? AppColors.textDarkSecondary
                      : AppColors.textLightSecondary,
                ),
              ],
            ),
          ],
        ),
        // Move notification to actions for proper alignment
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: NotificationIcon(
              hasNotifications: hasNotifications,
              onPressed: toggleNotification,
              color: isDarkMode
                  ? AppColors.textDarkPrimary
                  : AppColors.textLightPrimary,
            ),
          ),
        ],
      ),

      // Main content area
      body: SafeArea(
        // Remove top padding since we're using AppBar
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wallet Balance Card
              WalletCard(
                balance: '₦450,000.00',
                onAddMoney: () {
                  // Handle add money action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Add Money button pressed'),
                    ),
                  );
                },
              ),

              // Section title
              Spacing.verticalXL,
              AppText.headingMedium('Quick Actions'),

              // Action cards grid
              Spacing.verticalM,
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 1.5,
                children: [
                  ActionCard(
                    icon: Iconsax.card,
                    title: 'Gift Cards',
                    subtitle: 'Redeem & Sell',
                    onTap: () {},
                    iconColor: isDarkMode
                        ? AppColors.giftCardLight
                        : AppColors.giftCard,
                  ),
                  ActionCard(
                    icon: Iconsax.mobile,
                    title: 'Airtime',
                    subtitle: 'Recharge',
                    onTap: () {},
                    iconColor:
                        isDarkMode ? AppColors.airtimeLight : AppColors.airtime,
                  ),
                  ActionCard(
                    icon: Iconsax.wifi,
                    title: 'Data',
                    subtitle: 'Purchase Bundles',
                    onTap: () {},
                    iconColor:
                        isDarkMode ? AppColors.dataLight : AppColors.data,
                  ),
                  ActionCard(
                    icon: Iconsax.flash_1,
                    title: 'Electricity',
                    subtitle: 'Pay Bills',
                    onTap: () {},
                    iconColor: isDarkMode
                        ? AppColors.electricityLight
                        : AppColors.electricity,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Beautiful Wallet Card with Balance and Add Money Button
class WalletCard extends StatelessWidget {
  final String balance;
  final VoidCallback? onAddMoney;

  const WalletCard({
    super.key,
    required this.balance,
    this.onAddMoney,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define gradients for light and dark mode
    final lightGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.primary,
        Color(0xFF3267E9), // Slightly lighter shade
      ],
    );

    final darkGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.primaryDark,
        AppColors.primary.withOpacity(0.8),
      ],
    );

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: isDarkMode ? darkGradient : lightGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background circuit pattern (subtle)
          Positioned.fill(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CustomPaint(
                  painter: CurvedLinePatternPainter(
                    lineColor: Colors.white.withAlpha(20),
                    strokeWidth: 1.2,
                    lineCount: 5,
                    amplitude: 15,
                  ),
                )),
          ),

          // Card content
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Wallet label
                Row(
                  children: [
                    Icon(
                      Iconsax.wallet_3,
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Wallet Balance',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                Spacing.verticalM,

                // Balance amount
                Text(
                  balance,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),

                const Spacer(),

                // Add Money button
                GestureDetector(
                  onTap: onAddMoney,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 16),
                        Icon(
                          Iconsax.add,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Add Money',
                          style: TextStyle(
                            color: AppColors.primary,
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

// Action Card for Quick Actions
class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Color? iconColor;

  const ActionCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.backgroundDarkSecondary
              : AppColors.backgroundLightSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode
                ? Colors.grey.withOpacity(0.1)
                : Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconColor ?? AppColors.primary,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
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
    );
  }
}

// Reusable notification icon component with theme support
class NotificationIcon extends StatelessWidget {
  final bool hasNotifications;
  final VoidCallback? onPressed;
  final double size;
  final Color? color;

  const NotificationIcon({
    super.key,
    required this.hasNotifications,
    this.onPressed,
    this.size = 28,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            Iconsax.notification,
            size: size,
            color: color ??
                (isDarkMode
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary),
          ),
        ),
        if (hasNotifications)
          Positioned(
            top: 11,
            right: 12,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 1.5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
