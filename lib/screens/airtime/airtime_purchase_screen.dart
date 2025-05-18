// lib/screens/airtime/airtime_purchase_screen.dart (Updated)
import 'dart:math' as Math;

import 'package:deepex/components/button_base.dart';
import 'package:deepex/components/custom_form_field.dart';
import 'package:deepex/components/primary_button.dart';
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:deepex/models/airtime_model.dart';
import 'package:deepex/utilities/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../widgets/airtime_widget.dart';

class AirtimePurchaseScreen extends StatefulWidget {
  const AirtimePurchaseScreen({super.key});

  @override
  State<AirtimePurchaseScreen> createState() => _AirtimePurchaseScreenState();
}

class _AirtimePurchaseScreenState extends State<AirtimePurchaseScreen>
    with SingleTickerProviderStateMixin {
  // Form controllers
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Focus nodes
  final _phoneFocus = FocusNode();
  final _amountFocus = FocusNode();

  // Step controller for purchase flow
  late TabController _tabController;

  // State variables
  String _selectedNetwork = '';
  double _selectedAmount = 1000; // Default amount
  bool _isProcessing = false;
  List<String> _recentNumbers = [];
  bool _showThankYou = false;

  // Predefined amounts
  final List<double> _quickAmounts = [100, 200, 500, 1000, 2000, 5000];

  // Network definitions with colors
  final List<Map<String, dynamic>> _networks = [
    {
      'name': 'MTN',
      'icon': 'assets/images/networks/mtn.png',
      'color': const Color(0xFFFFCC00), // MTN Yellow
      'darkColor': const Color(0xFFFFD633), // Brighter yellow for dark mode
    },
    {
      'name': 'Airtel',
      'icon': 'assets/images/networks/airtel.png',
      'color': const Color(0xFFFF0000), // Airtel Red
      'darkColor': const Color(0xFFFF3333), // Brighter red for dark mode
    },
    {
      'name': 'Glo',
      'icon': 'assets/images/networks/glo.png',
      'color': const Color(0xFF00AB4E), // Glo Green
      'darkColor': const Color(0xFF33C974), // Brighter green for dark mode
    },
    {
      'name': '9mobile',
      'icon': 'assets/images/networks/9mobile.png',
      'color': const Color(0xFF006633), // 9mobile Green
      'darkColor': const Color(0xFF339966), // Brighter green for dark mode
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Listen for phone number changes to detect network
    _phoneController.addListener(_detectNetwork);

    // Load recent numbers from storage
    _loadRecentNumbers();

    // Start with default amount
    _amountController.text = _selectedAmount.toString();
  }

  @override
  void dispose() {
    _phoneController.removeListener(_detectNetwork);
    _phoneController.dispose();
    _amountController.dispose();
    _phoneFocus.dispose();
    _amountFocus.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Load recently used phone numbers
  Future<void> _loadRecentNumbers() async {
    final recentNumbers = await AirtimeService.getRecentNumbers();
    setState(() {
      _recentNumbers = recentNumbers;
    });
  }

  // Auto-detect network from phone number
  void _detectNetwork() {
    if (_phoneController.text.length >= 4) {
      final network =
          AirtimeService.detectNetworkProvider(_phoneController.text);
      if (network.isNotEmpty && network != _selectedNetwork) {
        setState(() {
          _selectedNetwork = network;
        });
      }
    }
  }

  // Select a network provider
  void _selectNetwork(String network) {
    setState(() {
      _selectedNetwork = network;
    });

    // Auto-advance to the next step if phone number is already entered
    if (_phoneController.text.isNotEmpty) {
      _tabController.animateTo(1);
    }
  }

  // Select an amount from quick options
  void _selectAmount(double amount) {
    setState(() {
      _selectedAmount = amount;
      _amountController.text = amount.toString();
    });

    // Auto-advance to the next step
    _tabController.animateTo(2);
  }

  // Handle selecting a recent phone number
  void _selectRecentNumber(String number) {
    setState(() {
      _phoneController.text = number;

      // Also detect the network
      final network = AirtimeService.detectNetworkProvider(number);
      if (network.isNotEmpty) {
        _selectedNetwork = network;
      }
    });

    // Move to the next step
    _tabController.animateTo(1);
  }

  // Format phone number for display
  String _formatPhoneNumber(String number) {
    return AirtimeService.formatPhoneNumber(number);
  }

  // Get network color based on selected network
  Color _getNetworkColor(bool isDarkMode) {
    final networkIndex =
        _networks.indexWhere((n) => n['name'] == _selectedNetwork);
    if (networkIndex != -1) {
      return isDarkMode
          ? _networks[networkIndex]['darkColor'] as Color
          : _networks[networkIndex]['color'] as Color;
    }
    return isDarkMode ? AppColors.primaryLight : AppColors.primary;
  }

  // Validate form before proceeding
  bool _validateForm() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    if (_selectedNetwork.isEmpty) {
      SnackBarUtils.showError(context, 'Please select a network provider');
      return false;
    }

    if (_selectedAmount <= 0) {
      SnackBarUtils.showError(context, 'Please enter a valid amount');
      return false;
    }

    return true;
  }

  // Process the airtime purchase
  Future<void> _processPurchase() async {
    if (!_validateForm()) return;

    // Show loading state
    setState(() {
      _isProcessing = true;
    });

    try {
      // Store recent number
      await AirtimeService.saveRecentNumber(_phoneController.text);

      // Create purchase record
      final purchase = AirtimeModel(
        network: _selectedNetwork,
        phoneNumber: _phoneController.text,
        formattedNumber:
            AirtimeService.formatPhoneNumber(_phoneController.text),
        amount: _selectedAmount,
        timestamp: DateTime.now(),
      );

      // Save purchase history
      await AirtimeService.savePurchase(purchase);

      // Simulate API call - would be a real payment processor in production
      await Future.delayed(const Duration(milliseconds: 1500));

      // Show success
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _showThankYou = true;
        });

        // Reload recent numbers in case it changed
        _loadRecentNumbers();

        // Automatically go back to home after a delay
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            _showPurchaseSuccessDialog();
          }
        });
      }
    } catch (e) {
      // Show error
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        SnackBarUtils.showError(context, 'Failed to process purchase: $e');
      }
    }
  }

  // Show success dialog and navigate back
  Future<void> _showPurchaseSuccessDialog() async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color:
                  isDarkMode ? AppColors.backgroundDarkElevated : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success animation
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 24),

                // Success message
                Text(
                  'Purchase Successful!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? AppColors.textDarkPrimary
                        : AppColors.textLightPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  'You have successfully purchased ₦${_selectedAmount.toInt()} airtime for ${_formatPhoneNumber(_phoneController.text)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode
                        ? AppColors.textDarkSecondary
                        : AppColors.textLightSecondary,
                  ),
                ),
                const SizedBox(height: 24),

                // Done button
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDarkMode ? AppColors.primaryLight : AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final networkColor = _getNetworkColor(isDarkMode);
    final themeColor = isDarkMode ? AppColors.primaryLight : AppColors.primary;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: isDarkMode
                ? AppColors.backgroundDarkSecondary.withOpacity(0.6)
                : AppColors.backgroundLightSecondary,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDarkMode
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary,
                size: 20,
              ),
              onPressed: () => context.pop(),
            ),
          ),
        ),
        title: Text(
          'Buy Airtime',
          style: TextStyle(
            color: isDarkMode
                ? AppColors.textDarkPrimary
                : AppColors.textLightPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress indicator
                  LinearProgressIndicator(
                    value: (_tabController.index + 1) / 3,
                    backgroundColor: isDarkMode
                        ? AppColors.backgroundDarkSecondary
                        : AppColors.backgroundLightSecondary,
                    color: networkColor,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),

                  Spacing.verticalL,

                  // Main content area - tabbed
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        // Step 1: Enter phone number
                        _buildPhoneNumberStep(isDarkMode, networkColor),

                        // Step 2: Select network and amount
                        _buildNetworkAndAmountStep(isDarkMode, networkColor),

                        // Step 3: Confirm purchase
                        _buildConfirmationStep(isDarkMode, networkColor),
                      ],
                    ),
                  ),

                  // Back/Next navigation
                  Spacing.verticalM,
                  _buildNavigationButtons(isDarkMode, themeColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Step 1: Phone number entry
  Widget _buildPhoneNumberStep(bool isDarkMode, Color networkColor) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step title
          AppText.headingLarge(
            'Enter Phone Number',
            color: isDarkMode
                ? AppColors.textDarkPrimary
                : AppColors.textLightPrimary,
          ),
          Spacing.verticalS,
          AppText.bodyMedium(
            'Please enter the phone number you want to recharge',
            color: isDarkMode
                ? AppColors.textDarkSecondary
                : AppColors.textLightSecondary,
          ),
          Spacing.verticalL,

          // Phone number field with auto-complete and network detection
          CustomFormField(
            label: 'Phone Number',
            hint: '0803 123 4567',
            controller: _phoneController,
            focusNode: _phoneFocus,
            inputType: InputFieldType.phone,
            isRequired: true,
            prefixIcon: Icon(
              Iconsax.mobile,
              color: _selectedNetwork.isNotEmpty
                  ? networkColor
                  : (isDarkMode ? AppColors.secondaryLight : AppColors.primary),
            ),
            suffixIcon: _selectedNetwork.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/networks/${_selectedNetwork.toLowerCase()}.png',
                      height: 20,
                      width: 20,
                      // Fallback to text if image not found
                      errorBuilder: (context, error, stackTrace) => Text(
                        _selectedNetwork,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: networkColor,
                        ),
                      ),
                    ),
                  )
                : null,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Phone number is required';
              }
              // Remove formatting characters for validation
              final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
              if (digitsOnly.length != 11) {
                return 'Enter a valid 11-digit Nigerian phone number';
              }
              return null;
            },
            textInputAction: TextInputAction.next,
            onSubmitted: (_) {
              // Move to next step when user presses enter/done
              if (_phoneController.text.isNotEmpty) {
                _tabController.animateTo(1);
              }
            },
            // Format phone number as user types with a limit of 11 digits
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              TextInputFormatter.withFunction((oldValue, newValue) {
                // Get the raw digits
                String text = newValue.text;
                if (text.isEmpty) return newValue;

                // Limit to 11 digits
                if (text.length > 11) {
                  text = text.substring(0, 11);
                }

                // Format as 0803 123 4567
                String formatted = '';

                if (text.length >= 4) {
                  formatted += text.substring(0, 4) + ' ';
                } else {
                  return TextEditingValue(
                    text: text,
                    selection: TextSelection.collapsed(offset: text.length),
                  );
                }

                if (text.length >= 7) {
                  formatted += text.substring(4, 7) + ' ';
                } else if (text.length > 4) {
                  formatted += text.substring(4);
                }

                if (text.length > 7) {
                  formatted += text.substring(7, Math.min(11, text.length));
                }

                return TextEditingValue(
                  text: formatted,
                  selection: TextSelection.collapsed(offset: formatted.length),
                );
              }),
            ],
          ),

          Spacing.verticalL,

          // Recent numbers section (if any)
          if (_recentNumbers.isNotEmpty) ...[
            AppText.titleMedium(
              'Recent Numbers',
              color: isDarkMode
                  ? AppColors.textDarkPrimary
                  : AppColors.textLightPrimary,
            ),
            Spacing.verticalM,

            // Horizontal list of recent numbers
            RecentNumbersList(
              recentNumbers: _recentNumbers,
              onNumberSelected: _selectRecentNumber,
              formatPhoneNumber: _formatPhoneNumber,
            ),
          ],

          Spacing.verticalXL,

          // Network selection hint
          if (_selectedNetwork.isNotEmpty) ...[
            AppText.bodyMedium(
              'Network detected: $_selectedNetwork',
              color: networkColor,
            ),
          ] else ...[
            AppText.bodyMedium(
              'Enter a valid phone number to detect network or select it in the next step',
              color: isDarkMode
                  ? AppColors.textDarkSecondary
                  : AppColors.textLightSecondary,
            ),
          ],
        ],
      ),
    );
  }

  // Step 2: Network and amount selection
  Widget _buildNetworkAndAmountStep(bool isDarkMode, Color networkColor) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step title
          AppText.headingLarge(
            'Select Network & Amount',
            color: isDarkMode
                ? AppColors.textDarkPrimary
                : AppColors.textLightPrimary,
          ),
          Spacing.verticalS,
          AppText.bodyMedium(
            'Choose your provider and how much you want to recharge',
            color: isDarkMode
                ? AppColors.textDarkSecondary
                : AppColors.textLightSecondary,
          ),
          Spacing.verticalL,

          // Network grid
          AppText.titleMedium(
            'Network Provider',
            color: isDarkMode
                ? AppColors.textDarkPrimary
                : AppColors.textLightPrimary,
          ),
          Spacing.verticalM,

          NetworkSelectionGrid(
            networks: _networks,
            selectedNetwork: _selectedNetwork,
            onNetworkSelected: _selectNetwork,
            animateIn: true,
          ),

          Spacing.verticalXL,

          // Amount selection
          AppText.titleMedium(
            'Recharge Amount',
            color: isDarkMode
                ? AppColors.textDarkPrimary
                : AppColors.textLightPrimary,
          ),
          Spacing.verticalM,

          // Amount quick selection chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _quickAmounts.length,
              itemBuilder: (context, index) {
                final amount = _quickAmounts[index];
                final isSelected = _selectedAmount == amount;

                return Padding(
                  padding: EdgeInsets.only(
                    right: index < _quickAmounts.length - 1 ? 10 : 0,
                  ),
                  child: ChoiceChip(
                    label: Text(
                      '₦${amount.toInt()}',
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : isDarkMode
                                ? Colors.white70
                                : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    backgroundColor: isDarkMode
                        ? AppColors.backgroundDarkSecondary
                        : AppColors.backgroundLightSecondary,
                    selectedColor: networkColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    onSelected: (bool selected) {
                      if (selected) {
                        _selectAmount(amount);
                      }
                    },
                  ),
                );
              },
            ),
          ),

          Spacing.verticalM,

          // Custom amount field
          CustomFormField(
            label: 'Custom Amount',
            hint: 'Enter amount',
            controller: _amountController,
            focusNode: _amountFocus,
            isRequired: true,
            inputType: InputFieldType.number,
            textInputAction: TextInputAction.done,
            prefixIcon: Icon(
              Iconsax.money,
              color: networkColor,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Amount is required';
              }
              final amount = double.tryParse(value);
              if (amount == null) {
                return 'Enter a valid amount';
              }
              if (amount < 50) {
                return 'Minimum amount is ₦50';
              }
              if (amount > 50000) {
                return 'Maximum amount is ₦50,000';
              }
              return null;
            },
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  _selectedAmount = double.tryParse(value) ?? _selectedAmount;
                });
              }
            },
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onSubmitted: (_) {
              // Move to next step when user presses enter/done
              if (_amountController.text.isNotEmpty) {
                final amount = double.tryParse(_amountController.text);
                if (amount != null && amount >= 50) {
                  setState(() {
                    _selectedAmount = amount;
                  });
                  _tabController.animateTo(2);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  // Step 3: Confirmation
  Widget _buildConfirmationStep(bool isDarkMode, Color networkColor) {
    // If showing thank you screen
    if (_showThankYou) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 60,
              ),
            ),
            Spacing.verticalL,
            AppText.headingLarge(
              'Thank You!',
              color: isDarkMode
                  ? AppColors.textDarkPrimary
                  : AppColors.textLightPrimary,
            ),
            Spacing.verticalS,
            AppText.bodyLarge(
              'Your airtime purchase was successful',
              color: isDarkMode
                  ? AppColors.textDarkSecondary
                  : AppColors.textLightSecondary,
            ),
            Spacing.verticalM,
            AppText.bodyMedium(
              'You will be redirected to the home screen shortly...',
              color: isDarkMode
                  ? AppColors.textDarkSecondary
                  : AppColors.textLightSecondary,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step title
          AppText.headingLarge(
            'Confirm Purchase',
            color: isDarkMode
                ? AppColors.textDarkPrimary
                : AppColors.textLightPrimary,
          ),
          Spacing.verticalS,
          AppText.bodyMedium(
            'Please review your airtime purchase details',
            color: isDarkMode
                ? AppColors.textDarkSecondary
                : AppColors.textLightSecondary,
          ),
          Spacing.verticalXL,

          // Purchase summary card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color:
                  isDarkMode ? AppColors.backgroundDarkSecondary : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: networkColor.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Network logo/icon
                Container(
                  width: 80,
                  height: 80,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: networkColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/networks/${_selectedNetwork.toLowerCase()}.png',
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Iconsax.mobile,
                      color: networkColor,
                      size: 36,
                    ),
                  ),
                ),
                Spacing.verticalL,

                // Purchase details with network-themed styling
                _buildSummaryRow(
                  'Network:',
                  _selectedNetwork,
                  isDarkMode,
                  networkColor,
                ),
                Spacing.verticalM,

                _buildSummaryRow(
                  'Phone Number:',
                  _formatPhoneNumber(_phoneController.text),
                  isDarkMode,
                  networkColor,
                ),
                Spacing.verticalM,

                _buildSummaryRow(
                  'Amount:',
                  '₦${_selectedAmount.toInt()}',
                  isDarkMode,
                  networkColor,
                  isHighlighted: true,
                ),

                Spacing.verticalXL,

                // Safety notice
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.infoLight.withOpacity(0.1)
                        : AppColors.infoLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Iconsax.info_circle,
                        color: AppColors.info,
                        size: 20,
                      ),
                      Spacing.horizontalS,
                      Expanded(
                        child: Text(
                          'Please check that the details above are correct before proceeding.',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? Colors.white : AppColors.info,
                          ),
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
    );
  }

  // Helper: Summary row builder
  Widget _buildSummaryRow(
      String label, String value, bool isDarkMode, Color networkColor,
      {bool isHighlighted = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode
                ? AppColors.textDarkSecondary
                : AppColors.textLightSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            color: isHighlighted
                ? networkColor
                : (isDarkMode
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary),
          ),
        ),
      ],
    );
  }

  // Navigation buttons for the steps - FIXED: Using themeColor instead of networkColor
  Widget _buildNavigationButtons(bool isDarkMode, Color themeColor) {
    // In processing state, show loading button
    if (_isProcessing) {
      return PrimaryButton(
        text: 'Processing...',
        onPressed: null,
        isLoading: true,
        size: ButtonSize.large,
      );
    }

    // Thank you screen - show home button
    if (_showThankYou) {
      return PrimaryButton(
        text: 'Back to Home',
        onPressed: () => context.go('/home'),
        backgroundColor: themeColor, // Using theme color
        size: ButtonSize.large,
      );
    }

    // First step - next only
    if (_tabController.index == 0) {
      return Row(
        children: [
          Expanded(
            child: PrimaryButton(
              text: 'Next',
              onPressed: () {
                if (_phoneController.text.isNotEmpty) {
                  // Validate phone number format
                  if (_formKey.currentState!.validate()) {
                    _tabController.animateTo(1);
                  }
                } else {
                  SnackBarUtils.showError(
                      context, 'Please enter a phone number');
                }
              },
              backgroundColor: themeColor, // Using theme color
              size: ButtonSize.large,
            ),
          ),
        ],
      );
    }

    // Last step - process purchase
    if (_tabController.index == 2) {
      return Row(
        children: [
          // Back button
          SizedBox(
            width: 60,
            height: 56,
            child: OutlinedButton(
              onPressed: () {
                _tabController.animateTo(1);
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: isDarkMode
                      ? Colors.grey.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Icon(
                Icons.arrow_back,
                color: isDarkMode
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary,
              ),
            ),
          ),
          Spacing.horizontalS,

          // Process button
          Expanded(
            child: PrimaryButton(
              text: 'Buy Airtime',
              onPressed: _processPurchase,
              backgroundColor: themeColor, // Using theme color
              size: ButtonSize.large,
            ),
          ),
        ],
      );
    }

    // Middle steps - back and next
    return Row(
      children: [
        // Back button
        SizedBox(
          width: 60,
          height: 56,
          child: OutlinedButton(
            onPressed: () {
              _tabController.animateTo(_tabController.index - 1);
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isDarkMode
                    ? Colors.grey.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.5),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Icon(
              Icons.arrow_back,
              color: isDarkMode
                  ? AppColors.textDarkPrimary
                  : AppColors.textLightPrimary,
            ),
          ),
        ),
        Spacing.horizontalS,

        // Next button
        Expanded(
          child: PrimaryButton(
            text: 'Next',
            onPressed: () {
              // Validate form before proceeding
              if (_formKey.currentState!.validate()) {
                if (_selectedNetwork.isEmpty) {
                  SnackBarUtils.showError(
                      context, 'Please select a network provider');
                  return;
                }

                // Try to parse amount
                final amount = double.tryParse(_amountController.text);
                if (amount != null) {
                  setState(() {
                    _selectedAmount = amount;
                  });
                }

                _tabController.animateTo(_tabController.index + 1);
              }
            },
            backgroundColor: themeColor, // Using theme color
            size: ButtonSize.large,
          ),
        ),
      ],
    );
  }
}
