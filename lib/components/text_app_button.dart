import 'package:deepex/constants/app_colors.dart';
import 'package:flutter/material.dart';

class TextAppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? textColor;
  final bool isLoading;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  const TextAppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.textColor,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeTextColor = textColor ?? AppColors.primary;

    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: themeTextColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(themeTextColor),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leadingIcon != null) ...[
                  Icon(leadingIcon, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 8),
                  Icon(trailingIcon, size: 18),
                ],
              ],
            ),
    );
  }
}
