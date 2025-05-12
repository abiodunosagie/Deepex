import 'package:deepex/constants/app_colors.dart';
import 'package:flutter/material.dart';

import 'button_base.dart';

class OutlinedAppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isFullWidth;
  final bool isLoading;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final ButtonSize size;
  final Color? borderColor;
  final Color? textColor;

  const OutlinedAppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isFullWidth = true,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.size = ButtonSize.medium,
    this.borderColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ButtonBase(
      text: text,
      onPressed: onPressed,
      backgroundColor: Colors.transparent,
      borderColor: borderColor ?? AppColors.primary,
      textColor: textColor ?? (isDarkMode ? Colors.white : AppColors.primary),
      isFullWidth: isFullWidth,
      isLoading: isLoading,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      size: size,
    );
  }
}
