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

  const SecondaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isFullWidth = true,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.size = ButtonSize.medium,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ButtonBase(
      text: text,
      onPressed: onPressed,
      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
      textColor: isDarkMode ? Colors.white : Colors.black87,
      isFullWidth: isFullWidth,
      isLoading: isLoading,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      size: size,
    );
  }
}
