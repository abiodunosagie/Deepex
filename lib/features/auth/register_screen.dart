// Fixed register_screen.dart with prefix icons and improved contrast
import 'package:deepex/components/button_base.dart';
import 'package:deepex/components/custom_form_field.dart';
import 'package:deepex/components/primary_button.dart';
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/providers/auth_provider.dart';
import 'package:deepex/utilities/form_utils.dart';
import 'package:deepex/utilities/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/app_text.dart';
import '../../constants/spacing.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Focus nodes for each field
  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Set up focus listeners (optional)
    _setupFocusListeners();
  }

  // Set up focus listeners to track focus changes (optional)
  void _setupFocusListeners() {
    _firstNameFocus.addListener(() {
      if (_firstNameFocus.hasFocus) {
        debugPrint('First name field has focus');
      }
    });

    _lastNameFocus.addListener(() {
      if (_lastNameFocus.hasFocus) {
        debugPrint('Last name field has focus');
      }
    });

    _emailFocus.addListener(() {
      if (_emailFocus.hasFocus) {
        debugPrint('Email field has focus');
      }
    });

    _passwordFocus.addListener(() {
      if (_passwordFocus.hasFocus) {
        debugPrint('Password field has focus');
      }
    });

    _confirmPasswordFocus.addListener(() {
      if (_confirmPasswordFocus.hasFocus) {
        debugPrint('Confirm password field has focus');
      }
    });
  }

  @override
  void dispose() {
    // Dispose controllers
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    // Dispose focus nodes
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();

    super.dispose();
  }

  // Move to next field when user presses next
  void _fieldFocusChange(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _register() async {
    // Clear all focus to trigger validation
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      try {
        final fullName =
            "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}";
        await ref.read(authProvider.notifier).register(
              fullName,
              _emailController.text.trim(),
              _passwordController.text,
            );

        // No need to navigate, GoRouter will handle redirection
      } catch (e) {
        SnackBarUtils.showError(context, e.toString());
      }
    }
  }

  void _navigateToLogin() {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Icon color based on theme
    final iconColor = isDarkMode
        ? AppColors.secondaryLight // Use bright cyan in dark mode
        : AppColors.primary; // Use primary color in light mode

    return GestureDetector(
      // Dismiss keyboard when tapping outside of input fields
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
                  AppText.displayLarge(
                    'Create Account',
                  ),
                  Spacing.verticalS,
                  AppText.bodyLarge(
                    'Create an account to manage bills\nand gift cards.',
                    color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
                  ),
                  Spacing.verticalXL,

                  // First Name field with person icon
                  CustomFormField(
                    label: 'First Name',
                    hint: 'Enter your first name',
                    controller: _firstNameController,
                    focusNode: _firstNameFocus,
                    isRequired: true,
                    validator: (value) =>
                        FormUtils.validateRequiredField(value, 'First name'),
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icon(Icons.person_outline, color: iconColor),
                    onSubmitted: (_) =>
                        _fieldFocusChange(_firstNameFocus, _lastNameFocus),
                  ),
                  Spacing.verticalM,

                  // Last Name field with person icon
                  CustomFormField(
                    label: 'Last Name',
                    hint: 'Enter your last name',
                    controller: _lastNameController,
                    focusNode: _lastNameFocus,
                    isRequired: true,
                    validator: (value) =>
                        FormUtils.validateRequiredField(value, 'Last name'),
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icon(Icons.person_outline, color: iconColor),
                    onSubmitted: (_) =>
                        _fieldFocusChange(_lastNameFocus, _emailFocus),
                  ),
                  Spacing.verticalM,

                  // Email field with email icon
                  CustomFormField(
                    label: 'Email',
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

                  // Password field with lock icon and visibility toggle
                  CustomFormField(
                    label: 'Password',
                    hint: 'Enter your password',
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    isRequired: true,
                    obscureText: !_isPasswordVisible,
                    inputType: InputFieldType.password,
                    validator: FormUtils.validatePassword,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icon(Icons.lock_outline, color: iconColor),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                    onSubmitted: (_) => _fieldFocusChange(
                        _passwordFocus, _confirmPasswordFocus),
                  ),
                  Spacing.verticalM,

                  // Confirm Password field with lock icon and visibility toggle
                  CustomFormField(
                    label: 'Confirm Password',
                    hint: 'Confirm your password',
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocus,
                    isRequired: true,
                    obscureText: !_isConfirmPasswordVisible,
                    inputType: InputFieldType.password,
                    validator: _validateConfirmPassword,
                    textInputAction: TextInputAction.done,
                    prefixIcon: Icon(Icons.lock_outline, color: iconColor),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                      onPressed: _toggleConfirmPasswordVisibility,
                    ),
                    onSubmitted: (_) {
                      _confirmPasswordFocus.unfocus();
                      _register();
                    },
                  ),
                  Spacing.verticalXXL,

                  // Create Account button
                  PrimaryButton(
                    size: ButtonSize.large,
                    text: 'Create Account',
                    onPressed: authState.isLoading ? null : _register,
                    isLoading: authState.isLoading,
                  ),
                  Spacing.verticalSM,

                  // Login option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText.bodyMedium("Already have an account?"),
                      TextButton(
                        onPressed: _navigateToLogin,
                        child: AppText.bodyMedium(
                          "Login",
                          // High contrast color in dark mode
                          color: isDarkMode
                              ? AppColors
                                  .secondaryLight // Bright cyan in dark mode
                              : AppColors.primary, // Primary blue in light mode
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
