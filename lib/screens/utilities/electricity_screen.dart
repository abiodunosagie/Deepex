// lib/screens/utilities/electricity_screen.dart
import 'package:deepex/components/button_base.dart';
import 'package:deepex/components/primary_button.dart';
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:deepex/utilities/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import 'electricity_success_screen.dart';

class ElectricityScreen extends StatefulWidget {
  const ElectricityScreen({super.key});

  @override
  State<ElectricityScreen> createState() => _ElectricityScreenState();
}

class _ElectricityScreenState extends State<ElectricityScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _meterNumberController = TextEditingController();
  final _amountController = TextEditingController();
  final _phoneController = TextEditingController();

  // Focus nodes
  final _meterNumberFocus = FocusNode();
  final _amountFocus = FocusNode();
  final _phoneFocus = FocusNode();

  // Animation controller for grid items
  late AnimationController _animationController;

  bool _isVerifying = false;
  bool _isProcessing = false;
  bool _customerVerified = false;

  String _selectedProvider = '';
  String _selectedMeterType = 'prepaid';
  String _customerName = '';
  String _customerAddress = '';
  String _phoneErrorText = '';
  String _meterErrorText = '';

  // Meter token for prepaid (will be generated after successful payment)
  String? _meterToken;

  // Add sample electricity providers here with required meter digits
  final List<Map<String, dynamic>> _providers = [
    {
      'id': 'ekedc',
      'name': 'Eko Electric (EKEDC)',
      'icon': Iconsax.flash_1,
      'color': const Color(0xFFFF9800),
      'meterDigits': 11,
      'meterPrefix': '04',
    },
    {
      'id': 'ikedc',
      'name': 'Ikeja Electric (IKEDC)',
      'icon': Iconsax.flash_1,
      'color': const Color(0xFF1E88E5),
      'meterDigits': 13,
      'meterPrefix': '12',
    },
    {
      'id': 'aedc',
      'name': 'Abuja Electric (AEDC)',
      'icon': Iconsax.flash_1,
      'color': const Color(0xFF43A047),
      'meterDigits': 10,
      'meterPrefix': '45',
    },
    {
      'id': 'phedc',
      'name': 'Port Harcourt Electric (PHEDC)',
      'icon': Iconsax.flash_1,
      'color': const Color(0xFF6A1B9A),
      'meterDigits': 11,
      'meterPrefix': '30',
    },
  ];

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Add listeners to controllers for smart formatting
    _meterNumberController.addListener(_formatMeterNumber);
    _amountController.addListener(_formatAmount);
    _phoneController.addListener(_formatPhoneNumber);
  }

  @override
  void dispose() {
    _meterNumberController.dispose();
    _amountController.dispose();
    _phoneController.dispose();
    _meterNumberFocus.dispose();
    _amountFocus.dispose();
    _phoneFocus.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Format meter number based on selected provider
  void _formatMeterNumber() {
    if (_meterNumberController.text.isEmpty || _selectedProvider.isEmpty) {
      setState(() {
        _meterErrorText = '';
      });
      return;
    }

    // Get the selected provider's meter format details
    final provider = _providers.firstWhere(
      (provider) => provider['id'] == _selectedProvider,
      orElse: () => {
        'meterDigits': 11,
        'meterPrefix': '',
      },
    );

    // Extract digits only
    final rawDigits =
        _meterNumberController.text.replaceAll(RegExp(r'[^\d]'), '');
    final requiredDigits = provider['meterDigits'] as int;
    final prefix = provider['meterPrefix'] as String;

    // Validate and format the meter number
    if (rawDigits.length > requiredDigits) {
      // Trim to required length
      final trimmed = rawDigits.substring(0, requiredDigits);
      _meterNumberController.value = TextEditingValue(
        text: trimmed,
        selection: TextSelection.collapsed(offset: trimmed.length),
      );
      setState(() {
        _meterErrorText =
            '${provider['name']} meter numbers must be $requiredDigits digits';
      });
    } else if (rawDigits.length < requiredDigits && rawDigits.isNotEmpty) {
      setState(() {
        _meterErrorText = 'Enter all $requiredDigits digits';
      });
    } else if (rawDigits.length == requiredDigits) {
      // Check if the prefix is correct
      if (prefix.isNotEmpty && !rawDigits.startsWith(prefix)) {
        setState(() {
          _meterErrorText =
              '${provider['name']} meter numbers should start with $prefix';
        });
      } else {
        setState(() {
          _meterErrorText = '';
        });
      }
    }
  }

  // Format amount with currency symbol and commas
  void _formatAmount() {
    if (_amountController.text.isEmpty) {
      return;
    }

    // Remove all non-digit characters
    final rawDigits = _amountController.text.replaceAll(RegExp(r'[^\d]'), '');

    // Parse to int
    final amount = int.tryParse(rawDigits) ?? 0;

    // Format with commas
    final formattedAmount = '₦${_formatWithCommas(amount)}';

    // Only update if the value changed to avoid cursor jumping
    if (_amountController.text != formattedAmount) {
      _amountController.value = TextEditingValue(
        text: formattedAmount,
        selection: TextSelection.collapsed(offset: formattedAmount.length),
      );
    }
  }

  // Helper to format number with commas for thousands
  String _formatWithCommas(int value) {
    return value.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  // Format phone number with +234 prefix
  void _formatPhoneNumber() {
    if (_phoneController.text.isEmpty) {
      setState(() {
        _phoneErrorText = '';
      });
      return;
    }

    final text = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');

    // Check if the number starts with 0
    if (text.startsWith('0') && text.length > 1) {
      final formattedText = '+234 ${text.substring(1)}';

      // Only update if the text is different to avoid cursor jumping
      if (formattedText != _phoneController.text) {
        _phoneController.value = TextEditingValue(
          text: formattedText,
          selection: TextSelection.collapsed(offset: formattedText.length),
        );
      }
    }
    // If the number doesn't have any prefix yet
    else if (!text.startsWith('+') && !_phoneController.text.contains('+234')) {
      final formattedText = '+234 $text';

      _phoneController.value = TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }

    // Validate phone number length (Nigeria: 11 digits without prefix)
    final digitsOnly = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length > 13) {
      // +234 + 10 digits
      setState(() {
        _phoneErrorText = 'Phone number is too long';
      });
    } else if (digitsOnly.length < 13 && digitsOnly.isNotEmpty) {
      setState(() {
        _phoneErrorText = 'Please enter a valid phone number';
      });
    } else {
      setState(() {
        _phoneErrorText = '';
      });
    }
  }

  // Extract amount value from formatted text
  double _extractAmountValue() {
    final text = _amountController.text;
    final digitsOnly = text.replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(digitsOnly) ?? 0.0;
  }

  // Handle meter number verification
  Future<void> _verifyMeter() async {
    // Basic validation
    if (_selectedProvider.isEmpty) {
      SnackBarUtils.showError(context, 'Please select an electricity provider');
      return;
    }

    if (_meterNumberController.text.isEmpty) {
      SnackBarUtils.showError(context, 'Please enter a meter number');
      return;
    }

    // Check if meter number has correct format
    if (_meterErrorText.isNotEmpty) {
      SnackBarUtils.showError(context, _meterErrorText);
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    try {
      // Simulate API verification delay
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, this would be an API call to verify the meter
      setState(() {
        _isVerifying = false;
        _customerVerified = true;
        _customerName = 'John Doe';
        _customerAddress = '123 Main Street, Lagos';
      });

      // Show success message
      SnackBarUtils.showSuccess(context, 'Meter verified successfully');
    } catch (e) {
      if (mounted) {
        setState(() {
          _isVerifying = false;
        });

        SnackBarUtils.showError(context, 'Failed to verify meter: $e');
      }
    }
  }

  // Process payment
  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check amount minimum
    final amount = _extractAmountValue();
    if (amount < 100) {
      SnackBarUtils.showError(context, 'Minimum amount is ₦100');
      return;
    }

    // Check amount maximum
    if (amount > 50000) {
      SnackBarUtils.showError(context, 'Maximum amount is ₦50,000');
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      // Generate token for prepaid meters
      if (_selectedMeterType == 'prepaid') {
        _meterToken = _generateMockToken();
      }

      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        // Navigate to ElectricitySuccessScreen directly with required parameters
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ElectricitySuccessScreen(
              provider: _getProviderName(_selectedProvider),
              meterNumber:
                  _meterNumberController.text.replaceAll(RegExp(r'[^\d]'), ''),
              meterType: _selectedMeterType,
              amount: amount,
              token: _meterToken,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        // Navigate to failure screen with error details
        context.push('/electricity/failure', extra: {
          'errorMessage': 'Failed to process payment: $e',
          'transactionId':
              DateTime.now().millisecondsSinceEpoch.toString().substring(5),
        });
      }
    }
  }

  // Generate a mock meter token (for prepaid meters)
  String _generateMockToken() {
    final random = StringBuffer();
    for (int i = 0; i < 4; i++) {
      random.write((1000 + DateTime.now().millisecond + i * 37) % 10000);
      if (i < 3) random.write('-');
    }
    return random.toString();
  }

  // Get provider name from ID
  String _getProviderName(String providerId) {
    final provider = _providers.firstWhere(
      (provider) => provider['id'] == providerId,
      orElse: () => {'name': 'Unknown Provider'},
    );
    return provider['name'] as String;
  }

  // Get current provider details
  Map<String, dynamic> get currentProvider {
    return _providers.firstWhere(
      (provider) => provider['id'] == _selectedProvider,
      orElse: () => _providers.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Enhanced color palette
    final primaryColor =
        isDarkMode ? AppColors.primaryLight : AppColors.primary;

    final accentColor =
        isDarkMode ? const Color(0xFF64FFDA) : AppColors.secondary;

    final tertiaryColor =
        isDarkMode ? const Color(0xFF7986CB) : const Color(0xFF5C6BC0);

    final backgroundColor =
        isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight;

    final cardColor = isDarkMode
        ? AppColors.backgroundDarkSecondary
        : AppColors.backgroundLightSecondary;

    final textColor =
        isDarkMode ? AppColors.textDarkPrimary : AppColors.textLightPrimary;

    final secondaryTextColor =
        isDarkMode ? AppColors.textDarkSecondary : AppColors.textLightSecondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode
                    ? [
                        AppColors.backgroundDarkSecondary.withAlpha(204),
                        AppColors.backgroundDarkSecondary.withAlpha(153),
                      ]
                    : [
                        AppColors.backgroundLightSecondary.withAlpha(204),
                        AppColors.backgroundLightSecondary.withAlpha(153),
                      ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDarkMode ? 51 : 26),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: textColor,
                size: 20,
              ),
              onPressed: () => context.pop(),
            ),
          ),
        ),
        title: AppText.titleLarge(
          'Electricity Bill',
          color: textColor,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.backgroundDarkSecondary.withAlpha(128)
                    : AppColors.backgroundLightSecondary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Iconsax.info_circle,
                  color: primaryColor,
                  size: 20,
                ),
                onPressed: () {
                  // Show info dialog or tooltip
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: isDarkMode
                        ? AppColors.backgroundDarkSecondary
                        : AppColors.backgroundLightElevated,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText.headingMedium(
                            'Electricity Bill Payment',
                            color: textColor,
                          ),
                          Spacing.verticalM,
                          AppText.bodyMedium(
                            'Pay your electricity bills safely and instantly. For prepaid meters, a token will be generated upon successful payment.',
                            color: secondaryTextColor,
                          ),
                          Spacing.verticalL,
                          PrimaryButton(
                            text: 'Got it',
                            onPressed: () => Navigator.pop(context),
                            size: ButtonSize.medium,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Enhanced header with gradient
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDarkMode
                            ? [
                                AppColors.electricity.withAlpha(51),
                                AppColors.electricityLight.withAlpha(26),
                              ]
                            : [
                                AppColors.electricity.withAlpha(26),
                                AppColors.electricityLight.withAlpha(13),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(isDarkMode ? 51 : 13),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? AppColors.electricity.withAlpha(76)
                                    : AppColors.electricity.withAlpha(51),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Iconsax.flash_1,
                                color: AppColors.electricity,
                                size: 24,
                              ),
                            ),
                            Spacing.horizontalM,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText.headingMedium(
                                    'Pay Electricity Bill',
                                    color: textColor,
                                  ),
                                  Spacing.verticalXS,
                                  AppText.bodyMedium(
                                    'Easy, secure payments for your electricity',
                                    color: secondaryTextColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Spacing.verticalXL,

                  // Provider selection with enhanced UI
                  Row(
                    children: [
                      Icon(
                        Iconsax.electricity,
                        size: 18,
                        color: AppColors.electricity,
                      ),
                      Spacing.horizontalS,
                      AppText.titleMedium(
                        'Select Provider',
                        color: textColor,
                      ),
                    ],
                  ),
                  Spacing.verticalM,

                  // Provider grid with animated selection
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _providers.length,
                    itemBuilder: (context, index) {
                      final provider = _providers[index];
                      final isSelected = _selectedProvider == provider['id'];

                      return _buildProviderCard(
                        provider: provider,
                        isSelected: isSelected,
                        isDarkMode: isDarkMode,
                      );
                    },
                  ),

                  Spacing.verticalXL,

                  // Enhanced meter type selection
                  Row(
                    children: [
                      Icon(
                        Iconsax.category,
                        size: 18,
                        color: AppColors.electricity,
                      ),
                      Spacing.horizontalS,
                      AppText.titleMedium(
                        'Meter Type',
                        color: textColor,
                      ),
                    ],
                  ),
                  Spacing.verticalM,

                  Row(
                    children: [
                      Expanded(
                        child: _buildMeterTypeButton(
                          label: 'Prepaid',
                          value: 'prepaid',
                          isDarkMode: isDarkMode,
                        ),
                      ),
                      Spacing.horizontalM,
                      Expanded(
                        child: _buildMeterTypeButton(
                          label: 'Postpaid',
                          value: 'postpaid',
                          isDarkMode: isDarkMode,
                        ),
                      ),
                    ],
                  ),

                  Spacing.verticalXL,

                  // Enhanced meter number section with smart field
                  Row(
                    children: [
                      Icon(
                        Iconsax.security_card,
                        size: 18,
                        color: AppColors.electricity,
                      ),
                      Spacing.horizontalS,
                      AppText.titleMedium(
                        'Meter Details',
                        color: textColor,
                      ),
                    ],
                  ),

                  Spacing.verticalM,

                  // Smart meter field with custom validation
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _meterNumberController,
                          focusNode: _meterNumberFocus,
                          decoration: InputDecoration(
                            labelText: 'Meter Number',
                            labelStyle: TextStyle(
                              color: _meterNumberFocus.hasFocus
                                  ? AppColors.electricity
                                  : secondaryTextColor,
                              fontSize: 14,
                            ),
                            hintText: _selectedProvider.isNotEmpty
                                ? '${currentProvider['meterDigits']}-digit number'
                                : 'Select provider first',
                            hintStyle: TextStyle(
                              color: secondaryTextColor.withAlpha(179),
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Iconsax.electricity,
                              color: _meterNumberFocus.hasFocus
                                  ? AppColors.electricity
                                  : secondaryTextColor,
                              size: 20,
                            ),
                            filled: true,
                            fillColor: isDarkMode
                                ? Colors.grey.shade800.withAlpha(51)
                                : Colors.grey.withAlpha(26),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.electricity,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            errorText: _meterErrorText.isNotEmpty
                                ? _meterErrorText
                                : null,
                            errorStyle: TextStyle(
                              color: Colors.red[400],
                              fontSize: 12,
                            ),
                            helperText: _selectedProvider.isNotEmpty
                                ? 'Enter your ${_getProviderName(_selectedProvider)} meter number'
                                : null,
                            helperStyle: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 12,
                            ),
                            enabled: _selectedProvider.isNotEmpty &&
                                !_customerVerified,
                          ),
                          style: TextStyle(color: textColor),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      Spacing.horizontalS,
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isVerifying ||
                                    _customerVerified ||
                                    _selectedProvider.isEmpty
                                ? null
                                : _verifyMeter,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDarkMode
                                  ? AppColors.electricity.withAlpha(204)
                                  : AppColors.electricity,
                              foregroundColor: Colors.white,
                              elevation: isDarkMode ? 4 : 2,
                              shadowColor: AppColors.electricity.withAlpha(102),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            child: _isVerifying
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : _customerVerified
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.check, size: 16),
                                          Spacing.horizontalXS,
                                          const Text('Verified'),
                                        ],
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Iconsax.tick_circle, size: 16),
                                          Spacing.horizontalXS,
                                          const Text('Verify'),
                                        ],
                                      ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Customer details section with enhanced design
                  if (_customerVerified) ...[
                    Spacing.verticalM,
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDarkMode
                              ? [
                                  AppColors.success.withAlpha(51),
                                  AppColors.success.withAlpha(13),
                                ]
                              : [
                                  AppColors.success.withAlpha(26),
                                  AppColors.success.withAlpha(8),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              AppColors.success.withAlpha(isDarkMode ? 76 : 51),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.success.withAlpha(26),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withAlpha(51),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Iconsax.user,
                                  size: 14,
                                  color: AppColors.success,
                                ),
                              ),
                              Spacing.horizontalS,
                              AppText.titleSmall(
                                'Customer Details',
                                color: AppColors.success,
                              ),
                            ],
                          ),
                          Spacing.verticalM,
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: secondaryTextColor,
                                      ),
                                    ),
                                    Spacing.verticalXS,
                                    Text(
                                      _customerName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 1,
                                color: isDarkMode
                                    ? Colors.grey.withAlpha(76)
                                    : Colors.grey.withAlpha(51),
                              ),
                              Spacing.horizontalM,
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Address',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: secondaryTextColor,
                                      ),
                                    ),
                                    Spacing.verticalXS,
                                    Text(
                                      _customerAddress,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],

                  Spacing.verticalXL,

                  // Enhanced payment details section
                  if (_customerVerified) ...[
                    Row(
                      children: [
                        Icon(
                          Iconsax.money,
                          size: 18,
                          color: AppColors.electricity,
                        ),
                        Spacing.horizontalS,
                        AppText.titleMedium(
                          'Payment Details',
                          color: textColor,
                        ),
                      ],
                    ),
                    Spacing.verticalM,

                    // Smart amount input with currency formatting
                    TextField(
                      controller: _amountController,
                      focusNode: _amountFocus,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        labelStyle: TextStyle(
                          color: _amountFocus.hasFocus
                              ? AppColors.electricity
                              : secondaryTextColor,
                          fontSize: 14,
                        ),
                        hintText: 'Enter amount (₦100 - ₦50,000)',
                        hintStyle: TextStyle(
                          color: secondaryTextColor.withAlpha(179),
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Iconsax.money,
                          color: _amountFocus.hasFocus
                              ? AppColors.electricity
                              : secondaryTextColor,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: isDarkMode
                            ? Colors.grey.shade800.withAlpha(51)
                            : Colors.grey.withAlpha(26),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.electricity,
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        helperText: 'Amount will be charged to your account',
                        helperStyle: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 12,
                        ),
                      ),
                      style: TextStyle(color: textColor),
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) =>
                          _fieldFocusChange(_amountFocus, _phoneFocus),
                    ),

                    Spacing.verticalM,

                    // Smart phone number input
                    TextField(
                      controller: _phoneController,
                      focusNode: _phoneFocus,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(
                          color: _phoneFocus.hasFocus
                              ? AppColors.electricity
                              : secondaryTextColor,
                          fontSize: 14,
                        ),
                        hintText: 'Enter your phone number',
                        hintStyle: TextStyle(
                          color: secondaryTextColor.withAlpha(179),
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Iconsax.mobile,
                          color: _phoneFocus.hasFocus
                              ? AppColors.electricity
                              : secondaryTextColor,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: isDarkMode
                            ? Colors.grey.shade800.withAlpha(51)
                            : Colors.grey.withAlpha(26),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.electricity,
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        errorText:
                            _phoneErrorText.isNotEmpty ? _phoneErrorText : null,
                        errorStyle: TextStyle(
                          color: Colors.red[400],
                          fontSize: 12,
                        ),
                        helperText: 'Nigerian phone number with +234 prefix',
                        helperStyle: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 12,
                        ),
                      ),
                      style: TextStyle(color: textColor),
                      keyboardType: TextInputType.phone,
                    ),

                    Spacing.verticalXXL,

                    // Enhanced proceed button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isProcessing ? null : _processPayment,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          elevation: isDarkMode ? 8 : 4,
                          shadowColor: AppColors.electricity.withAlpha(102),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ).copyWith(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return isDarkMode
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade400;
                              }
                              return isDarkMode
                                  ? AppColors.electricity.withAlpha(204)
                                  : AppColors.electricity;
                            },
                          ),
                        ),
                        child: _isProcessing
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.flash_1,
                                    size: 20,
                                  ),
                                  Spacing.horizontalM,
                                  Text(
                                    'Pay Electricity Bill',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ] else ...[
                    // Prompt to select provider and verify meter
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDarkMode
                              ? [
                                  AppColors.info.withAlpha(51),
                                  AppColors.info.withAlpha(13),
                                ]
                              : [
                                  AppColors.info.withAlpha(26),
                                  AppColors.info.withAlpha(8),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.info.withAlpha(isDarkMode ? 76 : 51),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Iconsax.info_circle,
                            color: AppColors.info,
                            size: 32,
                          ),
                          Spacing.verticalM,
                          AppText.titleMedium(
                            'Verify Your Meter',
                            color: textColor,
                            textAlign: TextAlign.center,
                          ),
                          Spacing.verticalS,
                          AppText.bodyMedium(
                            'Select your electricity provider and verify your meter number to proceed with payment.',
                            color: secondaryTextColor,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],

                  Spacing.verticalL,

                  // Enhanced safety notice
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.grey.shade900.withAlpha(128)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Iconsax.shield_tick,
                          color: accentColor,
                          size: 20,
                        ),
                        Spacing.horizontalM,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Secure Payment',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                  fontSize: 14,
                                ),
                              ),
                              Spacing.verticalXS,
                              Text(
                                'Your bill payment will be processed immediately. For prepaid meters, a token will be generated.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: secondaryTextColor,
                                ),
                              ),
                            ],
                          ),
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

  Widget _buildProviderCard({
    required Map<String, dynamic> provider,
    required bool isSelected,
    required bool isDarkMode,
  }) {
    final Color providerColor = provider['color'] as Color;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedProvider = provider['id'] as String;
          // Reset verification when provider changes
          _customerVerified = false;
          _meterNumberController.clear();
          _formatMeterNumber();
        });

        // Play animation
        _animationController.reset();
        _animationController.forward();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    providerColor.withAlpha(isDarkMode ? 76 : 51),
                    providerColor.withAlpha(isDarkMode ? 26 : 13),
                  ],
                )
              : null,
          color: isSelected
              ? null
              : isDarkMode
                  ? AppColors.backgroundDarkSecondary
                  : AppColors.backgroundLightSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? providerColor
                : isDarkMode
                    ? Colors.grey.withAlpha(51)
                    : Colors.grey.withAlpha(76),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: providerColor.withAlpha(isDarkMode ? 76 : 51),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Enhanced provider icon with animation
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    providerColor.withAlpha(isDarkMode ? 76 : 51),
                    providerColor.withAlpha(isDarkMode ? 26 : 13),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: providerColor.withAlpha(76),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
              ),
              child: Icon(
                provider['icon'] as IconData,
                color:
                    isSelected ? providerColor : providerColor.withAlpha(179),
                size: 24,
              ),
            ),
            Spacing.verticalM,
            Text(
              provider['name'] as String,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? providerColor
                    : isDarkMode
                        ? AppColors.textDarkPrimary
                        : AppColors.textLightPrimary,
              ),
            ),

            // Show selected indicator
            if (isSelected) ...[
              Spacing.verticalS,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: providerColor.withAlpha(51),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check,
                      color: providerColor,
                      size: 12,
                    ),
                    Spacing.horizontalXS,
                    Text(
                      'Selected',
                      style: TextStyle(
                        fontSize: 10,
                        color: providerColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMeterTypeButton({
    required String label,
    required String value,
    required bool isDarkMode,
  }) {
    final bool isSelected = _selectedMeterType == value;
    final Color selectedColor = AppColors.electricity;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMeterType = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    selectedColor.withAlpha(isDarkMode ? 76 : 51),
                    selectedColor.withAlpha(isDarkMode ? 26 : 13),
                  ],
                )
              : null,
          color: isSelected
              ? null
              : isDarkMode
                  ? AppColors.backgroundDarkSecondary
                  : AppColors.backgroundLightSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? selectedColor
                : isDarkMode
                    ? Colors.grey.withAlpha(51)
                    : Colors.grey.withAlpha(76),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: selectedColor.withAlpha(isDarkMode ? 76 : 51),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? selectedColor.withAlpha(51)
                    : isDarkMode
                        ? Colors.grey.withAlpha(51)
                        : Colors.grey.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(
                value == 'prepaid' ? Iconsax.card : Iconsax.receipt,
                color: isSelected
                    ? selectedColor
                    : isDarkMode
                        ? AppColors.textDarkSecondary
                        : AppColors.textLightSecondary,
                size: 16,
              ),
            ),
            Spacing.horizontalS,
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? selectedColor
                    : isDarkMode
                        ? AppColors.textDarkPrimary
                        : AppColors.textLightPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _fieldFocusChange(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
