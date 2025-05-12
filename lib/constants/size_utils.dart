import 'package:flutter/material.dart';

/// Utility class for size-related calculations
class SizeUtils {
  /// Returns a percentage of the screen width
  static double widthPercent(BuildContext context, double percent) {
    return MediaQuery.of(context).size.width * (percent / 100);
  }

  /// Returns a percentage of the screen height
  static double heightPercent(BuildContext context, double percent) {
    return MediaQuery.of(context).size.height * (percent / 100);
  }

  /// Returns device screen size
  static Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  /// Checks if the device is in landscape mode
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Returns the smaller dimension between width and height
  static double shortestSide(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide;
  }

  /// Determines if the device is a tablet (based on width)
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  /// Scales a value based on screen size relative to a reference device size
  static double scaleSize(BuildContext context, double size,
      {double referenceWidth = 375.0}) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return size * (deviceWidth / referenceWidth);
  }
}
