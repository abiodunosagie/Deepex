// lib/screens/profile_screen.dart
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define our UI colors based on theme mode
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

    // KYC Verification status (let's assume BVN is verified but NIN is not)
    final bvnVerified = true;
    final ninVerified = false;

    // Overall KYC Status determination
    final kycStatus =
        (bvnVerified || ninVerified) ? 'Partially Verified' : 'Unverified';
    final kycStatusColor = bvnVerified && ninVerified
        ? AppColors.success
        : (bvnVerified || ninVerified)
            ? AppColors.warning
            : AppColors.error;
// Verification dialog for BVN/NIN with improved validation
    void _showVerificationDialog({
      required BuildContext context,
      required String verType,
      required bool isDarkMode,
    }) {
      final textColor = isDarkMode
          ? AppColors.textDarkHighEmphasis
          : AppColors.textLightPrimary;
      final backgroundColor =
          isDarkMode ? AppColors.backgroundDarkSurface2 : Colors.white;
      final accentColor =
          isDarkMode ? AppColors.primaryLight : AppColors.primary;
      final errorColor = isDarkMode ? AppColors.errorDarkMode : AppColors.error;

      final controller = TextEditingController();

      // Define required length for each ID type
      final int requiredLength = verType == 'BVN'
          ? 11
          : 11; // Both BVN and NIN are 11 digits in Nigeria
      final String hintText = verType == 'BVN'
          ? 'Enter your 11-digit BVN'
          : 'Enter your 11-digit NIN';

      // State management
      bool isValid = false;
      String? errorText;

      // Create a stateful builder to manage validation state
      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            // Validation function
            void validateInput(String value) {
              if (value.isEmpty) {
                setState(() {
                  isValid = false;
                  errorText = 'Please enter your $verType';
                });
              } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                setState(() {
                  isValid = false;
                  errorText = '$verType should contain numbers only';
                });
              } else if (value.length != requiredLength) {
                setState(() {
                  isValid = false;
                  errorText =
                      '$verType should be exactly $requiredLength digits';
                });
              } else {
                setState(() {
                  isValid = true;
                  errorText = null;
                });
              }
            }

            return AlertDialog(
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Verify Your $verType',
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
                    verType == 'BVN'
                        ? 'Enter your 11-digit Bank Verification Number'
                        : 'Enter your 11-digit National Identity Number',
                    style: TextStyle(
                      color: isDarkMode
                          ? AppColors.textDarkMediumEmphasis
                          : AppColors.textLightSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    maxLength: requiredLength,
                    onChanged: (value) {
                      validateInput(value);
                    },
                    decoration: InputDecoration(
                      fillColor: isDarkMode
                          ? AppColors.backgroundDarkSurface3
                          : AppColors.backgroundLightSecondary,
                      filled: true,
                      hintText: hintText,
                      hintStyle: TextStyle(
                        color: isDarkMode
                            ? AppColors.textDarkPlaceholder
                            : AppColors.textLightDisabled,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: errorText != null
                              ? errorColor
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: errorText != null ? errorColor : accentColor,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      counterText: '${controller.text.length}/$requiredLength',
                      counterStyle: TextStyle(
                        color: isDarkMode
                            ? AppColors.textDarkLowEmphasis
                            : AppColors.textLightDisabled,
                        fontSize: 12,
                      ),
                      suffixIcon: controller.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: isDarkMode
                                    ? AppColors.textDarkLowEmphasis
                                    : AppColors.textLightDisabled,
                                size: 18,
                              ),
                              onPressed: () {
                                controller.clear();
                                setState(() {
                                  isValid = false;
                                  errorText = 'Please enter your $verType';
                                });
                              },
                            )
                          : null,
                      errorText: errorText,
                      errorStyle: TextStyle(
                        color: errorColor,
                        fontSize: 12,
                      ),
                    ),
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      letterSpacing:
                          1.2, // Slightly spaced for better readability of numbers
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(requiredLength),
                    ],
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Iconsax.shield_tick,
                        size: 14,
                        color: isDarkMode
                            ? AppColors.textDarkLowEmphasis
                            : AppColors.textLightSecondary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Your information is encrypted and stored securely',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode
                                ? AppColors.textDarkLowEmphasis
                                : AppColors.textLightSecondary,
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
                  onPressed: isValid
                      ? () {
                          // Here you would add verification logic
                          Navigator.pop(context);
                          // Show success message
                          _showVerificationSuccessSheet(
                            context: context,
                            verType: verType,
                            isDarkMode: isDarkMode,
                          );
                        }
                      : null, // Disable button if input is invalid
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    disabledBackgroundColor: isDarkMode
                        ? AppColors.backgroundDarkSurface4
                        : Colors.grey.withOpacity(0.2),
                    disabledForegroundColor: isDarkMode
                        ? AppColors.textDarkDisabled
                        : AppColors.textLightDisabled,
                  ),
                  child: const Text(
                    'Verify',
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

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: primaryTextColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Edit profile action
            },
            icon: Icon(
              Iconsax.edit,
              color: accentColor,
              size: 24,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Section
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Profile Avatar with decorative ring
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer decorative ring
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: isDarkMode
                              ? AppColors.darkBrandGradient
                              : LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    accentColor,
                                    accentColor.withOpacity(0.4),
                                  ],
                                ),
                        ),
                      ),
                      // White/Dark circular background
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: backgroundColor,
                        ),
                      ),
                      // User avatar
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDarkMode
                              ? AppColors.backgroundDarkSecondary
                              : AppColors.backgroundLightSecondary,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(isDarkMode ? 0.2 : 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: accentColor,
                        ),
                      ),
                      // Add verification badge if verified
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kycStatusColor,
                            border: Border.all(
                              color: backgroundColor,
                              width: 2.5,
                            ),
                          ),
                          child: Icon(
                            bvnVerified && ninVerified
                                ? Icons.check
                                : (bvnVerified || ninVerified)
                                    ? Icons.more_horiz
                                    : Icons.priority_high,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Spacing.verticalL,

                  // User name
                  Text(
                    'Smith Johnson',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                  ),

                  Spacing.verticalXS,

                  // Email address
                  Text(
                    'smith.johnson@example.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: secondaryTextColor,
                    ),
                  ),

                  Spacing.verticalM,

                  // Account level badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFFD700),
                          const Color(0xFFFFAA00),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD700).withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Premium Member',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Spacing.verticalL,
                ],
              ),
            ),

            // Cards for KYC and account stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // KYC Verification status
                  Expanded(
                    child: _buildInfoCard(
                      context: context,
                      icon: Iconsax.security_user,
                      title: 'KYC Status',
                      value: kycStatus,
                      valueColor: kycStatusColor,
                      bgColor: cardColor,
                      iconColor: kycStatusColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Account age
                  Expanded(
                    child: _buildInfoCard(
                      context: context,
                      icon: Iconsax.calendar,
                      title: 'Member Since',
                      value: 'Jan 2024',
                      bgColor: cardColor,
                      iconColor: accentColor,
                    ),
                  ),
                ],
              ),
            ),

            Spacing.verticalL,

            // KYC Verification Section (NEW)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppText.headingMedium('Identity Verification'),
                      const SizedBox(width: 8),
                      Tooltip(
                        message:
                            'Verify your identity to unlock higher transaction limits and advanced features.',
                        triggerMode: TooltipTriggerMode.tap,
                        child: Icon(
                          Iconsax.info_circle,
                          size: 16,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  Spacing.verticalXS,
                  Text(
                    'Complete verification to unlock higher transaction limits',
                    style: TextStyle(
                      fontSize: 13,
                      color: secondaryTextColor,
                    ),
                  ),
                  Spacing.verticalM,

                  // Verification methods container
                  Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withOpacity(isDarkMode ? 0.1 : 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // BVN Verification Item
                        _buildVerificationItem(
                          context: context,
                          title: 'Bank Verification Number (BVN)',
                          subtitle: bvnVerified
                              ? 'Verified • Your BVN has been verified'
                              : 'Not verified • Verify your BVN',
                          icon: Iconsax.bank,
                          isVerified: bvnVerified,
                          onTap: () {
                            // Show BVN verification dialog or navigate to verification screen
                            if (!bvnVerified) {
                              _showVerificationDialog(
                                context: context,
                                verType: 'BVN',
                                isDarkMode: isDarkMode,
                              );
                            }
                          },
                          isDarkMode: isDarkMode,
                          dividerColor: dividerColor,
                        ),

                        // NIN Verification Item
                        _buildVerificationItem(
                          context: context,
                          title: 'National Identity Number (NIN)',
                          subtitle: ninVerified
                              ? 'Verified • Your NIN has been verified'
                              : 'Not verified • Verify your NIN to increase limits',
                          icon: Iconsax.card,
                          isVerified: ninVerified,
                          onTap: () {
                            // Show NIN verification dialog or navigate to verification screen
                            if (!ninVerified) {
                              _showVerificationDialog(
                                context: context,
                                verType: 'NIN',
                                isDarkMode: isDarkMode,
                              );
                            }
                          },
                          isDarkMode: isDarkMode,
                          dividerColor: dividerColor,
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),

                  // Info about verification benefits
                  Padding(
                    padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Iconsax.shield_tick,
                          size: 16,
                          color: secondaryTextColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Your identity information is encrypted and securely stored according to regulations.',
                            style: TextStyle(
                              fontSize: 12,
                              color: secondaryTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Spacing.verticalL,

            // Settings cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.headingMedium('Settings'),
                  Spacing.verticalM,
                  // Card containing setting options
                  Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withOpacity(isDarkMode ? 0.1 : 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildSettingItem(
                          context: context,
                          icon: Iconsax.security,
                          title: 'Security Settings',
                          subtitle: 'Password, biometrics & PIN',
                          isDarkMode: isDarkMode,
                          dividerColor: dividerColor,
                          accentColor: accentColor,
                        ),
                        _buildSettingItem(
                          context: context,
                          icon: Iconsax.notification,
                          title: 'Notifications',
                          subtitle: 'Manage your alerts',
                          isDarkMode: isDarkMode,
                          dividerColor: dividerColor,
                          accentColor: accentColor,
                        ),
                        _buildSettingItem(
                          context: context,
                          icon: Iconsax.bank,
                          title: 'Payment Methods',
                          subtitle: 'Manage cards & accounts',
                          isDarkMode: isDarkMode,
                          dividerColor: dividerColor,
                          accentColor: accentColor,
                        ),
                        _buildSettingItem(
                          context: context,
                          icon: Iconsax.document,
                          title: 'Legal & Compliance',
                          subtitle: 'Documents & agreements',
                          isDarkMode: isDarkMode,
                          dividerColor: dividerColor,
                          accentColor: accentColor,
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Spacing.verticalL,

            // Logout button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  // Handle logout
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode
                      ? Colors.redAccent.withOpacity(0.2)
                      : Colors.red.withOpacity(0.1),
                  foregroundColor: isDarkMode ? Colors.redAccent : Colors.red,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isDarkMode ? Colors.redAccent : Colors.red,
                      width: 1.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Iconsax.logout,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Add some bottom padding to avoid the navigation bar
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Verification item for KYC methods
  Widget _buildVerificationItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isVerified,
    required Function onTap,
    required bool isDarkMode,
    required Color dividerColor,
    bool showDivider = true,
  }) {
    final textColor = isDarkMode
        ? AppColors.textDarkHighEmphasis
        : AppColors.textLightPrimary;
    final secondaryTextColor = isDarkMode
        ? AppColors.textDarkMediumEmphasis
        : AppColors.textLightSecondary;

    final statusColor = isVerified
        ? isDarkMode
            ? AppColors.successDarkMode
            : AppColors.success
        : isDarkMode
            ? AppColors.warningDarkMode
            : AppColors.warning;

    final statusBgColor = isVerified
        ? isDarkMode
            ? AppColors.successDarkModeBackground
            : AppColors.successLight
        : isDarkMode
            ? AppColors.warningDarkModeBackground
            : AppColors.warningLight;

    return Column(
      children: [
        InkWell(
          onTap: () => onTap(),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: statusColor,
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
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 2),
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
                Container(
                  decoration: BoxDecoration(
                    color: isVerified
                        ? isDarkMode
                            ? AppColors.successDarkModeBackground
                            : AppColors.successLight
                        : isDarkMode
                            ? Colors.transparent
                            : Colors.white,
                    border: isVerified
                        ? null
                        : Border.all(
                            color: isDarkMode
                                ? AppColors.warningDarkMode
                                : AppColors.warning,
                            width: 1.5,
                          ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text(
                    isVerified ? 'Verified' : 'Verify Now',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
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

  // Verification dialog for BVN/NIN
  void _showVerificationDialog({
    required BuildContext context,
    required String verType,
    required bool isDarkMode,
  }) {
    final textColor = isDarkMode
        ? AppColors.textDarkHighEmphasis
        : AppColors.textLightPrimary;
    final backgroundColor =
        isDarkMode ? AppColors.backgroundDarkSurface2 : Colors.white;
    final accentColor = isDarkMode ? AppColors.primaryLight : AppColors.primary;

    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Verify Your $verType',
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
              verType == 'BVN'
                  ? 'Enter your 11-digit Bank Verification Number'
                  : 'Enter your 11-digit National Identity Number',
              style: TextStyle(
                color: isDarkMode
                    ? AppColors.textDarkMediumEmphasis
                    : AppColors.textLightSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              maxLength: 11,
              decoration: InputDecoration(
                fillColor: isDarkMode
                    ? AppColors.backgroundDarkSurface3
                    : AppColors.backgroundLightSecondary,
                filled: true,
                hintText: verType == 'BVN' ? 'Enter BVN' : 'Enter NIN',
                hintStyle: TextStyle(
                  color: isDarkMode
                      ? AppColors.textDarkPlaceholder
                      : AppColors.textLightDisabled,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                counterText: '',
              ),
              style: TextStyle(
                color: textColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Iconsax.shield_tick,
                  size: 14,
                  color: isDarkMode
                      ? AppColors.textDarkLowEmphasis
                      : AppColors.textLightSecondary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Your information is encrypted and stored securely',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode
                          ? AppColors.textDarkLowEmphasis
                          : AppColors.textLightSecondary,
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
            onPressed: () {
              // Here you would add verification logic
              Navigator.pop(context);
              // Show success message
              _showVerificationSuccessSheet(
                  context: context, verType: verType, isDarkMode: isDarkMode);
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
              'Verify',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Success bottom sheet after verification
  void _showVerificationSuccessSheet({
    required BuildContext context,
    required String verType,
    required bool isDarkMode,
  }) {
    final backgroundColor =
        isDarkMode ? AppColors.backgroundDarkSurface1 : Colors.white;
    final successColor =
        isDarkMode ? AppColors.successDarkMode : AppColors.success;
    final textColor = isDarkMode
        ? AppColors.textDarkHighEmphasis
        : AppColors.textLightPrimary;

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
            const SizedBox(height: 24),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.successDarkModeBackground
                    : successColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: successColor,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '$verType Verification Successful',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your $verType has been successfully verified. You can now enjoy higher transaction limits and additional features.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode
                    ? AppColors.textDarkMediumEmphasis
                    : AppColors.textLightSecondary,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: successColor,
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required Color bgColor,
    required Color iconColor,
    Color? valueColor,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode
        ? AppColors.textDarkHighEmphasis
        : AppColors.textLightPrimary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.1 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
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
          Spacing.verticalM,
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode
                  ? AppColors.textDarkMediumEmphasis
                  : AppColors.textLightSecondary,
            ),
          ),
          Spacing.verticalXS,
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: valueColor ?? textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDarkMode,
    required Color dividerColor,
    required Color accentColor,
    bool showDivider = true,
  }) {
    final textColor = isDarkMode
        ? AppColors.textDarkHighEmphasis
        : AppColors.textLightPrimary;
    final secondaryTextColor = isDarkMode
        ? AppColors.textDarkMediumEmphasis
        : AppColors.textLightSecondary;

    return Column(
      children: [
        InkWell(
          onTap: () {
            // Handle setting item tap
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
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
}
