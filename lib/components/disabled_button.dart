import 'package:flutter/material.dart';

import 'button_base.dart';

class DisabledButton extends StatelessWidget {
  final String text;
  final bool isFullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final ButtonSize size;

  const DisabledButton({
    Key? key,
    required this.text,
    this.isFullWidth = true,
    this.leadingIcon,
    this.trailingIcon,
    this.size = ButtonSize.medium,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ButtonBase(
      text: text,
      onPressed: null,
      // Disabled button has no onPressed callback
      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
      textColor: isDarkMode ? Colors.grey[500] : Colors.grey[600],
      isFullWidth: isFullWidth,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      size: size,
    );
  }
}
