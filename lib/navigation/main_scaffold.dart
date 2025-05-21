// lib/navigation/main_scaffold.dart
import 'package:deepex/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class MainScaffold extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const MainScaffold({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index, BuildContext context) {
    if (index == widget.currentIndex) return;

    // Give haptic feedback for better UX
    HapticFeedback.lightImpact();

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/transactions');
        break;
      case 2:
        context.go('/profile');
        break;
      case 3:
        context.go('/support');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    // Colors for the navigation bar based on theme
    final backgroundColor =
        isDarkMode ? AppColors.backgroundDarkSurface1 : Colors.white;

    final selectedColor =
        isDarkMode ? AppColors.primaryLight : AppColors.primary;

    // FIXED: Better contrast for unselected icons in dark mode
    final unselectedColor = isDarkMode
        ? AppColors.textDarkMediumEmphasis // Better visibility in dark mode
        : Color.fromRGBO(0, 0, 0, 0.6); // ~60% opacity (replacing withOpacity)

    final shadowColor = isDarkMode
        ? Color.fromRGBO(0, 0, 0, 0.2) // ~20% opacity (replacing withOpacity)
        : Color.fromRGBO(0, 0, 0, 0.1); // ~10% opacity (replacing withOpacity)

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
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
                      isSelected: widget.currentIndex == 0,
                      selectedColor: selectedColor,
                      unselectedColor: unselectedColor,
                    ),
                    _buildNavItem(
                      context: context,
                      icon: Iconsax.activity,
                      selectedIcon: Iconsax.activity5,
                      label: 'Transactions',
                      index: 1,
                      isSelected: widget.currentIndex == 1,
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
                      isSelected: widget.currentIndex == 2,
                      selectedColor: selectedColor,
                      unselectedColor: unselectedColor,
                    ),
                    _buildNavItem(
                      context: context,
                      icon: Iconsax.message_question,
                      selectedIcon: Iconsax.message_question5,
                      label: 'Support',
                      index: 3,
                      isSelected: widget.currentIndex == 3,
                      selectedColor: selectedColor,
                      unselectedColor: unselectedColor,
                    ),
                  ],
                ),
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
    // Pre-calculate colors with transparency
    final highlightColor = Color.fromRGBO(
      selectedColor.red,
      selectedColor.green,
      selectedColor.blue,
      0.1,
    );

    final splashColor = Color.fromRGBO(
      selectedColor.red,
      selectedColor.green,
      selectedColor.blue,
      0.2,
    );

    final containerColor = isSelected
        ? Color.fromRGBO(
            selectedColor.red,
            selectedColor.green,
            selectedColor.blue,
            0.1,
          )
        : Colors.transparent;

    return InkWell(
      onTap: () => _onItemTapped(index, context),
      borderRadius: BorderRadius.circular(16),
      highlightColor: highlightColor,
      // Using pre-calculated color
      splashColor: splashColor,
      // Using pre-calculated color
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: containerColor, // Using pre-calculated color
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
