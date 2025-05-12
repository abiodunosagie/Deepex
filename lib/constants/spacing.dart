import 'package:deepex/constants/size_constants.dart';
import 'package:flutter/material.dart';

/// A widget that provides standardized spacing
///
/// Usage:
/// - Vertical space: Spacing.vertical(Sizes.m)
/// - Horizontal space: Spacing.horizontal(Sizes.s)
/// - Specific values: Spacing(width: 10, height: 20)
/// - Predefined sizes: Spacing.verticalS, Spacing.horizontalM, etc.
class Spacing extends StatelessWidget {
  /// Width of the spacing
  final double? width;

  /// Height of the spacing
  final double? height;

  /// Creates spacing with custom dimensions
  const Spacing({
    super.key,
    this.width,
    this.height,
  });

  /// Creates vertical spacing with the given height
  const Spacing.vertical(double this.height, {super.key}) : width = 0;

  /// Creates horizontal spacing with the given width
  const Spacing.horizontal(double this.width, {super.key}) : height = 0;

  // Predefined vertical spacings
  static const Spacing verticalXS2 = Spacing.vertical(Sizes.xs2);
  static const Spacing verticalXS = Spacing.vertical(Sizes.xs);
  static const Spacing verticalS = Spacing.vertical(Sizes.s);
  static const Spacing verticalSM = Spacing.vertical(Sizes.sm);
  static const Spacing verticalM = Spacing.vertical(Sizes.m);
  static const Spacing verticalML = Spacing.vertical(Sizes.ml);
  static const Spacing verticalL = Spacing.vertical(Sizes.l);
  static const Spacing verticalXL = Spacing.vertical(Sizes.xl);
  static const Spacing verticalXXL = Spacing.vertical(Sizes.xxl);
  static const Spacing verticalXXXL = Spacing.vertical(Sizes.xxxl);

  // Predefined horizontal spacings
  static const Spacing horizontalXS2 = Spacing.horizontal(Sizes.xs2);
  static const Spacing horizontalXS = Spacing.horizontal(Sizes.xs);
  static const Spacing horizontalS = Spacing.horizontal(Sizes.s);
  static const Spacing horizontalSM = Spacing.horizontal(Sizes.sm);
  static const Spacing horizontalM = Spacing.horizontal(Sizes.m);
  static const Spacing horizontalML = Spacing.horizontal(Sizes.ml);
  static const Spacing horizontalL = Spacing.horizontal(Sizes.l);
  static const Spacing horizontalXL = Spacing.horizontal(Sizes.xl);
  static const Spacing horizontalXXL = Spacing.horizontal(Sizes.xxl);
  static const Spacing horizontalXXXL = Spacing.horizontal(Sizes.xxxl);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}
