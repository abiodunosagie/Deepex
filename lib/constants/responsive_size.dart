import 'package:flutter/material.dart';

/// A utility widget for responsive sizing
///
/// Provides percentage-based sizing relative to screen dimensions
class ResponsiveSize extends StatelessWidget {
  /// Child widget to be sized
  final Widget child;

  /// Width as percentage of screen width (0.0 to 1.0)
  final double? widthFactor;

  /// Height as percentage of screen height (0.0 to 1.0)
  final double? heightFactor;

  /// Maximum width constraint
  final double? maxWidth;

  /// Maximum height constraint
  final double? maxHeight;

  /// Minimum width constraint
  final double? minWidth;

  /// Minimum height constraint
  final double? minHeight;

  const ResponsiveSize({
    super.key,
    required this.child,
    this.widthFactor,
    this.heightFactor,
    this.maxWidth,
    this.maxHeight,
    this.minWidth,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final calculatedWidth =
        widthFactor != null ? screenSize.width * widthFactor! : null;

    final calculatedHeight =
        heightFactor != null ? screenSize.height * heightFactor! : null;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? double.infinity,
        maxHeight: maxHeight ?? double.infinity,
        minWidth: minWidth ?? 0,
        minHeight: minHeight ?? 0,
      ),
      child: SizedBox(
        width: calculatedWidth,
        height: calculatedHeight,
        child: child,
      ),
    );
  }

  /// Creates a widget that takes specific percentage of screen width
  static Widget width({
    required Widget child,
    required double percentage,
    double? maxWidth,
  }) {
    return ResponsiveSize(
      widthFactor: percentage / 100,
      maxWidth: maxWidth,
      child: child,
    );
  }

  /// Creates a widget that takes specific percentage of screen height
  static Widget height({
    required Widget child,
    required double percentage,
    double? maxHeight,
  }) {
    return ResponsiveSize(
      heightFactor: percentage / 100,
      maxHeight: maxHeight,
      child: child,
    );
  }

  /// Creates a widget with both width and height as percentage of screen
  static Widget size({
    required Widget child,
    required double widthPercentage,
    required double heightPercentage,
  }) {
    return ResponsiveSize(
      widthFactor: widthPercentage / 100,
      heightFactor: heightPercentage / 100,
      child: child,
    );
  }
}
