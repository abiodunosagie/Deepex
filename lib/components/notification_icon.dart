import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../constants/app_colors.dart';

// Reusable notification icon component with theme support
class NotificationIcon extends StatelessWidget {
  final bool hasNotifications;
  final VoidCallback? onPressed;
  final double size;
  final Color? color;

  const NotificationIcon({
    super.key,
    required this.hasNotifications,
    this.onPressed,
    this.size = 28,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            Iconsax.notification,
            size: size,
            color: color ??
                (isDarkMode
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary),
          ),
        ),
        if (hasNotifications)
          Positioned(
            top: 11,
            right: 12,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 1.5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
