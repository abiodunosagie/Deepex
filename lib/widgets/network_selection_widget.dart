import 'package:deepex/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NetworkSelectionGrid extends StatelessWidget {
  final List<Map<String, dynamic>> networks;
  final String selectedNetwork;
  final Function(String) onNetworkSelected;
  final bool animateIn;

  const NetworkSelectionGrid({
    Key? key,
    required this.networks,
    required this.selectedNetwork,
    required this.onNetworkSelected,
    this.animateIn = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Create the base widget
    Widget gridWidget = GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: networks.length,
      itemBuilder: (context, index) {
        final network = networks[index];
        final isSelected = selectedNetwork == network['name'];
        final networkColor = isDarkMode
            ? network['darkColor'] as Color
            : network['color'] as Color;

        return NetworkCard(
          networkName: network['name'],
          networkIcon: network['icon'],
          networkColor: networkColor,
          isSelected: isSelected,
          onTap: () => onNetworkSelected(network['name']),
          isDarkMode: isDarkMode,
        );
      },
    );

    // Add animation if requested
    if (animateIn) {
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutQuad,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, (1 - value) * 50),
            child: Opacity(
              opacity: value,
              child: child,
            ),
          );
        },
        child: gridWidget,
      );
    }

    return gridWidget;
  }
}

class NetworkCard extends StatelessWidget {
  final String networkName;
  final String networkIcon;
  final Color networkColor;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDarkMode;

  // Map of fallback icons to use if images aren't available
  static const Map<String, IconData> fallbackIcons = {
    'MTN': Iconsax.mobile,
    'Airtel': Iconsax.mobile,
    'Glo': Iconsax.mobile,
    '9mobile': Iconsax.mobile,
  };

  const NetworkCard({
    Key? key,
    required this.networkName,
    required this.networkIcon,
    required this.networkColor,
    required this.isSelected,
    required this.onTap,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? networkColor.withOpacity(0.15)
              : isDarkMode
                  ? AppColors.backgroundDarkSecondary
                  : AppColors.backgroundLightSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? networkColor
                : isDarkMode
                    ? Colors.grey.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: networkColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Use ErrorBuilder to fall back to icon if image fails
                  Image.asset(
                    networkIcon,
                    height: 48,
                    width: 48,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      fallbackIcons[networkName] ?? Iconsax.mobile,
                      color: networkColor,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    networkName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? networkColor
                          : isDarkMode
                              ? AppColors.textDarkPrimary
                              : AppColors.textLightPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PackageSelectionGrid extends StatelessWidget {
  final List<Map<String, dynamic>> packages;
  final double selectedAmount;
  final Function(double) onPackageSelected;
  final Color networkColor;

  const PackageSelectionGrid({
    Key? key,
    required this.packages,
    required this.selectedAmount,
    required this.onPackageSelected,
    required this.networkColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: packages.length,
      itemBuilder: (context, index) {
        final package = packages[index];
        final amount = package['amount'] as double;
        final isSelected = selectedAmount == amount;

        return GestureDetector(
          onTap: () => onPackageSelected(amount),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? networkColor.withOpacity(0.15)
                  : isDarkMode
                      ? AppColors.backgroundDarkSecondary
                      : AppColors.backgroundLightSecondary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? networkColor
                    : isDarkMode
                        ? Colors.grey.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.2),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Stack(
              children: [
                if (isSelected)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: networkColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₦${amount.toInt()}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? networkColor
                              : isDarkMode
                                  ? AppColors.textDarkPrimary
                                  : AppColors.textLightPrimary,
                        ),
                      ),
                      const Spacer(),
                      if (package['validity'] != null) ...[
                        Text(
                          package['validity'],
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode
                                ? AppColors.textDarkSecondary
                                : AppColors.textLightSecondary,
                          ),
                        ),
                      ],
                      if (package['bonus'] != null &&
                          package['bonus'] != 'N0') ...[
                        Text(
                          package['bonus'],
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.success,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class RecentNumbersList extends StatelessWidget {
  final List<String> recentNumbers;
  final Function(String) onNumberSelected;
  final Function(String) formatPhoneNumber;

  const RecentNumbersList({
    Key? key,
    required this.recentNumbers,
    required this.onNumberSelected,
    required this.formatPhoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recentNumbers.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => onNumberSelected(recentNumbers[index]),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.backgroundDarkSecondary
                      : AppColors.backgroundLightSecondary,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isDarkMode
                        ? Colors.grey.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Iconsax.user,
                      size: 16,
                      color: isDarkMode
                          ? AppColors.textDarkSecondary
                          : AppColors.textLightSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formatPhoneNumber(recentNumbers[index]),
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.textDarkPrimary
                            : AppColors.textLightPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
