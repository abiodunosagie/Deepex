// lib/features/auth/otp/otp_verification_screen.dart
import 'dart:async';

import 'package:deepex/components/button_base.dart';
import 'package:deepex/components/primary_button.dart';
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:deepex/utilities/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String? email;

  const OtpVerificationScreen({Key? key, this.email}) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  // Controllers for the OTP input fields
  final List<TextEditingController> _otpControllers = List.generate(
    6, // Number of OTP digits
    (_) => TextEditingController(),
  );

  // Focus nodes for the OTP input fields
  final List<FocusNode> _otpFocusNodes = List.generate(
    6, // Number of OTP digits
    (_) => FocusNode(),
  );

  // Timer for countdown
  Timer? _timer;
  int _countdown = 60; // 60 seconds countdown
  bool _canResend = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    // Dispose controllers
    for (var controller in _otpControllers) {
      controller.dispose();
    }

    // Dispose focus nodes
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }

    // Cancel timer
    _timer?.cancel();
    super.dispose();
  }

  // Start countdown for resend OTP
  void _startCountdown() {
    setState(() {
      _countdown = 60;
      _canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  // Handle OTP digit input and auto-focus management
  void _onOtpDigitChanged(String value, int index) {
    if (value.length == 1) {
      // If a digit is entered, move focus to the next field
      if (index < 5) {
        _otpFocusNodes[index + 1].requestFocus();
      } else {
        // Last digit entered, unfocus to hide keyboard
        _otpFocusNodes[index].unfocus();

        // Auto-verify when all digits are entered
        _verifyOtp();
      }
    }
  }

  // Handle backspace key for navigation between fields
  void _handleKeyEvent(RawKeyEvent event, int index) {
    // If backspace is pressed and the current field is empty, move to previous field
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace &&
          _otpControllers[index].text.isEmpty &&
          index > 0) {
        _otpFocusNodes[index - 1].requestFocus();
      }
    }
  }

  // Combine all OTP digits into a single code
  String _getOtpCode() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  // Resend OTP code
  void _resendOtp() {
    if (!_canResend) return;

    // Simulate resending OTP with snack bar feedback
    SnackBarUtils.showSuccess(context, 'OTP code has been resent!');
    _startCountdown();
  }

  // Verify OTP - Simplified with direct navigation
  Future<void> _verifyOtp() async {
    final otpCode = _getOtpCode();

    // Check if all digits are entered
    if (otpCode.length != 6) {
      SnackBarUtils.showError(context, 'Please enter all 6 digits');
      return;
    }

    // Prevent multiple verification attempts
    if (_isVerifying) return;

    setState(() {
      _isVerifying = true;
    });

    try {
      // Show loading indicator
      SnackBarUtils.showInfo(context, 'Verifying OTP...');

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Simulate successful verification for "123456"
      if (otpCode == '123456') {
        if (!mounted) return;

        // Show success message
        SnackBarUtils.showSuccess(context, 'OTP verified successfully!');

        // Wait for snackbar to be visible
        await Future.delayed(const Duration(milliseconds: 800));

        if (!mounted) return;

        // Navigate directly to login screen
        context.go('/login');
      } else {
        if (!mounted) return;
        throw Exception('Invalid verification code. Please try again.');
      }
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showError(context, e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isVerifying = false;
        });
      }
    }
  }

  // Helper method to fill all fields with test code
  void _fillTestCode() {
    final testCode = "123456";
    for (int i = 0; i < 6; i++) {
      if (i < testCode.length) {
        _otpControllers[i].text = testCode[i];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Get email from widget parameter
    final userEmail = widget.email ?? 'your email address';

    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: true,
      // ),
      body: SafeArea(
        child: GestureDetector(
          // Dismiss keyboard when tapping outside
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header and instructions
                AppText.displaySmall(
                  'Verify Your Account',
                  textAlign: TextAlign.center,
                ),

                AppText.bodyMedium(
                  'We\'ve sent a verification code to $userEmail',
                  textAlign: TextAlign.center,
                ),
                Spacing.verticalXL,

                // OTP input fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                    (index) => SizedBox(
                      width: 45,
                      height: 55,
                      child: RawKeyboardListener(
                        focusNode: FocusNode(),
                        onKey: (event) => _handleKeyEvent(event, index),
                        child: TextField(
                          controller: _otpControllers[index],
                          focusNode: _otpFocusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: const TextStyle(fontSize: 24),
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding: EdgeInsets.zero,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: isDarkMode
                                    ? Colors.grey[700]!
                                    : Colors.grey[400]!,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: isDarkMode
                                    ? AppColors.primaryLight
                                    : AppColors.primary,
                                width: 2,
                              ),
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) =>
                              _onOtpDigitChanged(value, index),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacing.verticalM,
                // Resend OTP section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText.bodyMedium("Didn't receive the code? "),
                    TextButton(
                      onPressed:
                          _canResend && !_isVerifying ? _resendOtp : null,
                      child: AppText.bodyMedium(
                        _canResend ? "Resend" : "Resend in $_countdown seconds",
                        color: _canResend
                            ? (isDarkMode
                                ? AppColors.secondaryLight
                                : AppColors.primary)
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacing.verticalXXXL,
                // Verify button

                PrimaryButton(
                  text: 'Verify',
                  onPressed: _isVerifying ? null : _verifyOtp,
                  isLoading: _isVerifying,
                  size: ButtonSize.large,
                ),

                // Tip
                Spacing.verticalXL,
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.backgroundDarkSecondary
                        : AppColors.backgroundLightSecondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color:
                            isDarkMode ? AppColors.infoLight : AppColors.info,
                      ),
                      Spacing.horizontalM,
                      Expanded(
                        child: AppText.bodySmall(
                          'For testing purposes, use "123456" as the OTP code.',
                          color: isDarkMode
                              ? AppColors.textDarkSecondary
                              : AppColors.textLightSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Helper button for testing
                Spacing.verticalL,
                OutlinedButton(
                  onPressed: _fillTestCode,
                  child: const Text('🔧 Fill Test Code'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
