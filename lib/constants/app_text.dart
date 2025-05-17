import 'package:deepex/constants/text_styles.dart';
import 'package:flutter/material.dart';

/// Text presets to use with AppText component
enum TextPreset {
  displayLarge,
  displayMedium,
  displaySmall,
  headingLarge,
  headingMedium,
  headingSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall,
  caption,
  button,
}

/// A component for displaying text with consistent styling across the app
class AppText extends StatelessWidget {
  /// The text to display
  final String text;

  /// Predefined text style preset
  final TextPreset preset;

  /// Optional custom text style to override preset
  final TextStyle? style;

  /// Text color
  final Color? color;

  /// Font weight
  final FontWeight? fontWeight;

  /// Maximum number of lines
  final int? maxLines;

  /// Text overflow behavior
  final TextOverflow? overflow;

  /// Text alignment
  final TextAlign? textAlign;

  /// Whether to softwrap text
  final bool? softWrap;

  /// Text decoration (underline, line-through, etc.)
  final TextDecoration? decoration;

  /// Line height multiplier
  final double? height;

  const AppText(
    this.text, {
    super.key,
    this.preset = TextPreset.bodyMedium,
    this.style,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
    this.decoration,
    this.height,
  });

  // Named constructors for each text preset
  const AppText.displayLarge(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
    this.decoration,
    this.height,
  }) : preset = TextPreset.displayLarge;

  const AppText.displayMedium(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
    this.decoration,
    this.height,
  }) : preset = TextPreset.displayMedium;

  const AppText.displaySmall(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
    this.decoration,
    this.height,
  }) : preset = TextPreset.displaySmall;

  const AppText.headingLarge(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
    this.decoration,
    this.height,
  }) : preset = TextPreset.headingLarge;

  const AppText.headingMedium(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
    this.decoration,
    this.height,
  }) : preset = TextPreset.headingMedium;

  const AppText.headingSmall(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
    this.decoration,
    this.height,
  }) : preset = TextPreset.headingSmall;

  const AppText.titleLarge(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
    this.decoration,
    this.height,
  }) : preset = TextPreset.titleLarge;

  const AppText.titleMedium(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
    this.decoration,
    this.height,
  }) : preset = TextPreset.titleMedium;

  const AppText.titleSmall(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
    this.decoration,
    this.height,
  }) : preset = TextPreset.titleSmall;

  const AppText.bodyLarge(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
    this.decoration,
    this.height,
  }) : preset = TextPreset.bodyLarge;

  const AppText.bodyMedium(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
    this.decoration,
    this.height,
  }) : preset = TextPreset.bodyMedium;

  const AppText.bodySmall(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
    this.decoration,
    this.height,
  }) : preset = TextPreset.bodySmall;

  const AppText.labelLarge(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
    this.decoration,
    this.height,
  }) : preset = TextPreset.labelLarge;

  const AppText.labelMedium(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
    this.decoration,
    this.height,
  }) : preset = TextPreset.labelMedium;

  const AppText.labelSmall(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
    this.decoration,
    this.height,
  }) : preset = TextPreset.labelSmall;

  const AppText.caption(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
    this.decoration,
    this.height,
  }) : preset = TextPreset.caption;

  const AppText.button(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
    this.decoration,
    this.height,
  }) : preset = TextPreset.button;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDarkMode ? Colors.white : Colors.black87;

    // Get the base style with default characteristics for this preset
    TextStyle getBaseStyle() {
      switch (preset) {
        case TextPreset.displayLarge:
          return AppTextStyles.displayLarge();
        case TextPreset.displayMedium:
          return AppTextStyles.displayMedium();
        case TextPreset.displaySmall:
          return AppTextStyles.displaySmall();
        case TextPreset.headingLarge:
          return AppTextStyles.headingLarge();
        case TextPreset.headingMedium:
          return AppTextStyles.headingMedium();
        case TextPreset.headingSmall:
          return AppTextStyles.headingSmall();
        case TextPreset.titleLarge:
          return AppTextStyles.titleLarge();
        case TextPreset.titleMedium:
          return AppTextStyles.titleMedium();
        case TextPreset.titleSmall:
          return AppTextStyles.titleSmall();
        case TextPreset.bodyLarge:
          return AppTextStyles.bodyLarge();
        case TextPreset.bodyMedium:
          return AppTextStyles.bodyMedium();
        case TextPreset.bodySmall:
          return AppTextStyles.bodySmall();
        case TextPreset.labelLarge:
          return AppTextStyles.labelLarge();
        case TextPreset.labelMedium:
          return AppTextStyles.labelMedium();
        case TextPreset.labelSmall:
          return AppTextStyles.labelSmall();
        case TextPreset.caption:
          return AppTextStyles.caption();
        case TextPreset.button:
          return AppTextStyles.button();
      }
    }

    // First get the base style with default characteristics
    TextStyle baseStyle = getBaseStyle();

    // Then apply only the custom properties that are specified
    List<TextStyle> stylesToMerge = [baseStyle];

    // Apply color if specified
    if (color != null) {
      stylesToMerge.add(TextStyle(color: color));
    }

    // Apply fontWeight if specified
    if (fontWeight != null) {
      stylesToMerge.add(TextStyle(fontWeight: fontWeight));
    }

    // Apply height if specified
    if (height != null) {
      stylesToMerge.add(TextStyle(height: height));
    }

    // Apply decoration if specified
    if (decoration != null) {
      stylesToMerge.add(TextStyle(decoration: decoration));
    }

    // Merge custom style if provided
    if (style != null) {
      stylesToMerge.add(style!);
    }

    // Merge all styles
    final finalStyle = stylesToMerge.fold<TextStyle>(
        baseStyle, (previousStyle, style) => previousStyle.merge(style));

    return Text(
      text,
      style: finalStyle,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      softWrap: softWrap,
    );
  }
}
