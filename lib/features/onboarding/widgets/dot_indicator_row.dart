// lib/widgets/onboarding/dot_indicator_row.dart
import 'package:flutter/material.dart';

import 'dot_indicator.dart';

class DotIndicatorRow extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const DotIndicatorRow({
    Key? key,
    required this.currentPage,
    required this.totalPages,
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
        ),
      ),
    );
  }
}
