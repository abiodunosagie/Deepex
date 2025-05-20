// lib/screens/utilities/tv_cable_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class TvSubscriptionScreen extends StatefulWidget {
  const TvSubscriptionScreen({super.key});

  @override
  State<TvSubscriptionScreen> createState() => _TvSubscriptionScreenState();
}

class _TvSubscriptionScreenState extends State<TvSubscriptionScreen>
    with SingleTickerProviderStateMixin {
  // Controllers and focus nodes
  final _smartCardController = TextEditingController();
  final _phoneController = TextEditingController();
  final _smartCardFocus = FocusNode();
  final _phoneFocus = FocusNode();

  // Animation controller for transitions
  late AnimationController _animationController;

  // Form state
  String _selectedProvider = 'dstv';
  String _selectedPackage = 'dstv-premium';
  String _selectedPaymentMethod = 'wallet';
  bool _isCardValidated = false;
  bool _isValidatingCard = false;
  bool _isProcessing = false;
  String? _customerName;
  String _phoneErrorText = '';
  String _smartCardErrorText = '';

  // TV Providers with brand colors
  final List<Map<String, dynamic>> _providers = [
    {
      'id': 'dstv',
      'name': 'DSTV',
      'icon': Iconsax.monitor,
      'color': const Color(0xFF001F63),
      'lightColor': const Color(0xFF2969D1),
      'cardDigits': 10,
    },
    {
      'id': 'gotv',
      'name': 'GOTV',
      'icon': Iconsax.monitor,
      'color': const Color(0xFF9CC735),
      'lightColor': const Color(0xFFB8E245),
      'cardDigits': 10,
    },
    {
      'id': 'startimes',
      'name': 'Startimes',
      'icon': Iconsax.video_play,
      'color': const Color(0xFFD81F26),
      'lightColor': const Color(0xFFFF4C52),
      'cardDigits': 11,
    },
    {
      'id': 'showmax',
      'name': 'Showmax',
      'icon': Iconsax.play_circle,
      'color': const Color(0xFF2469D1),
      'lightColor': const Color(0xFF4C8FE4),
      'cardDigits': 12,
    },
  ];

  // Subscription packages
  final Map<String, List<Map<String, dynamic>>> _packages = {
    'dstv': [
      {
        'id': 'dstv-premium',
        'name': 'Premium',
        'price': 24500,
        'description': 'All channels in HD',
      },
      {
        'id': 'dstv-compact-plus',
        'name': 'Compact Plus',
        'price': 16600,
        'description': 'Most channels in HD',
      },
      {
        'id': 'dstv-compact',
        'name': 'Compact',
        'price': 10500,
        'description': 'Entertainment & sports',
      },
    ],
    'gotv': [
      {
        'id': 'gotv-max',
        'name': 'GOtv Max',
        'price': 4850,
        'description': 'Premium entertainment',
      },
      {
        'id': 'gotv-jolli',
        'name': 'GOtv Jolli',
        'price': 3300,
        'description': 'Entertainment & sports',
      },
    ],
    'startimes': [
      {
        'id': 'startimes-super',
        'name': 'Super',
        'price': 4900,
        'description': 'Premium channels & more',
      },
      {
        'id': 'startimes-classic',
        'name': 'Classic',
        'price': 2600,
        'description': 'Popular channels',
      },
    ],
    'showmax': [
      {
        'id': 'showmax-premium',
        'name': 'Premium',
        'price': 5900,
        'description': 'Movies, series & more',
      },
      {
        'id': 'showmax-mobile',
        'name': 'Mobile',
        'price': 2900,
        'description': 'Mobile streaming only',
      },
    ],
  };

  // Payment methods
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'wallet',
      'name': 'Wallet Balance',
      'icon': Iconsax.wallet,
    },
    {
      'id': 'card',
      'name': 'Card Payment',
      'icon': Iconsax.card,
    },
    {
      'id': 'ussd',
      'name': 'USSD Transfer',
      'icon': Iconsax.mobile,
    },
    {
      'id': 'bank',
      'name': 'Bank Transfer',
      'icon': Iconsax.bank,
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

    // Make sure we select a valid initial package
    _ensureValidPackageSelected();

    // Add listeners to text controllers
    _phoneController.addListener(_formatPhoneNumber);
    _smartCardController.addListener(_validateSmartCardFormat);
  }

  void _ensureValidPackageSelected() {
    if (_packages.containsKey(_selectedProvider)) {
      final packages = _packages[_selectedProvider]!;
      if (packages.isNotEmpty) {
        setState(() {
          _selectedPackage = packages.first['id'];
        });
      }
    }
  }

  @override
  void dispose() {
    _smartCardController.dispose();
    _phoneController.dispose();
    _smartCardFocus.dispose();
    _phoneFocus.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Find the currently selected provider
  Map<String, dynamic> get currentProvider {
    return _providers.firstWhere(
      (provider) => provider['id'] == _selectedProvider,
      orElse: () => _providers.first,
    );
  }

  // Get the currently selected package
  Map<String, dynamic>? get currentPackage {
    if (_selectedPackage.isEmpty || !_packages.containsKey(_selectedProvider)) {
      return null;
    }

    final packages = _packages[_selectedProvider]!;
    if (packages.isEmpty) {
      return null;
    }

    return packages.firstWhere(
      (package) => package['id'] == _selectedPackage,
      orElse: () => packages.first,
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

  // Validate smart card number format
  void _validateSmartCardFormat() {
    final text = _smartCardController.text.replaceAll(RegExp(r'[^\d]'), '');
    final requiredDigits = currentProvider['cardDigits'] as int;

    if (text.isEmpty) {
      setState(() {
        _smartCardErrorText = '';
      });
      return;
    }

    if (text.length > requiredDigits) {
      setState(() {
        _smartCardErrorText =
            '${currentProvider['name']} smart card should have $requiredDigits digits';

        // Trim the text to required length
        final trimmedText = text.substring(0, requiredDigits);
        _smartCardController.value = TextEditingValue(
          text: trimmedText,
          selection: TextSelection.collapsed(offset: trimmedText.length),
        );
      });
    } else if (text.length < requiredDigits) {
      setState(() {
        _smartCardErrorText = 'Enter all $requiredDigits digits';
      });
    } else {
      setState(() {
        _smartCardErrorText = '';
      });
    }
  }

  // Mock validation process
  Future<void> _validateSmartCard() async {
    if (_smartCardController.text.isEmpty) {
      _showSnackBar('Please enter a smart card number', isError: true);
      return;
    }

    final text = _smartCardController.text.replaceAll(RegExp(r'[^\d]'), '');
    final requiredDigits = currentProvider['cardDigits'] as int;

    if (text.length != requiredDigits) {
      _showSnackBar(
          'Please enter a valid ${requiredDigits}-digit smart card number',
          isError: true);
      return;
    }

    setState(() => _isValidatingCard = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _isValidatingCard = false;
      _isCardValidated = true;
      _customerName = 'John Adewole';

      // Move focus to phone field
      _smartCardFocus.unfocus();
      FocusScope.of(context).requestFocus(_phoneFocus);
    });

    _showSnackBar('Smart card validated successfully');
  }

  // Mock payment process
  Future<void> _processPayment() async {
    // Validate smart card
    if (_smartCardController.text.isEmpty || _smartCardErrorText.isNotEmpty) {
      _showSnackBar('Please enter a valid smart card number', isError: true);
      return;
    }

    // Validate phone number
    if (_phoneController.text.isEmpty || _phoneErrorText.isNotEmpty) {
      _showSnackBar('Please enter a valid phone number', isError: true);
      return;
    }

    if (!_isCardValidated) {
      _showSnackBar('Please validate your smart card first', isError: true);
      return;
    }

    setState(() => _isProcessing = true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    setState(() => _isProcessing = false);

    // Navigate to success screen with transaction data
    final packageData = currentPackage;
    if (packageData == null) {
      _showSnackBar('Package not found', isError: true);
      return;
    }

    final transactionData = {
      'provider': currentProvider['name'],
      'packageName': packageData['name'],
      'smartCardNumber': _smartCardController.text,
      'amount': packageData['price'],
      'customerName': _customerName,
      'paymentMethod': _selectedPaymentMethod,
      'transactionId':
          'TV${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      'validityDays': 30,
    };

    // Mock navigation to success screen
    _showSnackBar('Payment successful!');

    // In a real app, you would navigate to success screen:
    // context.push('/utilities/tv/success', extra: transactionData);
  }

  // Helper to show snackbar
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Enhanced colors for dark mode
    final primaryColor =
        isDarkMode ? const Color(0xFF7986CB) : const Color(0xFF5C6BC0);

    final backgroundColor = isDarkMode ? const Color(0xFF121212) : Colors.white;

    final cardColor =
        isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5);

    // Enhanced tertiary colors
    final tertiaryColor =
        isDarkMode ? const Color(0xFF303F9F) : const Color(0xFF3949AB);

    final accentColor =
        isDarkMode ? const Color(0xFF64FFDA) : const Color(0xFF00BFA5);

    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final secondaryTextColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.grey.shade800.withOpacity(0.4)
                : Colors.grey.withOpacity(0.2),
            shape: BoxShape.circle,
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
        title: Text(
          'TV Subscription',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick instructions card with enhanced design
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDarkMode
                          ? [
                              primaryColor.withOpacity(0.3),
                              tertiaryColor.withOpacity(0.2)
                            ]
                          : [
                              primaryColor.withOpacity(0.15),
                              tertiaryColor.withOpacity(0.1)
                            ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode
                          ? primaryColor.withOpacity(0.3)
                          : primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: isDarkMode
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              primaryColor.withOpacity(isDarkMode ? 0.3 : 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Iconsax.monitor,
                          color: primaryColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Fill in the details to renew your TV subscription',
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // TV Provider selector
                Text(
                  'TV Provider',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),

                _buildProviderGrid(context, isDarkMode, textColor,
                    secondaryTextColor, cardColor, tertiaryColor),

                const SizedBox(height: 24),

                // Smart Card Number input with enhanced validation
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Smart Card Number',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '*',
                                style: TextStyle(
                                  color: Colors.red[400],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _smartCardController,
                            focusNode: _smartCardFocus,
                            decoration: InputDecoration(
                              hintText:
                                  '${currentProvider['cardDigits']}-digit number',
                              hintStyle: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(
                                Iconsax.card,
                                color: primaryColor,
                                size: 20,
                              ),
                              filled: true,
                              fillColor: isDarkMode
                                  ? Colors.grey.shade800.withOpacity(0.2)
                                  : Colors.grey.withOpacity(0.15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 1.5,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              errorText: _smartCardErrorText.isNotEmpty
                                  ? _smartCardErrorText
                                  : null,
                              errorStyle: TextStyle(
                                color: Colors.red[400],
                                fontSize: 12,
                              ),
                            ),
                            style: TextStyle(color: textColor),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(
                                  currentProvider['cardDigits']),
                            ],
                            enabled: !_isValidatingCard,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Validate Button with enhanced design
                    SizedBox(
                      width: 100,
                      height: 56,
                      child: ElevatedButton(
                        onPressed:
                            _isValidatingCard ? null : _validateSmartCard,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: isDarkMode ? 4 : 2,
                          shadowColor: isDarkMode
                              ? primaryColor.withOpacity(0.4)
                              : primaryColor.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: _isValidatingCard
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isDarkMode ? Colors.white70 : Colors.white,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.tick_circle,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Verify',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),

                // Show customer details if validated
                if (_isCardValidated && _customerName != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDarkMode
                            ? [
                                Colors.green.withOpacity(0.3),
                                Colors.green.shade800.withOpacity(0.2)
                              ]
                            : [
                                Colors.green.withOpacity(0.2),
                                Colors.green.shade600.withOpacity(0.1)
                              ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDarkMode
                            ? Colors.green.withOpacity(0.4)
                            : Colors.green.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: isDarkMode
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Card Validated - Customer: $_customerName',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: textColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Subscription packages
                Text(
                  'Subscription Package',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),

                _buildPackageSelector(context, isDarkMode, textColor,
                    secondaryTextColor, cardColor, primaryColor, tertiaryColor),

                const SizedBox(height: 24),

                // Phone number field with enhanced validation
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Phone Number',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '*',
                          style: TextStyle(
                            color: Colors.red[400],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _phoneController,
                      focusNode: _phoneFocus,
                      decoration: InputDecoration(
                        hintText: 'Enter your phone number',
                        hintStyle: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Iconsax.mobile,
                          color: primaryColor,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: isDarkMode
                            ? Colors.grey.shade800.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: primaryColor,
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
                  ],
                ),

                const SizedBox(height: 24),

                // Payment method selector
                Text(
                  'Payment Method',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),

                _buildPaymentMethodSelector(context, isDarkMode, textColor,
                    secondaryTextColor, cardColor, primaryColor, tertiaryColor),

                const SizedBox(height: 32),

                // Process payment button with enhanced design
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _processPayment,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      elevation: isDarkMode ? 8 : 4,
                      shadowColor: isDarkMode
                          ? primaryColor.withOpacity(0.6)
                          : primaryColor.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ).copyWith(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return isDarkMode
                                ? Colors.grey.shade700
                                : Colors.grey.shade400;
                          }
                          return isDarkMode ? primaryColor : primaryColor;
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
                                isDarkMode ? Colors.white70 : Colors.white,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Iconsax.wallet_3,
                                size: 18,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Pay Now',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // Security note with enhanced design
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? tertiaryColor.withOpacity(0.1)
                          : tertiaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDarkMode
                            ? tertiaryColor.withOpacity(0.2)
                            : tertiaryColor.withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.shield_tick,
                          size: 14,
                          color: isDarkMode ? accentColor : tertiaryColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Secured by Deepex Pay',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode ? accentColor : tertiaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProviderGrid(
      BuildContext context,
      bool isDarkMode,
      Color textColor,
      Color secondaryTextColor,
      Color cardColor,
      Color tertiaryColor) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: _providers.length,
      itemBuilder: (context, index) {
        final provider = _providers[index];
        final isSelected = _selectedProvider == provider['id'];
        final providerColor = provider['color'] as Color;
        final lightColor = provider['lightColor'] as Color;
        final displayColor = isDarkMode ? lightColor : providerColor;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedProvider = provider['id'];
              _ensureValidPackageSelected();

              // Reset the smart card validation when provider changes
              _isCardValidated = false;
              _customerName = null;
              _smartCardController.clear();
              _validateSmartCardFormat();
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
                        displayColor.withOpacity(isDarkMode ? 0.8 : 0.6),
                        displayColor.withOpacity(isDarkMode ? 0.4 : 0.2),
                      ],
                    )
                  : null,
              color: isSelected
                  ? null
                  : isDarkMode
                      ? cardColor
                      : cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? displayColor
                    : isDarkMode
                        ? Colors.grey.shade700.withOpacity(0.4)
                        : Colors.grey.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: displayColor.withOpacity(isDarkMode ? 0.5 : 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : isDarkMode
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Provider icon with enhanced design
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        displayColor.withOpacity(isDarkMode ? 0.4 : 0.2),
                        displayColor.withOpacity(isDarkMode ? 0.2 : 0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: displayColor
                                  .withOpacity(isDarkMode ? 0.4 : 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    provider['icon'] as IconData,
                    color: displayColor,
                    size: 28,
                  ),
                ),

                const SizedBox(height: 12),

                // Provider name
                Text(
                  provider['name'] as String,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? (isDarkMode ? Colors.white : displayColor)
                        : textColor,
                  ),
                ),

                // Selected indicator with enhanced design
                if (isSelected)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          displayColor,
                          displayColor.withOpacity(0.7),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: displayColor.withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 10,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPackageSelector(
      BuildContext context,
      bool isDarkMode,
      Color textColor,
      Color secondaryTextColor,
      Color cardColor,
      Color primaryColor,
      Color tertiaryColor) {
    // Get packages for the selected provider
    final packages = _packages[_selectedProvider] ?? [];

    if (packages.isEmpty) {
      return Center(
        child: Text(
          'No packages available for this provider',
          style: TextStyle(
            color: secondaryTextColor,
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: packages.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final package = packages[index];
        final bool isSelected = _selectedPackage == package['id'];

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDarkMode
                        ? [
                            tertiaryColor.withOpacity(0.2),
                            primaryColor.withOpacity(0.1),
                          ]
                        : [
                            tertiaryColor.withOpacity(0.1),
                            primaryColor.withOpacity(0.05),
                          ],
                  )
                : null,
            color: isSelected
                ? null
                : isDarkMode
                    ? cardColor
                    : cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? isDarkMode
                      ? primaryColor
                      : primaryColor
                  : isDarkMode
                      ? Colors.grey.shade700.withOpacity(0.4)
                      : Colors.grey.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: primaryColor.withOpacity(isDarkMode ? 0.4 : 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : isDarkMode
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedPackage = package['id'];
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  // Enhanced radio button with animation
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? primaryColor
                          : isDarkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade200,
                      border: Border.all(
                        color: isSelected
                            ? primaryColor
                            : isDarkMode
                                ? Colors.grey.shade600
                                : Colors.grey.shade400,
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : null,
                  ),

                  const SizedBox(width: 12),

                  // Package details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          package['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          package['description'],
                          style: TextStyle(
                            fontSize: 12,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Price with enhanced design
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? primaryColor.withOpacity(isDarkMode ? 0.2 : 0.1)
                          : isDarkMode
                              ? Colors.grey.shade800.withOpacity(0.5)
                              : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? primaryColor.withOpacity(0.3)
                            : Colors.transparent,
                      ),
                    ),
                    child: Text(
                      '₦${package['price']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? primaryColor : secondaryTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentMethodSelector(
      BuildContext context,
      bool isDarkMode,
      Color textColor,
      Color secondaryTextColor,
      Color cardColor,
      Color primaryColor,
      Color tertiaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? cardColor : cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode
              ? Colors.grey.shade700.withOpacity(0.4)
              : Colors.grey.withOpacity(0.3),
        ),
        boxShadow: isDarkMode
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        children: _paymentMethods.asMap().entries.map((entry) {
          final index = entry.key;
          final method = entry.value;
          final bool isSelected = _selectedPaymentMethod == method['id'];
          final bool isLast = index == _paymentMethods.length - 1;

          return Container(
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primaryColor.withOpacity(isDarkMode ? 0.2 : 0.1),
                        tertiaryColor.withOpacity(isDarkMode ? 0.1 : 0.05),
                      ],
                    )
                  : null,
              border: isLast
                  ? null
                  : Border(
                      bottom: BorderSide(
                        color: isDarkMode
                            ? Colors.grey.shade700.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.3),
                      ),
                    ),
            ),
            child: RadioListTile<String>(
              title: Row(
                children: [
                  // Enhanced icon container
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? primaryColor.withOpacity(isDarkMode ? 0.3 : 0.1)
                          : isDarkMode
                              ? Colors.grey.shade800.withOpacity(0.3)
                              : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? primaryColor.withOpacity(0.5)
                            : Colors.transparent,
                      ),
                    ),
                    child: Icon(
                      method['icon'],
                      color: isSelected ? primaryColor : secondaryTextColor,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    method['name'],
                    style: TextStyle(
                      color: textColor,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              value: method['id'],
              groupValue: _selectedPaymentMethod,
              activeColor: primaryColor,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    _selectedPaymentMethod = value;
                  });
                }
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
