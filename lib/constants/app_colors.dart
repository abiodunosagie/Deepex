// lib/constants/app_colors.dart
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

  /// Enhanced dark mode backgrounds (NEW)
  static const Color backgroundDarkAmoled =
      Color(0xFF000000); // True black for AMOLED screens
  static const Color backgroundDarkDeep =
      Color(0xFF0A0A0A); // Deep dark for immersive experiences
  static const Color backgroundDarkSurface1 =
      Color(0xFF1D1D1D); // Surface layer 1
  static const Color backgroundDarkSurface2 =
      Color(0xFF252525); // Surface layer 2
  static const Color backgroundDarkSurface3 =
      Color(0xFF323232); // Surface layer 3
  static const Color backgroundDarkSurface4 =
      Color(0xFF404040); // Surface layer 4
  static const Color backgroundDarkFloating =
      Color(0xFF383838); // For floating elements

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

  /// Enhanced dark mode text (NEW)
  static const Color textDarkHighEmphasis = Color(0xFFFFFFFF); // 100% white
  static const Color textDarkMediumEmphasis = Color(0xFFD8D8D8); // 85% white
  static const Color textDarkLowEmphasis = Color(0xFFAAAAAA); // 67% white
  static const Color textDarkPlaceholder =
      Color(0xFF666666); // Subtle placeholder text

  // =========================================================================
  // BORDER COLORS
  // =========================================================================

  /// Light mode borders
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderLightFocused = Color(0xFF004BF5); // Primary

  /// Dark mode borders
  static const Color borderDark = Color(0xFF424242);
  static const Color borderDarkFocused = Color(0xFF3D73FF); // Primary Light

  /// Enhanced dark mode borders (NEW)
  static const Color borderDarkSubtle = Color(0xFF333333); // Subtle border
  static const Color borderDarkStrong = Color(0xFF555555); // Strong border
  static const Color borderDarkInput = Color(0xFF454545); // For input fields
  static const Color borderDarkDivider = Color(0xFF2A2A2A); // For dividers

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

  /// Dark mode status colors (NEW)
  static const Color successDarkMode =
      Color(0xFF4CAF50); // Brighter for visibility
  static const Color successDarkModeBackground =
      Color(0xFF1B2A1C); // Dark green background
  static const Color errorDarkMode =
      Color(0xFFFF5252); // Brighter for visibility
  static const Color errorDarkModeBackground =
      Color(0xFF2C1B1B); // Dark red background
  static const Color warningDarkMode =
      Color(0xFFFFD54F); // Brighter for visibility
  static const Color warningDarkModeBackground =
      Color(0xFF2D2816); // Dark amber background
  static const Color infoDarkMode =
      Color(0xFF64B5F6); // Brighter for visibility
  static const Color infoDarkModeBackground =
      Color(0xFF1A2530); // Dark blue background

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

  /// Dark mode feature colors (NEW)
  static const Color giftCardDark = Color(0xFF9F80FF); // Brighter purple
  static const Color giftCardDarkBackground =
      Color(0xFF231C35); // Dark purple bg
  static const Color airtimeDark = Color(0xFF66BB6A); // Brighter green
  static const Color airtimeDarkBackground = Color(0xFF1C2A1E); // Dark green bg
  static const Color dataDark = Color(0xFF29B6F6); // Brighter blue
  static const Color dataDarkBackground = Color(0xFF1A2530); // Dark blue bg
  static const Color electricityDark = Color(0xFFFFB74D); // Brighter orange
  static const Color electricityDarkBackground =
      Color(0xFF302519); // Dark orange bg

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

  /// Enhanced dark mode utility colors (NEW)
  static const Color scrimDark =
      Color(0xE6000000); // 90% opacity for fullscreen scrims
  static const Color shadowDark =
      Color(0x4D000000); // For subtle shadows in dark mode
  static const Color rippleDark =
      Color(0x4DFFFFFF); // For touch feedback in dark mode
  static const Color selectionDark =
      Color(0x33004BF5); // Selection highlight in dark mode

  // =========================================================================
  // DARK MODE ACCENT MODIFIERS (NEW)
  // =========================================================================

  /// Dark mode accents (more vibrant for dark backgrounds)
  static const Color accent1Dark = Color(0xFFFF7043); // Brighter vibrant orange
  static const Color accent2Dark = Color(0xFFAB47BC); // Brighter purple
  static const Color accent3Dark = Color(0xFF66BB6A); // Brighter green

  /// Dark mode accent backgrounds
  static const Color accent1DarkBackground =
      Color(0xFF2C1910); // Dark orange background
  static const Color accent2DarkBackground =
      Color(0xFF27182E); // Dark purple background
  static const Color accent3DarkBackground =
      Color(0xFF1B2B1D); // Dark green background

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
    background: backgroundLight,
    error: error,
    onPrimary: Colors.white,
    onSecondary: textLightPrimary,
    onSurface: textLightPrimary,
    onBackground: textLightPrimary,
    onError: Colors.white,
    brightness: Brightness.light,
  );

  /// Generate a complete dark theme ColorScheme
  static const ColorScheme darkColorScheme = ColorScheme(
    primary: primaryLight,
    primaryContainer: primaryDark,
    secondary: secondaryLight,
    secondaryContainer: secondaryDarker,
    surface: backgroundDarkSurface1,
    background: backgroundDark,
    error: errorDarkMode,
    onPrimary: Colors.white,
    onSecondary: textDarkHighEmphasis,
    onSurface: textDarkPrimary,
    onBackground: textDarkPrimary,
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

  // =========================================================================
  // DARK MODE SPECIFIC GRADIENTS (NEW)
  // =========================================================================

  /// Dark mode brand gradient (more subtle)
  static const LinearGradient darkBrandGradient = LinearGradient(
    colors: [primaryLight, Color(0xFF00D6D6)],
    // Tweaked secondary for better contrast
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dark elevation gradient (creates subtle depth)
  static const LinearGradient darkElevationGradient = LinearGradient(
    colors: [backgroundDarkSurface1, backgroundDarkSurface2],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Dark mode card gradient (for premium cards)
  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF202020), Color(0xFF303030)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dark mode deep gradient (for immersive experiences)
  static const LinearGradient darkDeepGradient = LinearGradient(
    colors: [Color(0xFF121212), Color(0xFF000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Dark mode accent gradient
  static const LinearGradient darkAccentGradient = LinearGradient(
    colors: [primaryLight, accent1Dark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
