// lib/components/padding.dart
import 'package:deepex/constants/size_constants.dart';
import 'package:flutter/material.dart';

/// A widget that provides standardized padding
///
/// Usage:
/// - AppPadding.all(child: widget)
/// - AppPadding.horizontal(child: widget)
/// - AppPadding.vertical(child: widget)
/// - AppPadding.only(top: Sizes.m, left: Sizes.s, child: widget)
class AppPadding extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const AppPadding({
    Key? key,
    required this.child,
    required this.padding,
  }) : super(key: key);

  /// Creates padding on all sides
  factory AppPadding.all({
    Key? key,
    required Widget child,
    double value = Sizes.m,
  }) {
    return AppPadding(
      key: key,
      child: child,
      padding: EdgeInsets.all(value),
    );
  }

  /// Creates horizontal padding
  factory AppPadding.horizontal({
    Key? key,
    required Widget child,
    double value = Sizes.m,
  }) {
    return AppPadding(
      key: key,
      child: child,
      padding: EdgeInsets.symmetric(horizontal: value),
    );
  }

  /// Creates vertical padding
  factory AppPadding.vertical({
    Key? key,
    required Widget child,
    double value = Sizes.m,
  }) {
    return AppPadding(
      key: key,
      child: child,
      padding: EdgeInsets.symmetric(vertical: value),
    );
  }

  /// Creates padding with specific sides
  factory AppPadding.only({
    Key? key,
    required Widget child,
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return AppPadding(
      key: key,
      child: child,
      padding: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
    );
  }

  // Predefined constant paddings
  static const EdgeInsets screenPadding = EdgeInsets.all(Sizes.screenPadding);
  static const EdgeInsets cardPadding = EdgeInsets.all(Sizes.cardPadding);
  static const EdgeInsets dialogPadding = EdgeInsets.all(Sizes.dialogPadding);

  static AppPadding screen({required Widget child}) {
    return AppPadding(
      padding: screenPadding,
      child: child,
    );
  }

  static AppPadding card({required Widget child}) {
    return AppPadding(
      padding: cardPadding,
      child: child,
    );
  }

  static AppPadding dialog({required Widget child}) {
    return AppPadding(
      padding: dialogPadding,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: child,
    );
  }
}
