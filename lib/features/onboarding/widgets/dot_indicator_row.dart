import 'package:flutter/material.dart';

import 'dot_indicator.dart';

class DotIndicatorRow extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Color? activeColor;
  final Color? inactiveColor;

  const DotIndicatorRow({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    this.activeColor,
    this.inactiveColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => DotIndicator(
          currentIndex: currentPage,
          dotIndex: index,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
        ),
      ),
    );
  }
}
