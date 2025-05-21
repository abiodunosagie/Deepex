// lib/screens/notifications_screen.dart
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../constants/padding.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'type': 'transaction',
      'title': 'Transfer Successful',
      'description': 'You sent ₦50,000 to John Doe',
      'time': DateTime.now().subtract(const Duration(minutes: 5)),
      'isRead': false,
      'actionable': true,
      'data': {
        'amount': '₦50,000',
        'recipient': 'John Doe',
        'transactionId': 'TRX123456789',
      },
      'icon': Iconsax.arrow_up_1,
      'color': 'success',
    },
    {
      'id': '2',
      'type': 'promo',
      'title': 'Weekend Cashback Offer',
      'description': 'Get 5% cashback on all transactions this weekend',
      'time': DateTime.now().subtract(const Duration(hours: 3)),
      'isRead': false,
      'actionable': true,
      'data': {
        'promoCode': 'WEEKEND5',
        'expiry': DateTime.now().add(const Duration(days: 2)),
      },
      'icon': Iconsax.discount_shape,
      'color': 'secondary',
    },
    {
      'id': '3',
      'type': 'security',
      'title': 'New Device Login',
      'description': 'Your account was accessed from a new device in Lagos',
      'time': DateTime.now().subtract(const Duration(hours: 6)),
      'isRead': true,
      'actionable': true,
      'data': {
        'device': 'iPhone 15 Pro',
        'location': 'Lagos, Nigeria',
        'ip': '192.168.1.1',
      },
      'icon': Iconsax.security,
      'color': 'warning',
    },
    {
      'id': '4',
      'type': 'account',
      'title': 'Profile Updated',
      'description': 'Your profile information was updated successfully',
      'time': DateTime.now().subtract(const Duration(hours: 23)),
      'isRead': true,
      'actionable': false,
      'data': {},
      'icon': Iconsax.user_edit,
      'color': 'primary',
    },
    {
      'id': '5',
      'type': 'transaction',
      'title': 'Payment Received',
      'description': 'You received ₦25,000 from Sarah Johnson',
      'time': DateTime.now().subtract(const Duration(days: 1, hours: 6)),
      'isRead': true,
      'actionable': true,
      'data': {
        'amount': '₦25,000',
        'sender': 'Sarah Johnson',
        'transactionId': 'TRX987654321',
      },
      'icon': Iconsax.arrow_down_1,
      'color': 'success',
    },
    {
      'id': '6',
      'type': 'system',
      'title': 'App Update Available',
      'description':
          'A new version of the app is available with exciting features',
      'time': DateTime.now().subtract(const Duration(days: 2)),
      'isRead': true,
      'actionable': true,
      'data': {
        'version': '2.1.0',
        'size': '15 MB',
      },
      'icon': Iconsax.refresh,
      'color': 'info',
    },
    {
      'id': '7',
      'type': 'transaction',
      'title': 'Airtime Purchase',
      'description': 'You purchased ₦2,000 airtime for +234 8123456789',
      'time': DateTime.now().subtract(const Duration(days: 3)),
      'isRead': true,
      'actionable': false,
      'data': {
        'amount': '₦2,000',
        'phone': '+234 8123456789',
        'provider': 'MTN',
      },
      'icon': Iconsax.mobile,
      'color': 'airtime',
    },
    {
      'id': '8',
      'type': 'security',
      'title': 'Password Changed',
      'description': 'Your account password was changed successfully',
      'time': DateTime.now().subtract(const Duration(days: 5)),
      'isRead': true,
      'actionable': false,
      'data': {},
      'icon': Iconsax.lock_1,
      'color': 'primary',
    },
  ];

  String _filterType = 'all';
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Animation for empty state
  bool _showEmptyState = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();

    // Simulate loading data
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Helper function to get notification counts
  int get _unreadCount => _notifications.where((n) => !n['isRead']).length;

  // Group notifications by date
  Map<String, List<Map<String, dynamic>>> _groupNotificationsByDate() {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    // Filter notifications if needed
    var filteredNotifications = _notifications;
    if (_filterType != 'all') {
      filteredNotifications =
          _notifications.where((n) => n['type'] == _filterType).toList();
    }

    // If empty after filtering, show empty state
    if (filteredNotifications.isEmpty) {
      _showEmptyState = true;
      return {};
    }

    _showEmptyState = false;

    for (var notification in filteredNotifications) {
      final DateTime time = notification['time'] as DateTime;
      final DateTime now = DateTime.now();
      final DateTime today = DateTime(now.year, now.month, now.day);
      final DateTime yesterday = today.subtract(const Duration(days: 1));

      String group;

      if (time.isAfter(today)) {
        group = 'Today';
      } else if (time.isAfter(yesterday)) {
        group = 'Yesterday';
      } else if (time.isAfter(today.subtract(const Duration(days: 7)))) {
        group = 'This Week';
      } else {
        group = 'Earlier';
      }

      if (!grouped.containsKey(group)) {
        grouped[group] = [];
      }

      grouped[group]!.add(notification);
    }

    // Sort each group by time
    grouped.forEach((key, value) {
      value.sort(
          (a, b) => (b['time'] as DateTime).compareTo(a['time'] as DateTime));
    });

    return grouped;
  }

  // Format time
  String _formatTime(DateTime time) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime yesterday = today.subtract(const Duration(days: 1));

    if (time.isAfter(today)) {
      return DateFormat('h:mm a').format(time);
    } else if (time.isAfter(yesterday)) {
      return 'Yesterday, ${DateFormat('h:mm a').format(time)}';
    } else {
      return DateFormat('MMM d, h:mm a').format(time);
    }
  }

  // Get color based on notification type
  Color _getNotificationColor(String colorKey, bool isDarkMode) {
    switch (colorKey) {
      case 'success':
        return isDarkMode ? AppColors.successDarkMode : AppColors.success;
      case 'warning':
        return isDarkMode ? AppColors.warningDarkMode : AppColors.warning;
      case 'error':
        return isDarkMode ? AppColors.errorDarkMode : AppColors.error;
      case 'info':
        return isDarkMode ? AppColors.infoDarkMode : AppColors.info;
      case 'primary':
        return isDarkMode ? AppColors.primaryLight : AppColors.primary;
      case 'secondary':
        return isDarkMode ? AppColors.secondaryLight : AppColors.secondary;
      case 'airtime':
        return isDarkMode ? AppColors.airtimeDark : AppColors.airtime;
      default:
        return isDarkMode ? AppColors.primaryLight : AppColors.primary;
    }
  }

  // Get background color based on notification type
  Color _getNotificationBgColor(String colorKey, bool isDarkMode) {
    switch (colorKey) {
      case 'success':
        return isDarkMode
            ? AppColors.successDarkModeBackground
            : AppColors.successLight;
      case 'warning':
        return isDarkMode
            ? AppColors.warningDarkModeBackground
            : AppColors.warningLight;
      case 'error':
        return isDarkMode
            ? AppColors.errorDarkModeBackground
            : AppColors.errorLight;
      case 'info':
        return isDarkMode
            ? AppColors.infoDarkModeBackground
            : AppColors.infoLight;
      case 'primary':
        return isDarkMode
            ? AppColors.primaryDark.withOpacity(0.2)
            : AppColors.primaryLightest;
      case 'secondary':
        return isDarkMode
            ? AppColors.secondaryDarker.withOpacity(0.2)
            : AppColors.secondaryLightest;
      case 'airtime':
        return isDarkMode
            ? AppColors.airtimeDarkBackground
            : AppColors.airtimeLight;
      default:
        return isDarkMode
            ? AppColors.primaryDark.withOpacity(0.2)
            : AppColors.primaryLightest;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define UI colors based on theme mode
    final primaryTextColor = isDarkMode
        ? AppColors.textDarkHighEmphasis
        : AppColors.textLightPrimary;
    final secondaryTextColor = isDarkMode
        ? AppColors.textDarkMediumEmphasis
        : AppColors.textLightSecondary;
    final cardColor =
        isDarkMode ? AppColors.backgroundDarkSurface1 : Colors.white;
    final backgroundColor =
        isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight;
    final dividerColor =
        isDarkMode ? AppColors.borderDarkSubtle : Colors.grey.withOpacity(0.1);
    final accentColor = isDarkMode ? AppColors.primaryLight : AppColors.primary;

    // Group notifications
    final groupedNotifications = _groupNotificationsByDate();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const AppText(
          'Notifications',
          preset: TextPreset.titleLarge,
          fontWeight: FontWeight.w600,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: primaryTextColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_notifications.isNotEmpty)
            IconButton(
              icon: Icon(
                Iconsax.setting_2,
                color: accentColor,
                size: 22,
              ),
              onPressed: () {
                _showNotificationSettingsSheet(context, isDarkMode);
              },
            ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState(isDarkMode)
          : Column(
              children: [
                // Notification stats and filter
                AnimatedOpacity(
                  opacity: _isLoading ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  child: AppPadding.horizontal(
                    value: 20,
                    child: Column(
                      children: [
                        _buildNotificationStats(primaryTextColor,
                            secondaryTextColor, accentColor, isDarkMode),
                        Spacing.verticalM,
                        if (_notifications.isNotEmpty)
                          _buildFilterChips(cardColor, primaryTextColor,
                              secondaryTextColor, accentColor, isDarkMode),
                      ],
                    ),
                  ),
                ),

                Spacing.verticalM,

                // Notification list or empty state
                Expanded(
                  child: _showEmptyState
                      ? _buildEmptyState(isDarkMode, accentColor,
                          primaryTextColor, secondaryTextColor)
                      : _notifications.isEmpty
                          ? _buildNoNotificationsState(isDarkMode, accentColor,
                              primaryTextColor, secondaryTextColor)
                          : ListView.builder(
                              itemCount: groupedNotifications.length,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                final String group =
                                    groupedNotifications.keys.elementAt(index);
                                final List<Map<String, dynamic>> notifications =
                                    groupedNotifications[group]!;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, bottom: 8, top: 16),
                                      child: AppText.labelMedium(
                                        group,
                                        color: secondaryTextColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    ...notifications.map((notification) {
                                      return _buildNotificationCard(
                                        notification: notification,
                                        cardColor: cardColor,
                                        primaryTextColor: primaryTextColor,
                                        secondaryTextColor: secondaryTextColor,
                                        dividerColor: dividerColor,
                                        isDarkMode: isDarkMode,
                                      );
                                    }).toList(),
                                  ],
                                );
                              },
                            ),
                ),
              ],
            ),
      bottomNavigationBar: _notifications.isNotEmpty
          ? SafeArea(
              child: AnimatedOpacity(
                opacity: _isLoading ? 0 : 1,
                duration: const Duration(milliseconds: 300),
                child: AppPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: ElevatedButton(
                    onPressed: () {
                      // Mark all as read
                      setState(() {
                        for (var notification in _notifications) {
                          notification['isRead'] = true;
                        }
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              const Text('All notifications marked as read'),
                          backgroundColor: isDarkMode
                              ? AppColors.successDarkMode
                              : AppColors.success,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode
                          ? AppColors.backgroundDarkSurface2
                          : AppColors.backgroundLightSecondary,
                      foregroundColor: accentColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: accentColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                    ),
                    child: AppText.button(
                      'Mark All as Read',
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  // Loading state with shimmer effect
  Widget _buildLoadingState(bool isDarkMode) {
    final shimmerBaseColor =
        isDarkMode ? AppColors.shimmerBaseDark : AppColors.shimmerBase;
    final shimmerHighlightColor = isDarkMode
        ? AppColors.shimmerHighlightDark
        : AppColors.shimmerHighlight;

    return AppPadding.horizontal(
      value: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shimmer for stats
          _buildShimmerContainer(
            height: 80,
            width: double.infinity,
            baseColor: shimmerBaseColor,
            highlightColor: shimmerHighlightColor,
          ),
          Spacing.verticalM,

          // Shimmer for filter
          Row(
            children: [
              _buildShimmerContainer(
                height: 36,
                width: 80,
                baseColor: shimmerBaseColor,
                highlightColor: shimmerHighlightColor,
                borderRadius: 18,
              ),
              Spacing.horizontalXS,
              _buildShimmerContainer(
                height: 36,
                width: 100,
                baseColor: shimmerBaseColor,
                highlightColor: shimmerHighlightColor,
                borderRadius: 18,
              ),
              Spacing.horizontalXS,
              _buildShimmerContainer(
                height: 36,
                width: 90,
                baseColor: shimmerBaseColor,
                highlightColor: shimmerHighlightColor,
                borderRadius: 18,
              ),
            ],
          ),
          Spacing.verticalM,

          // Shimmer for section header
          _buildShimmerContainer(
            height: 20,
            width: 80,
            baseColor: shimmerBaseColor,
            highlightColor: shimmerHighlightColor,
          ),
          Spacing.verticalM,

          // Shimmer for notification cards
          for (int i = 0; i < 3; i++) ...[
            _buildShimmerContainer(
              height: 100,
              width: double.infinity,
              baseColor: shimmerBaseColor,
              highlightColor: shimmerHighlightColor,
            ),
            Spacing.verticalM,
          ],
        ],
      ),
    );
  }

  Widget _buildShimmerContainer({
    required double height,
    required double width,
    required Color baseColor,
    required Color highlightColor,
    double borderRadius = 12,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            baseColor,
            highlightColor,
            baseColor,
          ],
          stops: const [0.1, 0.5, 0.9],
        ),
      ),
    );
  }

  // Notification stats section
  Widget _buildNotificationStats(
    Color primaryTextColor,
    Color secondaryTextColor,
    Color accentColor,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isDarkMode
            ? AppColors.darkBrandGradient
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accentColor.withOpacity(0.05),
                  AppColors.secondaryLighter.withOpacity(0.2),
                ],
              ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Icon with circle background
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.secondaryDark.withOpacity(0.2)
                  : AppColors.secondaryLightest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconsax.notification,
              color:
                  isDarkMode ? AppColors.secondaryLight : AppColors.secondary,
              size: 20,
            ),
          ),
          Spacing.horizontalM,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.titleMedium(
                _unreadCount > 0
                    ? '$_unreadCount unread notification${_unreadCount > 1 ? 's' : ''}'
                    : 'All caught up!',
                color: primaryTextColor,
              ),
              Spacing.verticalXS2,
              AppText.bodySmall(
                _unreadCount > 0
                    ? 'Stay updated with your activity'
                    : 'You have no new notifications',
                color: secondaryTextColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Filter chips section
  Widget _buildFilterChips(
    Color cardColor,
    Color primaryTextColor,
    Color secondaryTextColor,
    Color accentColor,
    bool isDarkMode,
  ) {
    final filterTypes = [
      {'id': 'all', 'name': 'All', 'icon': Iconsax.notification},
      {'id': 'transaction', 'name': 'Transactions', 'icon': Iconsax.wallet_3},
      {'id': 'security', 'name': 'Security', 'icon': Iconsax.shield_tick},
      {'id': 'promo', 'name': 'Promotions', 'icon': Iconsax.discount_shape},
      {'id': 'system', 'name': 'System', 'icon': Iconsax.setting_2},
    ];

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: filterTypes.map((filter) {
          final isSelected = _filterType == filter['id'];
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    filter['icon'] as IconData,
                    size: 16,
                    color: isSelected
                        ? isDarkMode
                            ? Colors.black
                            : Colors.white
                        : isDarkMode
                            ? AppColors.textDarkMediumEmphasis
                            : accentColor,
                  ),
                  Spacing.horizontalXS,
                  AppText.labelSmall(
                    filter['name'] as String,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected
                        ? isDarkMode
                            ? Colors.black
                            : Colors.white
                        : isDarkMode
                            ? AppColors.textDarkMediumEmphasis
                            : accentColor,
                  ),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _filterType = filter['id'] as String;
                });
              },
              backgroundColor: isDarkMode
                  ? AppColors.backgroundDarkSurface2
                  : AppColors.backgroundLightSecondary,
              selectedColor: isSelected
                  ? accentColor
                  : isDarkMode
                      ? AppColors.backgroundDarkSurface2
                      : AppColors.backgroundLightSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? accentColor : Colors.transparent,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Notification card
  Widget _buildNotificationCard({
    required Map<String, dynamic> notification,
    required Color cardColor,
    required Color primaryTextColor,
    required Color secondaryTextColor,
    required Color dividerColor,
    required bool isDarkMode,
  }) {
    final iconColor =
        _getNotificationColor(notification['color'] as String, isDarkMode);
    final bgColor =
        _getNotificationBgColor(notification['color'] as String, isDarkMode);
    final isRead = notification['isRead'] as bool;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // Mark as read if unread
          if (!isRead) {
            setState(() {
              notification['isRead'] = true;
            });
          }

          // Show notification details if actionable
          if (notification['actionable'] as bool) {
            _showNotificationDetailsSheet(context, notification, isDarkMode);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Dismissible(
          key: Key(notification['id'] as String),
          direction: DismissDirection.endToStart,
          background: Container(
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.errorDarkModeBackground
                  : AppColors.errorLight,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.trash,
                  color: isDarkMode ? AppColors.errorDarkMode : AppColors.error,
                  size: 24,
                ),
                Spacing.verticalXS,
                AppText.bodySmall(
                  'Delete',
                  color: isDarkMode ? AppColors.errorDarkMode : AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          onDismissed: (direction) {
            setState(() {
              _notifications.removeWhere((n) => n['id'] == notification['id']);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Notification deleted'),
                backgroundColor:
                    isDarkMode ? AppColors.infoLight : AppColors.info,
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  textColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      _notifications.add(notification);
                    });
                  },
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDarkMode ? 0.1 : 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
              border: isRead
                  ? null
                  : Border.all(
                      color: iconColor.withOpacity(0.3),
                      width: 1.5,
                    ),
            ),
            child: AppPadding.all(
              value: 16,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notification icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: bgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      notification['icon'] as IconData,
                      color: iconColor,
                      size: 20,
                    ),
                  ),
                  Spacing.horizontalM,

                  // Notification content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Title with unread indicator
                            Expanded(
                              child: Row(
                                children: [
                                  // Unread indicator dot
                                  if (!isRead) ...[
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: iconColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Spacing.horizontalXS,
                                  ],

                                  // Title with ellipsis
                                  Expanded(
                                    child: AppText.titleSmall(
                                      notification['title'] as String,
                                      fontWeight: isRead
                                          ? FontWeight.w500
                                          : FontWeight.w600,
                                      color: primaryTextColor,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Time
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: AppText.caption(
                                _formatTime(notification['time'] as DateTime),
                                color: secondaryTextColor,
                              ),
                            ),
                          ],
                        ),

                        Spacing.verticalXS,

                        // Description
                        AppText.bodySmall(
                          notification['description'] as String,
                          color: secondaryTextColor,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        Spacing.verticalXS,

                        // Action indicator if actionable
                        if (notification['actionable'] as bool)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Iconsax.arrow_right_3,
                                size: 14,
                                color: iconColor,
                              ),
                              Spacing.horizontalXS2,
                              AppText.caption(
                                'View Details',
                                color: iconColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Empty state when no notifications match filter
  Widget _buildEmptyState(bool isDarkMode, Color accentColor,
      Color primaryTextColor, Color secondaryTextColor) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: AppPadding.horizontal(
          value: 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.backgroundDarkSurface2
                      : AppColors.backgroundLightSecondary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.filter_search,
                  size: 40,
                  color: isDarkMode
                      ? AppColors.secondaryLight
                      : AppColors.secondary,
                ),
              ),
              Spacing.verticalL,
              AppText.headingSmall(
                'No matching notifications',
                color: primaryTextColor,
                textAlign: TextAlign.center,
              ),
              Spacing.verticalS,
              AppText.bodyMedium(
                'There are no ${_filterType == "all" ? "" : _filterType} notifications. Try another filter or check back later.',
                color: secondaryTextColor,
                textAlign: TextAlign.center,
              ),
              Spacing.verticalL,
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _filterType = 'all';
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const AppText.button(
                  'Show All Notifications',
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // No notifications state
  Widget _buildNoNotificationsState(bool isDarkMode, Color accentColor,
      Color primaryTextColor, Color secondaryTextColor) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: AppPadding.horizontal(
          value: 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.backgroundDarkSurface2
                      : AppColors.backgroundLightSecondary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.notification,
                  size: 40,
                  color: isDarkMode
                      ? AppColors.secondaryLight
                      : AppColors.secondary,
                ),
              ),
              Spacing.verticalL,
              AppText.headingSmall(
                'No Notifications',
                color: primaryTextColor,
                textAlign: TextAlign.center,
              ),
              Spacing.verticalS,
              AppText.bodyMedium(
                'You don\'t have any notifications yet. We\'ll notify you about important updates and activity.',
                color: secondaryTextColor,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Notification details bottom sheet
  void _showNotificationDetailsSheet(BuildContext context,
      Map<String, dynamic> notification, bool isDarkMode) {
    final textColor = isDarkMode
        ? AppColors.textDarkHighEmphasis
        : AppColors.textLightPrimary;
    final secondaryTextColor = isDarkMode
        ? AppColors.textDarkMediumEmphasis
        : AppColors.textLightSecondary;
    final backgroundColor =
        isDarkMode ? AppColors.backgroundDarkSurface1 : Colors.white;
    final iconColor =
        _getNotificationColor(notification['color'] as String, isDarkMode);
    final bgColor =
        _getNotificationBgColor(notification['color'] as String, isDarkMode);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.borderDarkSubtle
                    : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            Spacing.verticalL,

            // Notification icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                notification['icon'] as IconData,
                color: iconColor,
                size: 28,
              ),
            ),
            Spacing.verticalM,

            // Notification title
            AppText.headingMedium(
              notification['title'] as String,
              color: textColor,
              textAlign: TextAlign.center,
            ),
            Spacing.verticalXS,

            // Notification time
            AppText.bodyMedium(
              DateFormat('MMMM d, yyyy • h:mm a')
                  .format(notification['time'] as DateTime),
              color: secondaryTextColor,
              textAlign: TextAlign.center,
            ),
            Spacing.verticalM,

            // Notification description
            AppText.bodyLarge(
              notification['description'] as String,
              color: textColor,
              textAlign: TextAlign.center,
            ),
            Spacing.verticalL,

            // Additional data based on notification type
            _buildNotificationDetails(
                notification, textColor, secondaryTextColor, isDarkMode),

            Spacing.verticalL,

            // Action button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Handle the action based on notification type
                _handleNotificationAction(notification);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: iconColor,
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: AppText.button(
                _getActionButtonText(notification['type'] as String),
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacing.verticalM,

            // Dismiss button
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: AppText.button(
                'Dismiss',
                color: secondaryTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Notification settings bottom sheet
  void _showNotificationSettingsSheet(BuildContext context, bool isDarkMode) {
    final textColor = isDarkMode
        ? AppColors.textDarkHighEmphasis
        : AppColors.textLightPrimary;
    final secondaryTextColor = isDarkMode
        ? AppColors.textDarkMediumEmphasis
        : AppColors.textLightSecondary;
    final backgroundColor =
        isDarkMode ? AppColors.backgroundDarkSurface1 : Colors.white;
    final accentColor = isDarkMode ? AppColors.primaryLight : AppColors.primary;

    // Settings categories
    final List<Map<String, dynamic>> categories = [
      {
        'title': 'Transaction Notifications',
        'description':
            'Receive alerts for transfers, payments, and other transactions',
        'icon': Iconsax.wallet_3,
        'enabled': true,
      },
      {
        'title': 'Security Alerts',
        'description': 'Important alerts about your account security',
        'icon': Iconsax.shield_tick,
        'enabled': true,
      },
      {
        'title': 'Promotional Offers',
        'description': 'Updates about cashbacks, discounts, and special offers',
        'icon': Iconsax.discount_shape,
        'enabled': true,
      },
      {
        'title': 'System Updates',
        'description': 'Information about app updates and maintenance',
        'icon': Iconsax.refresh,
        'enabled': true,
      },
    ];

    bool pushNotificationsEnabled = true;
    bool emailNotificationsEnabled = true;
    bool smsNotificationsEnabled = false;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.borderDarkSubtle
                        : Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),

                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: AppText.headingMedium(
                    'Notification Settings',
                    color: textColor,
                  ),
                ),

                // Divider
                Divider(
                  color: isDarkMode
                      ? AppColors.borderDarkSubtle
                      : Colors.grey.withOpacity(0.2),
                ),

                // Communication Channels Section
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AppText.titleMedium(
                      'Communication Channels',
                      color: textColor,
                    ),
                  ),
                ),

                // Push Notifications Toggle
                _buildSettingsToggle(
                  title: 'Push Notifications',
                  subtitle: 'Receive notifications on your device',
                  icon: Iconsax.notification,
                  value: pushNotificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      pushNotificationsEnabled = value;
                    });
                  },
                  accentColor: accentColor,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),

                // Email Notifications Toggle
                _buildSettingsToggle(
                  title: 'Email Notifications',
                  subtitle: 'Receive notifications via email',
                  icon: Iconsax.message,
                  value: emailNotificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      emailNotificationsEnabled = value;
                    });
                  },
                  accentColor: accentColor,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),

                // SMS Notifications Toggle
                _buildSettingsToggle(
                  title: 'SMS Notifications',
                  subtitle: 'Receive notifications via SMS',
                  icon: Iconsax.sms,
                  value: smsNotificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      smsNotificationsEnabled = value;
                    });
                  },
                  accentColor: accentColor,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),

                // Divider
                Divider(
                  color: isDarkMode
                      ? AppColors.borderDarkSubtle
                      : Colors.grey.withOpacity(0.2),
                ),

                // Notification Categories Section
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AppText.titleMedium(
                      'Notification Categories',
                      color: textColor,
                    ),
                  ),
                ),

                // Render each category
                ...categories.map((category) {
                  return _buildSettingsToggle(
                    title: category['title'] as String,
                    subtitle: category['description'] as String,
                    icon: category['icon'] as IconData,
                    value: category['enabled'] as bool,
                    onChanged: (value) {
                      setState(() {
                        category['enabled'] = value;
                      });
                    },
                    accentColor: accentColor,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                  );
                }).toList(),

                // Save Button
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Here you would save the notification settings
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Notification settings saved'),
                          backgroundColor: isDarkMode
                              ? AppColors.successDarkMode
                              : AppColors.success,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const AppText.button(
                      'Save Settings',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Settings toggle widget
  Widget _buildSettingsToggle({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
    required Color accentColor,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 20,
            ),
          ),
          Spacing.horizontalM,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.titleSmall(
                  title,
                  color: textColor,
                ),
                AppText.bodySmall(
                  subtitle,
                  color: secondaryTextColor,
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: accentColor,
          ),
        ],
      ),
    );
  }

  // Build notification details based on type
  Widget _buildNotificationDetails(
    Map<String, dynamic> notification,
    Color textColor,
    Color secondaryTextColor,
    bool isDarkMode,
  ) {
    final type = notification['type'] as String;
    final data = notification['data'] as Map<String, dynamic>;
    final accentColor =
        _getNotificationColor(notification['color'] as String, isDarkMode);

    Widget detailsWidget;

    switch (type) {
      case 'transaction':
        final amount = data['amount'] as String;
        final recipient =
            data.containsKey('recipient') ? data['recipient'] as String : null;
        final sender =
            data.containsKey('sender') ? data['sender'] as String : null;
        final transactionId = data['transactionId'] as String;
        final phone =
            data.containsKey('phone') ? data['phone'] as String : null;
        final provider =
            data.containsKey('provider') ? data['provider'] as String : null;

        detailsWidget = Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.backgroundDarkSurface2
                : AppColors.backgroundLightSecondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildDetailRow(
                'Amount',
                amount,
                textColor,
                secondaryTextColor,
                valueColor: accentColor,
                valueFontWeight: FontWeight.w600,
              ),
              if (recipient != null)
                _buildDetailRow(
                  'Recipient',
                  recipient,
                  textColor,
                  secondaryTextColor,
                ),
              if (sender != null)
                _buildDetailRow(
                  'Sender',
                  sender,
                  textColor,
                  secondaryTextColor,
                ),
              if (phone != null)
                _buildDetailRow(
                  'Phone Number',
                  phone,
                  textColor,
                  secondaryTextColor,
                ),
              if (provider != null)
                _buildDetailRow(
                  'Provider',
                  provider,
                  textColor,
                  secondaryTextColor,
                ),
              _buildDetailRow(
                'Transaction ID',
                transactionId,
                textColor,
                secondaryTextColor,
              ),
              _buildDetailRow(
                'Date & Time',
                DateFormat('MMM d, yyyy • h:mm a')
                    .format(notification['time'] as DateTime),
                textColor,
                secondaryTextColor,
              ),
            ],
          ),
        );
        break;

      case 'promo':
        final promoCode = data['promoCode'] as String;
        final expiry = data['expiry'] as DateTime;

        detailsWidget = Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.backgroundDarkSurface2
                : AppColors.backgroundLightSecondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: accentColor,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      promoCode,
                      preset: TextPreset.titleLarge,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                      style: const TextStyle(letterSpacing: 1.5),
                    ),
                    Spacing.horizontalS,
                    Icon(
                      Iconsax.copy,
                      size: 16,
                      color: accentColor,
                    ),
                  ],
                ),
              ),
              Spacing.verticalM,
              _buildDetailRow(
                'Valid Until',
                DateFormat('MMMM d, yyyy').format(expiry),
                textColor,
                secondaryTextColor,
              ),
              _buildDetailRow(
                'Status',
                DateTime.now().isBefore(expiry) ? 'Active' : 'Expired',
                textColor,
                secondaryTextColor,
                valueColor: DateTime.now().isBefore(expiry)
                    ? (isDarkMode
                        ? AppColors.successDarkMode
                        : AppColors.success)
                    : (isDarkMode ? AppColors.errorDarkMode : AppColors.error),
              ),
              _buildDetailRow(
                'Received On',
                DateFormat('MMM d, yyyy • h:mm a')
                    .format(notification['time'] as DateTime),
                textColor,
                secondaryTextColor,
              ),
            ],
          ),
        );
        break;

      case 'security':
        if (data.containsKey('device')) {
          // Device login notification
          final device = data['device'] as String;
          final location = data['location'] as String;
          final ip = data['ip'] as String;

          detailsWidget = Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.backgroundDarkSurface2
                  : AppColors.backgroundLightSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildDetailRow(
                  'Device',
                  device,
                  textColor,
                  secondaryTextColor,
                ),
                _buildDetailRow(
                  'Location',
                  location,
                  textColor,
                  secondaryTextColor,
                ),
                _buildDetailRow(
                  'IP Address',
                  ip,
                  textColor,
                  secondaryTextColor,
                ),
                _buildDetailRow(
                  'Time',
                  DateFormat('MMM d, yyyy • h:mm a')
                      .format(notification['time'] as DateTime),
                  textColor,
                  secondaryTextColor,
                ),
              ],
            ),
          );
        } else {
          // Generic security notification
          detailsWidget = Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.backgroundDarkSurface2
                  : AppColors.backgroundLightSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildDetailRow(
                  'Activity',
                  notification['title'] as String,
                  textColor,
                  secondaryTextColor,
                ),
                _buildDetailRow(
                  'Time',
                  DateFormat('MMM d, yyyy • h:mm a')
                      .format(notification['time'] as DateTime),
                  textColor,
                  secondaryTextColor,
                ),
              ],
            ),
          );
        }
        break;

      case 'system':
        // App update notification
        if (data.containsKey('version')) {
          final version = data['version'] as String;
          final size = data['size'] as String;

          detailsWidget = Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.backgroundDarkSurface2
                  : AppColors.backgroundLightSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildDetailRow(
                  'New Version',
                  version,
                  textColor,
                  secondaryTextColor,
                  valueColor: accentColor,
                  valueFontWeight: FontWeight.w600,
                ),
                _buildDetailRow(
                  'Update Size',
                  size,
                  textColor,
                  secondaryTextColor,
                ),
                _buildDetailRow(
                  'Released On',
                  DateFormat('MMM d, yyyy')
                      .format(notification['time'] as DateTime),
                  textColor,
                  secondaryTextColor,
                ),
              ],
            ),
          );
        } else {
          // Generic system notification
          detailsWidget = Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.backgroundDarkSurface2
                  : AppColors.backgroundLightSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildDetailRow(
                  'System Message',
                  notification['description'] as String,
                  textColor,
                  secondaryTextColor,
                ),
                _buildDetailRow(
                  'Time',
                  DateFormat('MMM d, yyyy • h:mm a')
                      .format(notification['time'] as DateTime),
                  textColor,
                  secondaryTextColor,
                ),
              ],
            ),
          );
        }
        break;

      default:
        // Generic detail view for other notification types
        detailsWidget = Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.backgroundDarkSurface2
                : AppColors.backgroundLightSecondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildDetailRow(
                'Message',
                notification['description'] as String,
                textColor,
                secondaryTextColor,
              ),
              _buildDetailRow(
                'Time',
                DateFormat('MMM d, yyyy • h:mm a')
                    .format(notification['time'] as DateTime),
                textColor,
                secondaryTextColor,
              ),
            ],
          ),
        );
    }

    return detailsWidget;
  }

  // Detail row for notification details
  Widget _buildDetailRow(
    String label,
    String value,
    Color textColor,
    Color secondaryTextColor, {
    Color? valueColor,
    FontWeight? valueFontWeight,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText.bodySmall(
            label,
            color: secondaryTextColor,
          ),
          AppText.bodySmall(
            value,
            fontWeight: valueFontWeight ?? FontWeight.normal,
            color: valueColor ?? textColor,
          ),
        ],
      ),
    );
  }

  // Get action button text based on notification type
  String _getActionButtonText(String type) {
    switch (type) {
      case 'transaction':
        return 'View Transaction';
      case 'promo':
        return 'Use Promotion';
      case 'security':
        return 'Review Security';
      case 'system':
        return 'Update Now';
      default:
        return 'View Details';
    }
  }

  // Handle notification action
  void _handleNotificationAction(Map<String, dynamic> notification) {
    final type = notification['type'] as String;

    // In a real app, you would navigate to the appropriate screen
    // Here we'll just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Action on ${notification['title']}'),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.primaryLight
            : AppColors.primary,
      ),
    );
  }
}
