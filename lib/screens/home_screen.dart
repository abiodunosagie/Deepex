// lib/screens/home_screen.dart
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

// Import our widgets
import '../components/notification_icon.dart';
import '../models/transaction_model.dart';
import '../widgets/promotional_offers.dart';
import '../widgets/transaction_history.dart';
import '../widgets/wallet_card.dart';

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

  // Navigate to different sections in the app
  void _navigateToSection(String route) {
    // Use push to maintain navigation history
    context.push(route);
  }

  final List<TransactionModel>? _transactions = [
    TransactionModel(
      id: '1',
      type: TransactionType.debit,
      amount: 1500.00,
      description: 'MTN Airtime Recharge',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      status: TransactionStatus.completed,
      category: TransactionCategory.airtime,
    ),
    TransactionModel(
      id: '2',
      type: TransactionType.debit,
      amount: 3750.00,
      description: 'DSTV Subscription',
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: TransactionStatus.completed,
      category: TransactionCategory.utility,
    ),
    TransactionModel(
      id: '3',
      type: TransactionType.credit,
      amount: 50000.00,
      description: 'Bank Transfer',
      date: DateTime.now().subtract(const Duration(days: 2)),
      status: TransactionStatus.completed,
      category: TransactionCategory.bankTransfer,
    ),
    TransactionModel(
      id: '4',
      type: TransactionType.debit,
      amount: 2000.00,
      description: 'Electricity Bill',
      date: DateTime.now().subtract(const Duration(days: 3)),
      status: TransactionStatus.pending,
      category: TransactionCategory.electricity,
    ),
  ];

  // Uncomment this line to see the empty state instead
  // final List<TransactionModel>? _transactions = [];

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wallet Balance Card
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: WalletCard(
                  balance: '₦450,000.00',
                  onAddMoney: () => _navigateToSection('/add-money'),
                ),
              ),
              Spacing.verticalXL,
              // Promotional Offers Section with ViewAll functionality
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.headingMedium('Promotional Offers'),
                    TextButton(
                      onPressed: () {},
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

              PromotionalOffers(
                  // onViewAll: () => _navigateToSection('/offers'),
                  ),

              Spacing.verticalL,

              // Section title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppText.headingMedium('Quick Actions'),
              ),
              // Action cards grid
              Padding(
                padding: const EdgeInsets.all(20),
                child: GridView.count(
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
                      onTap: () => _navigateToSection('/gift-cards'),
                      iconColor: isDarkMode
                          ? AppColors.giftCardLight
                          : AppColors.giftCard,
                    ),
                    ActionCard(
                      icon: Iconsax.mobile,
                      title: 'Airtime',
                      subtitle: 'Recharge',
                      onTap: () => _navigateToSection('/airtime'),
                      iconColor: isDarkMode
                          ? AppColors.airtimeLight
                          : AppColors.airtime,
                    ),
                    ActionCard(
                      icon: Iconsax.wifi,
                      title: 'Data',
                      subtitle: 'Purchase Bundles',
                      onTap: () => _navigateToSection('/data'),
                      iconColor:
                          isDarkMode ? AppColors.dataLight : AppColors.data,
                    ),
                    // New Utilities box added
                    ActionCard(
                      icon: Iconsax.building_3,
                      title: 'Utilities',
                      subtitle: 'Water, TV & More',
                      onTap: () => _navigateToSection('/utilities'),
                      iconColor: isDarkMode
                          ? const Color(
                              0xFFB4A7D6) // Light purple for dark mode
                          : const Color(
                              0xFF674EA7), // Medium purple for light mode
                    ),
                  ],
                ),
              ),

              // Transaction History Section
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TransactionHistorySection(
                  transactions: _transactions,
                  onViewAll: () => _navigateToSection('/transactions'),
                  // Uncomment to show loading state
                  // isLoading: true,
                ),
              ),
            ],
          ),
        ),
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
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.iconColor,
  });

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
                ? Colors.grey
                    .withOpacity(0.1) // Using withOpacity instead of withAlpha
                : Colors.grey.withOpacity(0.2),
            // Using withOpacity instead of withAlpha
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
