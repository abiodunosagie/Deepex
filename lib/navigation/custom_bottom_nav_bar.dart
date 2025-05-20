// lib/navigation/custom_bottom_nav_bar.dart
import 'package:deepex/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Colors for the navigation bar based on theme
    final backgroundColor =
        isDarkMode ? AppColors.backgroundDarkSurface1 : Colors.white;

    final selectedColor =
        isDarkMode ? AppColors.primaryLight : AppColors.primary;

    // FIXED: Better contrast for unselected icons in dark mode
    final unselectedColor = isDarkMode
        ? AppColors.textDarkMediumEmphasis // Better visibility in dark mode
        : Colors.black.withOpacity(0.6); // ~60% opacity

    final shadowColor = isDarkMode
        ? Colors.black.withOpacity(0.2) // ~20% opacity
        : Colors.black.withOpacity(0.1); // ~10% opacity

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomAppBar(
          color: backgroundColor,
          height: 80,
          padding: EdgeInsets.zero,
          notchMargin: 8,
          elevation: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context: context,
                    icon: Iconsax.home_2,
                    selectedIcon: Iconsax.home_25,
                    label: 'Home',
                    index: 0,
                    isSelected: currentIndex == 0,
                    selectedColor: selectedColor,
                    unselectedColor: unselectedColor,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Iconsax.activity,
                    selectedIcon: Iconsax.activity5,
                    label: 'Transactions',
                    index: 1,
                    isSelected: currentIndex == 1,
                    selectedColor: selectedColor,
                    unselectedColor: unselectedColor,
                  ),
                  _buildNavItem(
                    context: context,
                    // FIXED: Better profile icon visibility
                    icon: Iconsax.profile_circle,
                    selectedIcon: Iconsax.profile_tick5,
                    label: 'Profile',
                    index: 2,
                    isSelected: currentIndex == 2,
                    selectedColor: selectedColor,
                    unselectedColor: unselectedColor,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Iconsax.message_question,
                    selectedIcon: Iconsax.message_question5,
                    label: 'Support',
                    index: 3,
                    isSelected: currentIndex == 3,
                    selectedColor: selectedColor,
                    unselectedColor: unselectedColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
    required bool isSelected,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    return InkWell(
      onTap: () {
        if (currentIndex != index) {
          HapticFeedback.lightImpact();
          onTap(index);
        }
      },
      borderRadius: BorderRadius.circular(16),
      highlightColor: selectedColor.withOpacity(0.1),
      splashColor: selectedColor.withOpacity(0.2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color:
              isSelected ? selectedColor.withOpacity(0.1) : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: Icon(
                isSelected ? selectedIcon : icon,
                key: ValueKey(isSelected),
                color: isSelected ? selectedColor : unselectedColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? selectedColor : unselectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
