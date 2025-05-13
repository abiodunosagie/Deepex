import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final int currentIndex;
  final int dotIndex;
  final Color? activeColor;
  final Color? inactiveColor;

  const DotIndicator({
    Key? key,
    required this.currentIndex,
    required this.dotIndex,
    this.activeColor,
    this.inactiveColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isActive = currentIndex == dotIndex;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? activeColor ?? Colors.blue
            : inactiveColor ?? Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
