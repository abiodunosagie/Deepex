// lib/widgets/onboarding/dot_indicator.dart
import 'package:deepex/constants/app_colors.dart';
import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final int currentIndex;
  final int dotIndex;

  const DotIndicator({
    Key? key,
    required this.currentIndex,
    required this.dotIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 8,
      width: currentIndex == dotIndex ? 24 : 8,
      decoration: BoxDecoration(
        color: currentIndex == dotIndex ? AppColors.primary : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
