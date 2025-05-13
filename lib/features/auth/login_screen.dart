// Fixed login_screen.dart with improved icon contrast in dark mode
import 'package:deepex/components/button_base.dart';
import 'package:deepex/components/custom_form_field.dart';
import 'package:deepex/components/primary_button.dart';
import 'package:deepex/components/text_app_button.dart';
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/providers/auth_provider.dart';
import 'package:deepex/utilities/form_utils.dart';
import 'package:deepex/utilities/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/app_text.dart';
import '../../constants/spacing.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Focus nodes
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _fieldFocusChange(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleRememberMe() {
    setState(() {
      _rememberMe = !_rememberMe;
    });
  }

  Future<void> _login() async {
    // Clear focus to trigger form validation
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      try {
        await ref.read(authProvider.notifier).login(
              _emailController.text.trim(),
              _passwordController.text,
            );
        // If needed, save remember me preference
        if (_rememberMe) {
          // Save email to shared preferences for next time
          // You'd implement this in your auth provider
        }
        // No need to navigate, GoRouter will handle redirection
      } catch (e) {
        SnackBarUtils.showError(context, e.toString());
      }
    }
  }

  void _navigateToRegister() {
    context.go('/register');
  }

  Future<void> _forgotPassword() async {
    // Navigate to forgot password screen or show dialog
    // For simplicity, we'll show a dialog here
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText.titleLarge('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText.bodyMedium(
              'Enter your email address to receive a password reset link.',
            ),
            Spacing.verticalM,
            CustomFormField(
              label: 'Email Address',
              hint: 'Enter your email',
              controller: TextEditingController(text: _emailController.text),
              inputType: InputFieldType.email,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppText.button('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement password reset logic
              Navigator.pop(context);
              SnackBarUtils.showSuccess(
                context,
                'Password reset instructions sent to your email',
              );
            },
            child: AppText.button('Send Reset Link', color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Icon color based on theme
    final iconColor = isDarkMode
        ? AppColors.secondaryLight // Use bright cyan in dark mode
        : AppColors.primary; // Use primary color in light mode

    return GestureDetector(
      // Dismiss keyboard when tapping outside
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section
                  AppText.displayLarge('Welcome Back'),

                  AppText.bodyLarge(
                    "Let's pick up where you left off.",
                    color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
                  ),
                  Spacing.verticalXXL,

                  // Email field
                  CustomFormField(
                    label: 'Email Address',
                    hint: 'Enter your email',
                    controller: _emailController,
                    focusNode: _emailFocus,
                    isRequired: true,
                    inputType: InputFieldType.email,
                    validator: FormUtils.validateEmail,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icon(Icons.email_outlined, color: iconColor),
                    onSubmitted: (_) =>
                        _fieldFocusChange(_emailFocus, _passwordFocus),
                  ),
                  Spacing.verticalM,

                  // Password field with fixed visibility toggle
                  CustomFormField(
                    label: 'Password',
                    hint: 'Enter your password',
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    isRequired: true,
                    obscureText: !_isPasswordVisible,
                    inputType: InputFieldType.password,
                    validator: FormUtils.validatePassword,
                    textInputAction: TextInputAction.done,
                    prefixIcon: Icon(Icons.lock_outline, color: iconColor),
                    // Custom suffix icon to handle visibility toggle correctly
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                    onSubmitted: (_) => _login(),
                  ),
                  Spacing.verticalS,

                  // Remember me and forgot password row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Remember me checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (_) => _toggleRememberMe(),
                            activeColor: theme.primaryColor,
                          ),
                          AppText.bodySmall('Remember me'),
                        ],
                      ),

                      // Forgot password button
                      TextAppButton(
                        text: 'Forgot Password?',
                        onPressed: _forgotPassword,
                        textColor: isDarkMode
                            ? AppColors
                                .secondaryLight // Bright cyan in dark mode
                            : AppColors.primary,
                      ),
                    ],
                  ),
                  Spacing.verticalXXL,

                  // Login button
                  PrimaryButton(
                    text: 'Login',
                    size: ButtonSize.large,
                    onPressed: authState.isLoading ? null : _login,
                    isLoading: authState.isLoading,
                  ),
                  Spacing.verticalSM,
                  // Register option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText.bodyMedium("Don't have an account?"),
                      TextButton(
                        onPressed: _navigateToRegister,
                        child: AppText.bodyMedium(
                          "Create Account",
                          // High contrast color in dark mode
                          color: isDarkMode
                              ? AppColors
                                  .secondaryLight // Bright cyan in dark mode
                              : theme.primaryColor,
                          // Primary blue in light mode
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
