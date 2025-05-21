// lib/screens/security_settings_screen.dart
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen>
    with SingleTickerProviderStateMixin {
  // Toggle states for switches
  bool _biometricEnabled = true;
  bool _pinEnabled = true;
  bool _twoFactorEnabled = false;
  bool _autoLogoutEnabled = true;
  bool _hideBalanceEnabled = false;

  // Animation controller for the destructive actions section
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
    final dangerColor = isDarkMode ? AppColors.errorDarkMode : AppColors.error;
    final dangerBgColor = isDarkMode
        ? AppColors.errorDarkModeBackground
        : AppColors.errorLight.withOpacity(0.2);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Security Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: primaryTextColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: primaryTextColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Security summary card
              _buildSecuritySummaryCard(
                context: context,
                isDarkMode: isDarkMode,
                cardColor: cardColor,
                accentColor: accentColor,
                textColor: primaryTextColor,
                secondaryTextColor: secondaryTextColor,
              ),

              Spacing.verticalL,

              // Authentication Section
              AppText.headingMedium('Authentication', color: primaryTextColor),
              Spacing.verticalM,
              _buildSecurityCard(
                context: context,
                cardColor: cardColor,
                dividerColor: dividerColor,
                children: [
                  _buildToggleSettingItem(
                    title: 'Biometric Authentication',
                    subtitle: 'Use fingerprint or face ID to login',
                    icon: Iconsax.finger_scan,
                    iconColor: accentColor,
                    value: _biometricEnabled,
                    onChanged: (value) =>
                        setState(() => _biometricEnabled = value),
                    isDarkMode: isDarkMode,
                    textColor: primaryTextColor,
                    secondaryTextColor: secondaryTextColor,
                    showDivider: true,
                  ),
                  _buildToggleSettingItem(
                    title: 'PIN Code Lock',
                    subtitle: 'Secure app access with a PIN',
                    icon: Iconsax.password_check,
                    iconColor: accentColor,
                    value: _pinEnabled,
                    onChanged: (value) => setState(() => _pinEnabled = value),
                    isDarkMode: isDarkMode,
                    textColor: primaryTextColor,
                    secondaryTextColor: secondaryTextColor,
                    showDivider: true,
                  ),
                  _buildNavigationSettingItem(
                    title: 'Change Password',
                    subtitle: 'Last changed 30 days ago',
                    icon: Iconsax.lock,
                    iconColor: accentColor,
                    onTap: () {
                      _showChangePasswordDialog(context, isDarkMode);
                    },
                    isDarkMode: isDarkMode,
                    textColor: primaryTextColor,
                    secondaryTextColor: secondaryTextColor,
                    showDivider: false,
                  ),
                ],
              ),

              Spacing.verticalXL,

              // Additional Security Section
              AppText.headingMedium('Advanced Security',
                  color: primaryTextColor),
              Spacing.verticalM,
              _buildSecurityCard(
                context: context,
                cardColor: cardColor,
                dividerColor: dividerColor,
                children: [
                  _buildToggleSettingItem(
                    title: 'Two-Factor Authentication',
                    subtitle: 'Add an extra layer of security',
                    icon: Iconsax.shield_tick,
                    iconColor: accentColor,
                    value: _twoFactorEnabled,
                    onChanged: (value) {
                      if (value) {
                        _show2FASetupDialog(context, isDarkMode);
                      } else {
                        setState(() => _twoFactorEnabled = false);
                      }
                    },
                    isDarkMode: isDarkMode,
                    textColor: primaryTextColor,
                    secondaryTextColor: secondaryTextColor,
                    showDivider: true,
                  ),
                  _buildToggleSettingItem(
                    title: 'Auto Logout',
                    subtitle:
                        'Automatically logout after 5 minutes of inactivity',
                    icon: Iconsax.logout,
                    iconColor: accentColor,
                    value: _autoLogoutEnabled,
                    onChanged: (value) =>
                        setState(() => _autoLogoutEnabled = value),
                    isDarkMode: isDarkMode,
                    textColor: primaryTextColor,
                    secondaryTextColor: secondaryTextColor,
                    showDivider: true,
                  ),
                  _buildToggleSettingItem(
                    title: 'Hide Balance',
                    subtitle: 'Show asterisks instead of actual balance',
                    icon: Iconsax.eye_slash,
                    iconColor: accentColor,
                    value: _hideBalanceEnabled,
                    onChanged: (value) =>
                        setState(() => _hideBalanceEnabled = value),
                    isDarkMode: isDarkMode,
                    textColor: primaryTextColor,
                    secondaryTextColor: secondaryTextColor,
                    showDivider: false,
                  ),
                ],
              ),

              Spacing.verticalXL,

              // Device Management Section
              AppText.headingMedium('Device Management',
                  color: primaryTextColor),
              Spacing.verticalM,
              _buildSecurityCard(
                context: context,
                cardColor: cardColor,
                dividerColor: dividerColor,
                children: [
                  _buildNavigationSettingItem(
                    title: 'Logged In Devices',
                    subtitle: '2 active devices',
                    icon: Iconsax.mobile,
                    iconColor: accentColor,
                    onTap: () {
                      _showDevicesDialog(context, isDarkMode);
                    },
                    isDarkMode: isDarkMode,
                    textColor: primaryTextColor,
                    secondaryTextColor: secondaryTextColor,
                    showDivider: false,
                  ),
                ],
              ),

              Spacing.verticalXL,

              // Danger Zone Section (NEW)
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Iconsax.danger,
                          size: 18,
                          color: dangerColor,
                        ),
                        Spacing.horizontalXS,
                        AppText.headingMedium('Danger Zone',
                            color: dangerColor),
                      ],
                    ),
                    Spacing.verticalM,
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: dangerColor.withOpacity(0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(isDarkMode ? 0.1 : 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildDangerSettingItem(
                            title: 'Reset App Settings',
                            subtitle: 'Reset all app settings to default',
                            icon: Iconsax.refresh,
                            iconColor: isDarkMode
                                ? AppColors.warningDarkMode
                                : AppColors.warning,
                            iconBgColor: isDarkMode
                                ? AppColors.warningDarkModeBackground
                                : AppColors.warningLight.withOpacity(0.2),
                            onTap: () {
                              _showResetSettingsDialog(context, isDarkMode);
                            },
                            isDarkMode: isDarkMode,
                            textColor: primaryTextColor,
                            secondaryTextColor: secondaryTextColor,
                            dividerColor: dividerColor,
                            showDivider: true,
                          ),
                          _buildDangerSettingItem(
                            title: 'Delete Account',
                            subtitle:
                                'Permanently delete your account and data',
                            icon: Iconsax.trash,
                            iconColor: dangerColor,
                            iconBgColor: dangerBgColor,
                            onTap: () {
                              _showDeleteAccountDialog(context, isDarkMode);
                            },
                            isDarkMode: isDarkMode,
                            textColor: dangerColor,
                            secondaryTextColor: secondaryTextColor,
                            dividerColor: dividerColor,
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom spacing
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // NEW: Security summary card
  Widget _buildSecuritySummaryCard({
    required BuildContext context,
    required bool isDarkMode,
    required Color cardColor,
    required Color accentColor,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    // Calculate security score based on enabled settings
    int securityScore = 0;
    if (_biometricEnabled) securityScore += 30;
    if (_pinEnabled) securityScore += 20;
    if (_twoFactorEnabled) securityScore += 40;
    if (_autoLogoutEnabled) securityScore += 10;

    Color scoreColor;
    String securityLevel;

    if (securityScore >= 90) {
      scoreColor = isDarkMode ? AppColors.successDarkMode : AppColors.success;
      securityLevel = "Strong";
    } else if (securityScore >= 60) {
      scoreColor = isDarkMode ? AppColors.warningDarkMode : AppColors.warning;
      securityLevel = "Good";
    } else {
      scoreColor = isDarkMode ? AppColors.errorDarkMode : AppColors.error;
      securityLevel = "Weak";
    }

    return Container(
      decoration: BoxDecoration(
        gradient: isDarkMode
            ? AppColors.darkCardGradient
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accentColor.withOpacity(0.05),
                  accentColor.withOpacity(0.1),
                ],
              ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.1 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.shield_tick,
                    color: accentColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Security Score',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      Text(
                        '$securityLevel Security',
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: scoreColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: scoreColor,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '$securityScore%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: scoreColor,
                    ),
                  ),
                ),
              ],
            ),
            Spacing.verticalM,
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: securityScore / 100,
                backgroundColor: isDarkMode
                    ? AppColors.backgroundDarkSurface2
                    : Colors.grey.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                minHeight: 8,
              ),
            ),
            Spacing.verticalM,
            Text(
              _twoFactorEnabled
                  ? 'Your account is well protected'
                  : 'Enable two-factor authentication for stronger security',
              style: TextStyle(
                fontSize: 13,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityCard({
    required BuildContext context,
    required Color cardColor,
    required Color dividerColor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
                Theme.of(context).brightness == Brightness.dark ? 0.1 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildToggleSettingItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required bool value,
    required Function(bool) onChanged,
    required bool isDarkMode,
    required Color textColor,
    required Color secondaryTextColor,
    required bool showDivider,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: () => onChanged(!value),
          splashColor: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: value,
                  onChanged: onChanged,
                  activeColor:
                      isDarkMode ? AppColors.primaryLight : AppColors.primary,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: isDarkMode
                ? AppColors.borderDarkSubtle
                : Colors.grey.withOpacity(0.1),
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }

  Widget _buildNavigationSettingItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Function onTap,
    required bool isDarkMode,
    required Color textColor,
    required Color secondaryTextColor,
    required bool showDivider,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: () => onTap(),
          splashColor: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: secondaryTextColor,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: isDarkMode
                ? AppColors.borderDarkSubtle
                : Colors.grey.withOpacity(0.1),
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }

  // NEW: Danger zone item
  Widget _buildDangerSettingItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required Function onTap,
    required bool isDarkMode,
    required Color textColor,
    required Color secondaryTextColor,
    required Color dividerColor,
    required bool showDivider,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: () => onTap(),
          splashColor: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: secondaryTextColor,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: dividerColor,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }

  // NEW: Show devices dialog
  void _showDevicesDialog(BuildContext context, bool isDarkMode) {
    final textColor = isDarkMode
        ? AppColors.textDarkHighEmphasis
        : AppColors.textLightPrimary;
    final secondaryTextColor = isDarkMode
        ? AppColors.textDarkMediumEmphasis
        : AppColors.textLightSecondary;
    final backgroundColor =
        isDarkMode ? AppColors.backgroundDarkSurface2 : Colors.white;
    final accentColor = isDarkMode ? AppColors.primaryLight : AppColors.primary;

    final List<Map<String, dynamic>> devices = [
      {
        'name': 'iPhone 15 Pro',
        'lastActive': 'Active now',
        'isCurrent': true,
        'location': 'Lagos, Nigeria',
        'icon': Iconsax.mobile,
      },
      {
        'name': 'MacBook Pro',
        'lastActive': 'Last active 2 hours ago',
        'isCurrent': false,
        'location': 'Lagos, Nigeria',
        'icon': Iconsax.monitor,
      },
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Your Devices',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Devices that are currently signed in to your account',
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              ...devices.map((device) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    tileColor: isDarkMode
                        ? AppColors.backgroundDarkSurface3.withOpacity(0.5)
                        : Colors.grey.withOpacity(0.05),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        device['icon'] as IconData,
                        color: accentColor,
                        size: 20,
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            device['name'] as String,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        if (device['isCurrent'] as bool)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? AppColors.primaryDark.withOpacity(0.2)
                                  : AppColors.primaryLightest,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Current',
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          device['lastActive'] as String,
                          style: TextStyle(
                            color: device['lastActive'] == 'Active now'
                                ? (isDarkMode
                                    ? AppColors.successDarkMode
                                    : AppColors.success)
                                : secondaryTextColor,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          device['location'] as String,
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    trailing: device['isCurrent'] as bool
                        ? null
                        : IconButton(
                            icon: const Icon(Iconsax.logout, size: 18),
                            color: isDarkMode ? Colors.redAccent : Colors.red,
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Logged out from ${device['name']}'),
                                  backgroundColor: isDarkMode
                                      ? AppColors.successDarkMode
                                      : AppColors.success,
                                ),
                              );
                            },
                          ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // NEW: Show change password dialog
  void _showChangePasswordDialog(BuildContext context, bool isDarkMode) {
    final textColor = isDarkMode
        ? AppColors.textDarkHighEmphasis
        : AppColors.textLightPrimary;
    final backgroundColor =
        isDarkMode ? AppColors.backgroundDarkSurface2 : Colors.white;
    final accentColor = isDarkMode ? AppColors.primaryLight : AppColors.primary;

    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    bool obscureCurrentPassword = true;
    bool obscureNewPassword = true;
    bool obscureConfirmPassword = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Change Password',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: currentPasswordController,
                    obscureText: obscureCurrentPassword,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureCurrentPassword
                              ? Iconsax.eye_slash
                              : Iconsax.eye,
                          size: 18,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureCurrentPassword = !obscureCurrentPassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: obscureNewPassword,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureNewPassword ? Iconsax.eye_slash : Iconsax.eye,
                          size: 18,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureNewPassword = !obscureNewPassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureConfirmPassword
                              ? Iconsax.eye_slash
                              : Iconsax.eye,
                          size: 18,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureConfirmPassword = !obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: isDarkMode
                        ? AppColors.textDarkMediumEmphasis
                        : AppColors.textLightSecondary,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Here you would add change password logic
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Password changed successfully'),
                      backgroundColor: isDarkMode
                          ? AppColors.successDarkMode
                          : AppColors.success,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Change Password'),
              ),
            ],
          );
        },
      ),
    );
  }

  // NEW: Show 2FA setup dialog
  void _show2FASetupDialog(BuildContext context, bool isDarkMode) {
    final textColor = isDarkMode
        ? AppColors.textDarkHighEmphasis
        : AppColors.textLightPrimary;
    final secondaryTextColor = isDarkMode
        ? AppColors.textDarkMediumEmphasis
        : AppColors.textLightSecondary;
    final backgroundColor =
        isDarkMode ? AppColors.backgroundDarkSurface2 : Colors.white;
    final accentColor = isDarkMode ? AppColors.primaryLight : AppColors.primary;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Set Up 2FA',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Two-factor authentication adds an extra layer of security to your account. We will send a verification code to your phone when you login.',
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  Iconsax.mobile,
                  size: 18,
                  color: accentColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Phone Number:',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '+234 *** *** 4589',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Image.asset(
                'assets/images/2fa_illustration.png',
                height: 120,
                width: 120,
                // If you don't have this asset, you can use a placeholder Icon instead:
                errorBuilder: (context, error, stackTrace) => Icon(
                  Iconsax.security_safe,
                  size: 80,
                  color: accentColor.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _twoFactorEnabled = false;
              });
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDarkMode
                    ? AppColors.textDarkMediumEmphasis
                    : AppColors.textLightSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _twoFactorEnabled = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Two-factor authentication enabled'),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: const Text(
              'Enable 2FA',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // NEW: Show reset settings dialog
  void _showResetSettingsDialog(BuildContext context, bool isDarkMode) {
    final textColor = isDarkMode
        ? AppColors.textDarkHighEmphasis
        : AppColors.textLightPrimary;
    final secondaryTextColor = isDarkMode
        ? AppColors.textDarkMediumEmphasis
        : AppColors.textLightSecondary;
    final backgroundColor =
        isDarkMode ? AppColors.backgroundDarkSurface2 : Colors.white;
    final accentColor = isDarkMode ? AppColors.primaryLight : AppColors.primary;
    final warningColor =
        isDarkMode ? AppColors.warningDarkMode : AppColors.warning;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              Iconsax.warning_2,
              color: warningColor,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Reset Settings',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'This will reset all your security settings to default. Your data will not be deleted. Do you want to continue?',
          style: TextStyle(
            color: secondaryTextColor,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDarkMode
                    ? AppColors.textDarkMediumEmphasis
                    : AppColors.textLightSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _biometricEnabled = true;
                _pinEnabled = true;
                _twoFactorEnabled = false;
                _autoLogoutEnabled = true;
                _hideBalanceEnabled = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Settings reset to default'),
                  backgroundColor: accentColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: warningColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: const Text(
              'Reset',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // NEW: Show delete account dialog
  void _showDeleteAccountDialog(BuildContext context, bool isDarkMode) {
    final textColor = isDarkMode
        ? AppColors.textDarkHighEmphasis
        : AppColors.textLightPrimary;
    final secondaryTextColor = isDarkMode
        ? AppColors.textDarkMediumEmphasis
        : AppColors.textLightSecondary;
    final backgroundColor =
        isDarkMode ? AppColors.backgroundDarkSurface2 : Colors.white;
    final dangerColor = isDarkMode ? AppColors.errorDarkMode : AppColors.error;

    final passwordController = TextEditingController();
    bool confirmDelete = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(
                  Iconsax.trash,
                  color: dangerColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Delete Account',
                  style: TextStyle(
                    color: dangerColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This action cannot be undone. All your data will be permanently deleted.',
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Enter your password',
                    labelStyle: TextStyle(
                      color: secondaryTextColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: confirmDelete,
                      onChanged: (value) {
                        setState(() {
                          confirmDelete = value ?? false;
                        });
                      },
                      activeColor: dangerColor,
                    ),
                    Expanded(
                      child: Text(
                        'I understand that this action is permanent and cannot be reversed.',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: isDarkMode
                        ? AppColors.textDarkMediumEmphasis
                        : AppColors.textLightSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: confirmDelete && passwordController.text.isNotEmpty
                    ? () {
                        Navigator.pop(context);
                        // Show confirmation before actual deletion
                        _showFinalDeleteConfirmation(context, isDarkMode);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: dangerColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: dangerColor.withOpacity(0.5),
                  disabledForegroundColor: Colors.white70,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                child: const Text(
                  'Delete Account',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // NEW: Show final delete confirmation dialog
  void _showFinalDeleteConfirmation(BuildContext context, bool isDarkMode) {
    final textColor = isDarkMode
        ? AppColors.textDarkHighEmphasis
        : AppColors.textLightPrimary;
    final backgroundColor =
        isDarkMode ? AppColors.backgroundDarkSurface2 : Colors.white;
    final dangerColor = isDarkMode ? AppColors.errorDarkMode : AppColors.error;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Center(
          child: Icon(
            Iconsax.warning_2,
            color: dangerColor,
            size: 48,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you absolutely sure?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This will permanently delete your account and all associated data. You won\'t be able to recover any information.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No, Keep My Account',
              style: TextStyle(
                color: isDarkMode
                    ? AppColors.textDarkMediumEmphasis
                    : AppColors.textLightSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Here you would implement actual account deletion
              // For demo, we'll just show a snackbar and navigate back
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Account deleted successfully'),
                  backgroundColor: dangerColor,
                  duration: const Duration(seconds: 3),
                ),
              );
              // Navigate back to login or onboarding page
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: dangerColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: const Text(
              'Yes, Delete My Account',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
