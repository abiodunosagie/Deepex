// lib/components/primary_button.dart (updated with backgroundColor parameter)
import 'package:deepex/constants/app_colors.dart';
import 'package:flutter/material.dart';

import 'button_base.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isFullWidth;
  final bool isLoading;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final ButtonSize size;
  final Color? backgroundColor;

  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isFullWidth = true,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.size = ButtonSize.medium,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final buttonColor = backgroundColor ?? AppColors.primary;

    return ButtonBase(
      text: text,
      onPressed: onPressed,
      backgroundColor: buttonColor,
      textColor: Colors.white,
      isFullWidth: isFullWidth,
      isLoading: isLoading,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      size: size,
    );
  }
}
