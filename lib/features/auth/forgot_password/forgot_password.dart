// lib/features/auth/forgot_password/forgot_password_screen.dart
import 'package:deepex/components/button_base.dart';
import 'package:deepex/components/custom_form_field.dart';
import 'package:deepex/components/primary_button.dart';
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:deepex/utilities/form_utils.dart';
import 'package:deepex/utilities/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String? email;

  const ForgotPasswordScreen({super.key, this.email});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  final _emailFocus = FocusNode();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    // Initialize with email from previous screen if provided
    _emailController = TextEditingController(text: widget.email ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    // Unfocus to trigger validation
    _emailFocus.unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      // Success state
      setState(() {
        _isLoading = false;
        _emailSent = true;
      });

      // Show success message
      SnackBarUtils.showSuccess(
          context, 'Password reset instructions sent to your email');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      SnackBarUtils.showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDarkMode ? AppColors.secondaryLight : AppColors.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Disable automatic back button
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode
                ? AppColors.textDarkPrimary
                : AppColors.textLightPrimary,
          ),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Header
                      Center(
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: Lottie.asset(
                              'assets/animation/forgot_password.json'),
                        ),
                      ),
                      Spacing.verticalL,

                      AppText.displaySmall(
                        'Forgot Password?',
                        textAlign: TextAlign.center,
                      ),
                      Spacing.verticalM,

                      // Instructions
                      AppText.bodyMedium(
                        _emailSent
                            ? 'Check your email for reset instructions. Follow the link in the email to reset your password.'
                            : 'Enter your email address below and we\'ll send you instructions to reset your password.',
                        textAlign: TextAlign.center,
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
                      ),
                      Spacing.verticalXL,

                      // Email input field (only shown before sending)
                      if (!_emailSent)
                        CustomFormField(
                          label: 'Email Address',
                          hint: 'Enter your email',
                          controller: _emailController,
                          focusNode: _emailFocus,
                          isRequired: true,
                          inputType: InputFieldType.email,
                          validator: FormUtils.validateEmail,
                          textInputAction: TextInputAction.done,
                          prefixIcon:
                              Icon(Icons.email_outlined, color: iconColor),
                          onSubmitted: (_) => _resetPassword(),
                        ),

                      // Spacer to push button to bottom
                      Expanded(child: SizedBox()),

                      // Action button
                      _emailSent
                          ? Column(
                              children: [
                                // Back to login button
                                PrimaryButton(
                                  text: 'Back to Login',
                                  onPressed: () => context.go('/login'),
                                  size: ButtonSize.large,
                                ),
                                Spacing.verticalM,
                                // Resend button
                                OutlinedButton(
                                  onPressed: !_isLoading
                                      ? () {
                                          setState(() {
                                            _emailSent = false;
                                          });
                                        }
                                      : null,
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 52),
                                  ),
                                  child: Text('Resend Instructions'),
                                ),
                              ],
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: PrimaryButton(
                                text: 'Send Reset Instructions',
                                onPressed: _isLoading ? null : _resetPassword,
                                isLoading: _isLoading,
                                size: ButtonSize.large,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
