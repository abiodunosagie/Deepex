import 'package:flutter/material.dart';

/// Predefined text styles for consistent typography throughout the app
class AppTextStyles {
  // Display - Large headings
  static TextStyle displayLarge({
    Color? color,
    FontWeight fontWeight = FontWeight.bold,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 32.0,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
    );
  }

  static TextStyle displayMedium({
    Color? color,
    FontWeight fontWeight = FontWeight.bold,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 28.0,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
    );
  }

  static TextStyle displaySmall({
    Color? color,
    FontWeight fontWeight = FontWeight.bold,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 24.0,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
    );
  }

  // Heading - Section headers
  static TextStyle headingLarge({
    Color? color,
    FontWeight fontWeight = FontWeight.w600,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 22.0,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
    );
  }

  static TextStyle headingMedium({
    Color? color,
    FontWeight fontWeight = FontWeight.w600,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 20.0,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
    );
  }

  static TextStyle headingSmall({
    Color? color,
    FontWeight fontWeight = FontWeight.w600,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 18.0,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
    );
  }

  // Title - Card titles, dialog titles
  static TextStyle titleLarge({
    Color? color,
    FontWeight fontWeight = FontWeight.w600,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 16.0,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
    );
  }

  static TextStyle titleMedium({
    Color? color,
    FontWeight fontWeight = FontWeight.w600,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 15.0,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
    );
  }

  static TextStyle titleSmall({
    Color? color,
    FontWeight fontWeight = FontWeight.w600,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 14.0,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
    );
  }

  // Body - Regular text
  static TextStyle bodyLarge({
    Color? color,
    FontWeight fontWeight = FontWeight.normal,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 16.0,
      fontWeight: fontWeight,
      color: color,
      height: height ?? 1.5,
      decoration: decoration,
    );
  }

  static TextStyle bodyMedium({
    Color? color,
    FontWeight fontWeight = FontWeight.normal,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 14.0,
      fontWeight: fontWeight,
      color: color,
      height: height ?? 1.5,
      decoration: decoration,
    );
  }

  static TextStyle bodySmall({
    Color? color,
    FontWeight fontWeight = FontWeight.normal,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 12.0,
      fontWeight: fontWeight,
      color: color,
      height: height ?? 1.5,
      decoration: decoration,
    );
  }

  // Label - Button text, input labels
  static TextStyle labelLarge({
    Color? color,
    FontWeight fontWeight = FontWeight.w500,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 16.0,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: 0.5,
      height: height,
      decoration: decoration,
    );
  }

  static TextStyle labelMedium({
    Color? color,
    FontWeight fontWeight = FontWeight.w500,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 14.0,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: 0.5,
      height: height,
      decoration: decoration,
    );
  }

  static TextStyle labelSmall({
    Color? color,
    FontWeight fontWeight = FontWeight.w500,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 12.0,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: 0.5,
      height: height,
      decoration: decoration,
    );
  }

  // Caption - Smallest text, footnotes
  static TextStyle caption({
    Color? color,
    FontWeight fontWeight = FontWeight.normal,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 11.0,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
    );
  }

  // Button - For buttons specifically
  static TextStyle button({
    Color? color,
    FontWeight fontWeight = FontWeight.w500,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: 16.0,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: 0.5,
      height: height,
      decoration: decoration,
    );
  }
}
