// lib/components/secondary_button.dart (updated with backgroundColor and textColor parameters)
import 'package:flutter/material.dart';

import 'button_base.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isFullWidth;
  final bool isLoading;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final ButtonSize size;
  final Color? backgroundColor;
  final Color? textColor;

  const SecondaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isFullWidth = true,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.size = ButtonSize.medium,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Default colors based on theme
    final defaultBackgroundColor =
        isDarkMode ? Colors.grey[800] : Colors.grey[200];
    final defaultTextColor = isDarkMode ? Colors.white : Colors.black87;

    return ButtonBase(
      text: text,
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? defaultBackgroundColor,
      textColor: textColor ?? defaultTextColor,
      isFullWidth: isFullWidth,
      isLoading: isLoading,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      size: size,
    );
  }
}
