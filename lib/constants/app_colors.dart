// lib/constants/app_colors.dart (Fixed for deprecation warnings)
import 'package:flutter/material.dart';

/// App color system for the Deepex application
///
/// This class defines all colors used throughout the app to ensure
/// consistency and easy theme management. Colors are organized into
/// logical categories for different UI purposes.
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // =========================================================================
  // BRAND COLORS
  // =========================================================================

  /// Primary brand color - Deep Blue (#004bf5)
  static const Color primary = Color(0xFF004BF5);

  /// Primary color variants
  static const Color primaryLight = Color(0xFF3D73FF);
  static const Color primaryLighter = Color(0xFF82A5FF);
  static const Color primaryLightest = Color(0xFFCDDCFF);
  static const Color primaryDark = Color(0xFF003BBF);
  static const Color primaryDarker = Color(0xFF002B8F);

  /// Secondary brand color - Cyan (#00ffff)
  static const Color secondary = Color(0xFF00FFFF);

  /// Secondary color variants
  static const Color secondaryLight = Color(0xFF80FFFF);
  static const Color secondaryLighter = Color(0xFFB3FFFF);
  static const Color secondaryLightest = Color(0xFFE5FFFF);
  static const Color secondaryDark = Color(0xFF00CCCC);
  static const Color secondaryDarker = Color(0xFF009999);

  // =========================================================================
  // ACCENT COLORS
  // =========================================================================

  /// Accent colors for UI highlights and accents
  static const Color accent1 = Color(0xFFFF5722); // Vibrant Orange
  static const Color accent2 = Color(0xFF8E24AA); // Purple
  static const Color accent3 = Color(0xFF43A047); // Green

  // =========================================================================
  // BACKGROUND COLORS
  // =========================================================================

  /// Light mode backgrounds
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundLightSecondary = Color(0xFFF3F4F8);
  static const Color backgroundLightTertiary = Color(0xFFEBEDF2);
  static const Color backgroundLightElevated = Color(0xFFFFFFFF);

  /// Dark mode backgrounds
  static const Color backgroundDark = Color(0xFF121212);
  static const Color backgroundDarkSecondary = Color(0xFF1E1E1E);
  static const Color backgroundDarkTertiary = Color(0xFF2C2C2C);
  static const Color backgroundDarkElevated = Color(0xFF303030);

  // =========================================================================
  // TEXT COLORS
  // =========================================================================

  /// Light mode text
  static const Color textLightPrimary = Color(0xFF212121);
  static const Color textLightSecondary = Color(0xFF616161);
  static const Color textLightDisabled = Color(0xFF9E9E9E);
  static const Color textLightInverse = Color(0xFFFAFAFA);

  /// Dark mode text
  static const Color textDarkPrimary = Color(0xFFE6E6E6);
  static const Color textDarkSecondary = Color(0xFFB0B0B0);
  static const Color textDarkDisabled = Color(0xFF707070);
  static const Color textDarkInverse = Color(0xFF212121);

  // =========================================================================
  // BORDER COLORS
  // =========================================================================

  /// Light mode borders
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderLightFocused = Color(0xFF004BF5); // Primary

  /// Dark mode borders
  static const Color borderDark = Color(0xFF424242);
  static const Color borderDarkFocused = Color(0xFF3D73FF); // Primary Light

  // =========================================================================
  // STATUS COLORS
  // =========================================================================

  /// Success states
  static const Color success = Color(0xFF43A047);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color successDark = Color(0xFF2E7D32);

  /// Error states
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color errorDark = Color(0xFFC62828);

  /// Warning states
  static const Color warning = Color(0xFFFFB300);
  static const Color warningLight = Color(0xFFFFF8E1);
  static const Color warningDark = Color(0xFFFFA000);

  /// Info states
  static const Color info = Color(0xFF1E88E5);
  static const Color infoLight = Color(0xFFE3F2FD);
  static const Color infoDark = Color(0xFF1565C0);

  // =========================================================================
  // FEATURE-SPECIFIC COLORS
  // =========================================================================

  /// Gift Card feature colors
  static const Color giftCard = Color(0xFF7C4DFF);
  static const Color giftCardLight = Color(0xFFE8E4FF);

  /// Airtime feature colors
  static const Color airtime = Color(0xFF43A047);
  static const Color airtimeLight = Color(0xFFE8F5E9);

  /// Data feature colors
  static const Color data = Color(0xFF0091EA);
  static const Color dataLight = Color(0xFFE1F5FE);

  /// Electricity feature colors
  static const Color electricity = Color(0xFFFF6F00);
  static const Color electricityLight = Color(0xFFFFF3E0);

  // =========================================================================
  // UTILITY COLORS
  // =========================================================================

  /// Overlay colors for modals, drawers etc.
  static const Color overlay = Color(0x80000000); // 50% opacity black
  static const Color overlayDark = Color(0xB3000000); // 70% opacity black

  /// Divider colors
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF424242);

  /// Shimmer effect colors (for loading states)
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color shimmerBaseDark = Color(0xFF3A3A3A);
  static const Color shimmerHighlightDark = Color(0xFF525252);

  // =========================================================================
  // COLOR SCHEMES
  // =========================================================================

  /// Generate a complete light theme ColorScheme
  static const ColorScheme lightColorScheme = ColorScheme(
    primary: primary,
    primaryContainer: primaryLightest,
    secondary: secondary,
    secondaryContainer: secondaryLightest,
    surface: backgroundLightElevated,
    error: error,
    onPrimary: Colors.white,
    onSecondary: textLightPrimary,
    onSurface: textLightPrimary,
    onError: Colors.white,
    brightness: Brightness.light,
  );

  /// Generate a complete dark theme ColorScheme
  static const ColorScheme darkColorScheme = ColorScheme(
    primary: primaryLight,
    primaryContainer: primaryDark,
    secondary: secondaryLight,
    secondaryContainer: secondaryDarker,
    surface: backgroundDarkElevated,
    error: error,
    onPrimary: Colors.white,
    onSecondary: textDarkPrimary,
    onSurface: textDarkPrimary,
    onError: Colors.white,
    brightness: Brightness.dark,
  );

  // =========================================================================
  // GRADIENTS
  // =========================================================================

  /// Brand gradient - Primary to Secondary (for prominent elements)
  static const LinearGradient brandGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Primary gradient - Primary to Primary Dark (for buttons, etc.)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDarker],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Secondary gradient - Secondary to Secondary Dark
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryDarker],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
