import 'package:flutter/material.dart';

enum ButtonSize {
  small,
  medium,
  large,
}

class ButtonBase extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final bool isFullWidth;
  final ButtonSize size;
  final bool isLoading;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const ButtonBase({
    Key? key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.isFullWidth = true,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.borderRadius = 12.0,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine button size dimensions
    final buttonHeight = _getButtonHeight();
    final fontSize = _getFontSize();
    final iconSize = _getIconSize();

    // Determine button padding
    final buttonPadding = padding ?? _getButtonPadding();

    // Build button based on parameters
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none,
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                height: iconSize,
                width: iconSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leadingIcon != null) ...[
                    Icon(leadingIcon, size: iconSize),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (trailingIcon != null) ...[
                    const SizedBox(width: 8),
                    Icon(trailingIcon, size: iconSize),
                  ],
                ],
              ),
      ),
    );
  }

  // Helper methods for responsive sizing
  double _getButtonHeight() {
    switch (size) {
      case ButtonSize.small:
        return 36.0;
      case ButtonSize.medium:
        return 48.0;
      case ButtonSize.large:
        return 56.0;
    }
  }

  double _getFontSize() {
    switch (size) {
      case ButtonSize.small:
        return 12.0;
      case ButtonSize.medium:
        return 14.0;
      case ButtonSize.large:
        return 16.0;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 16.0;
      case ButtonSize.medium:
        return 20.0;
      case ButtonSize.large:
        return 24.0;
    }
  }

  EdgeInsetsGeometry _getButtonPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0);
    }
  }
}
