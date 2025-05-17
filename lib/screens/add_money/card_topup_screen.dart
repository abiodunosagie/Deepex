// lib/screens/add_money/card_top_up_screen.dart
import 'dart:math';

import 'package:deepex/components/button_base.dart';
import 'package:deepex/components/custom_form_field.dart';
import 'package:deepex/components/primary_button.dart';
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:deepex/utilities/form_utils.dart';
import 'package:deepex/utilities/input_formatters.dart';
import 'package:deepex/utilities/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class CardTopUpScreen extends StatefulWidget {
  const CardTopUpScreen({super.key});

  @override
  State<CardTopUpScreen> createState() => _CardTopUpScreenState();
}

class _CardTopUpScreenState extends State<CardTopUpScreen>
    with SingleTickerProviderStateMixin {
  // Controllers for form fields
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _amountController = TextEditingController();

  // Focus nodes for form fields
  final _cardNumberFocus = FocusNode();
  final _cardHolderFocus = FocusNode();
  final _expiryFocus = FocusNode();
  final _cvvFocus = FocusNode();
  final _amountFocus = FocusNode();

  // First, let's add some necessary state variables to the _CardTopUpScreenState class
  final _pinController = TextEditingController();
  final List<String> _pin = ['', '', '', ''];
  int _currentPinIndex = 0;
  bool _isPinValid = false;
  bool _isProcessingPin = false;

  // This will be our PIN - in a real app, this would be securely stored/retrieved
  final String _correctPin = '1234';

  // Card state
  String _cardType = 'default';
  Color _cardColor =
      Color(0xFF2B3252); // Subtle dark blue-gray for default card color
  // Validation and state management
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  bool _saveCard = false;
  double _amount = 0.0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _showBackView = false;

  // Predefined card types with subtle colors
  final Map<String, Map<String, dynamic>> _cardTypes = {
    'visa': {
      'icon': Iconsax.card,
      'color': const Color(0xFF2B3252), // Subtle dark blue
    },
    'mastercard': {
      'icon': Iconsax.card,
      'color': const Color(0xFF334466), // Subtle navy blue
    },
    'verve': {
      'icon': Iconsax.card,
      'color': const Color(0xFF304050), // Dark teal blue
    },
    'amex': {
      'icon': Iconsax.card,
      'color': const Color(0xFF1E3A5F), // Dark blue-gray
    },
    'default': {
      'icon': Iconsax.card,
      'color': const Color(0xFF2B3252), // Default subtle dark blue-gray
    },
  };

  // Quick amount options
  final List<double> _quickAmounts = [
    1000,
    5000,
    10000,
    15000,
    20000,
  ];

  @override
  void initState() {
    super.initState();
    // Setup animation for card flip effect
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Listen for CVV focus to flip the card
    _cvvFocus.addListener(_handleCvvFocus);

    // Listen for card changes to update card preview
    _cardNumberController.addListener(_updateCardPreview);
    _cardHolderController.addListener(_updateCardPreview);
    _expiryController.addListener(_updateCardPreview);
    _cvvController.addListener(_updateCardPreview);

    // Set default amount
    _amountController.text = _quickAmounts[1].toString();
    _amount = _quickAmounts[1];
  }

  // Method to update card preview in real-time
  void _updateCardPreview() {
    // Detect card type from number
    _detectCardType();
    // Any other card preview updates can be added here
    setState(() {}); // Trigger UI update
  }

  @override
  void dispose() {
    // Remove all listeners
    _cardNumberController.removeListener(_updateCardPreview);
    _cardHolderController.removeListener(_updateCardPreview);
    _expiryController.removeListener(_updateCardPreview);
    _cvvController.removeListener(_updateCardPreview);

    // Dispose controllers and focus nodes
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _amountController.dispose();

    _cardNumberFocus.dispose();
    _cardHolderFocus.dispose();
    _expiryFocus.dispose();
    _cvvFocus.dispose();
    _amountFocus.dispose();

    _animationController.dispose();
    super.dispose();
  }

  // Detect card type based on card number with improved stability
  void _detectCardType() {
    String cardNumber = _cardNumberController.text.replaceAll(' ', '');

    // Only change card type when we have enough digits for reliable detection
    if (cardNumber.length < 2) {
      return; // Keep current card type until we have at least 2 digits
    }

    String newCardType = 'default';

    // More reliable detection logic - require more digits
    if (cardNumber.startsWith('4') && cardNumber.length >= 4) {
      newCardType = 'visa';
    } else if (cardNumber.startsWith('5') && cardNumber.length >= 4) {
      newCardType = 'mastercard';
    } else if ((cardNumber.startsWith('506') || cardNumber.startsWith('650')) &&
        cardNumber.length >= 6) {
      newCardType = 'verve';
    } else if (cardNumber.startsWith('3') && cardNumber.length >= 4) {
      newCardType = 'amex';
    }

    // Only update if there's an actual change
    if (_cardType != newCardType) {
      setState(() {
        _cardType = newCardType;
        _cardColor = _cardTypes[newCardType]!['color'];
      });
    }
  }

  // Handle CVV focus to show card back view
  void _handleCvvFocus() {
    setState(() {
      if (_cvvFocus.hasFocus && !_showBackView) {
        _showBackView = true;
        _animationController.forward();
      } else if (!_cvvFocus.hasFocus && _showBackView) {
        _showBackView = false;
        _animationController.reverse();
      }
    });
  }

  // Handle amount selection from quick options
  void _selectAmount(double amount) {
    setState(() {
      _amount = amount;
      _amountController.text = amount.toString();
    });
    // Force rebuild of amount chips
    setState(() {});
  }

  // Move to next field when max length is reached
  void _fieldFocusChange(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  // Process payment when form is valid
  Future<void> _processPayment() async {
    // Unfocus to trigger validation
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    // Reset PIN data
    _pin.fillRange(0, 4, '');
    _currentPinIndex = 0;
    _isPinValid = false;

    // Show PIN entry bottom sheet
    await _showPinEntryBottomSheet();
  }

  Future<void> _showPinEntryBottomSheet() async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.backgroundDarkElevated
                    : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle bar
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),

                  // Header
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Iconsax.security,
                          size: 48,
                          color: isDarkMode
                              ? AppColors.secondaryLight
                              : AppColors.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Enter PIN',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? AppColors.textDarkPrimary
                                : AppColors.textLightPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please enter your 4-digit PIN to confirm payment of ₦${_amount.toInt()}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDarkMode
                                ? AppColors.textDarkSecondary
                                : AppColors.textLightSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // PIN Input Display
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: _pin[index].isNotEmpty
                                ? (isDarkMode
                                    ? AppColors.primaryDark
                                    : AppColors.primaryLight)
                                : (isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.grey[200]),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _currentPinIndex == index
                                  ? (isDarkMode
                                      ? AppColors.secondaryLight
                                      : AppColors.primary)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: _pin[index].isNotEmpty
                                ? Icon(
                                    Icons.circle,
                                    size: 24,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.white,
                                  )
                                : null,
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Error message if PIN is incorrect
                  if (_isPinValid == false &&
                      _currentPinIndex == 0 &&
                      _pin.join('').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        'Incorrect PIN. Please try again.',
                        style: TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                  // Loading indicator when processing PIN
                  if (_isProcessingPin)
                    Column(
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isDarkMode
                                ? AppColors.secondaryLight
                                : AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Processing payment...',
                          style: TextStyle(
                            color: isDarkMode
                                ? AppColors.textDarkSecondary
                                : AppColors.textLightSecondary,
                          ),
                        ),
                      ],
                    )
                  else
                    Expanded(
                      child: _buildPinKeyboard(setState, isDarkMode),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPinKeyboard(StateSetter setModalState, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Keyboard rows
          ...List.generate(3, (rowIndex) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (colIndex) {
                final number = rowIndex * 3 + colIndex + 1;
                return _buildKeyboardButton(
                  '$number',
                  setModalState,
                  isDarkMode,
                );
              }),
            );
          }),

          // Last row with 0 and backspace
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Empty space for balance
              const SizedBox(width: 60, height: 60),

              // 0 button
              _buildKeyboardButton('0', setModalState, isDarkMode),

              // Backspace button
              GestureDetector(
                onTap: () {
                  setModalState(() {
                    if (_currentPinIndex > 0) {
                      _currentPinIndex--;
                      _pin[_currentPinIndex] = '';
                    }
                  });
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.backspace_outlined,
                    color: isDarkMode
                        ? AppColors.textDarkSecondary
                        : AppColors.textLightSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeyboardButton(
      String number, StateSetter setModalState, bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        setModalState(() {
          if (_currentPinIndex < 4) {
            _pin[_currentPinIndex] = number;
            _currentPinIndex++;

            // Check if PIN is complete
            if (_currentPinIndex == 4) {
              final enteredPin = _pin.join('');
              _isProcessingPin = true;

              // Simulate PIN verification with a delay
              Future.delayed(const Duration(milliseconds: 800), () {
                setModalState(() {
                  _isProcessingPin = false;
                  _isPinValid = enteredPin ==
                      _correctPin; // In real app, validate securely

                  if (_isPinValid) {
                    // Close bottom sheet
                    Navigator.pop(context);
                    // Process payment and show success
                    _processPaymentAfterPinValidation();
                  } else {
                    // Reset PIN for retry
                    _pin.fillRange(0, 4, '');
                    _currentPinIndex = 0;
                  }
                });
              });
            }
          }
        });
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            number,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode
                  ? AppColors.textDarkPrimary
                  : AppColors.textLightPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _processPaymentAfterPinValidation() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        // Show success dialog
        await _showSuccessDialog();

        // Navigate to home screen
        if (mounted) {
          context.go('/home');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        SnackBarUtils.showError(context, 'Transaction failed: ${e.toString()}');
      }
    }
  }

  Future<void> _showSuccessDialog() async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return showDialog(
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
                  child: Center(
                    child: Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 50,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Success message
                Text(
                  'Payment Successful!',
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
                  'You have successfully added ₦${_amount.toInt()} to your Deepex wallet.',
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
  }

  // Build card front view
  Widget _buildCardFrontView() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _cardColor,
            Color.alphaBlend(Colors.black.withAlpha(51), _cardColor),
            // ~0.2 opacity
          ],
          stops: const [0.3, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(64), // ~0.25 opacity
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card chip and type
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/chip.png',
                height: 40,
                width: 50,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.credit_card_rounded,
                        color: Colors.white.withAlpha(204), // ~0.8 opacity
                        size: 40),
              ),
              Icon(
                _cardTypes[_cardType]!['icon'],
                color: Colors.white.withAlpha(204), // ~0.8 opacity
                size: 30,
              ),
            ],
          ),
          const Spacer(),

          // Card number
          Text(
            _cardNumberController.text.isEmpty
                ? '•••• •••• •••• ••••'
                : _cardNumberController.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 20),

          // Card holder and expiry
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CARD HOLDER',
                      style: TextStyle(
                        color: Colors.white.withAlpha(179), // ~0.7 opacity
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _cardHolderController.text.isEmpty
                          ? 'YOUR NAME'
                          : _cardHolderController.text.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EXPIRES',
                    style: TextStyle(
                      color: Colors.white.withAlpha(179), // ~0.7 opacity
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _expiryController.text.isEmpty
                        ? 'MM/YY'
                        : _expiryController.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build card back view
  Widget _buildCardBackView() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.alphaBlend(Colors.black.withAlpha(51), _cardColor),
            // ~0.2 opacity
            _cardColor,
          ],
          stops: const [0.0, 0.7],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(64), // ~0.25 opacity
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Black magnetic strip
          Container(
            height: 40,
            margin: const EdgeInsets.symmetric(vertical: 20),
            color: Colors.black,
          ),

          // Signature strip
          Container(
            height: 40,
            padding: const EdgeInsets.only(right: 10),
            color: Colors.white.withAlpha(230), // ~0.9 opacity
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  color: Colors.white,
                  child: Text(
                    _cvvController.text.isEmpty ? 'CVV' : _cvvController.text,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Card type logo
          Align(
            alignment: Alignment.centerRight,
            child: Icon(
              _cardTypes[_cardType]!['icon'],
              color: Colors.white.withAlpha(204), // ~0.8 opacity
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  // Build flippable card
  Widget _buildFlippableCard() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showBackView = !_showBackView;
          if (_showBackView) {
            _animationController.forward();
          } else {
            _animationController.reverse();
          }
        });
      },
      child: SizedBox(
        height: 200,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(pi * _animation.value),
              alignment: Alignment.center,
              child: _animation.value <= 0.5
                  ? _buildCardFrontView()
                  : Transform(
                      transform: Matrix4.identity()..rotateY(pi),
                      alignment: Alignment.center,
                      child: _buildCardBackView(),
                    ),
            );
          },
        ),
      ),
    );
  }

  // Build amount selection chips
  Widget _buildAmountChips() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _quickAmounts.length,
        itemBuilder: (context, index) {
          final amount = _quickAmounts[index];
          final isSelected = _amount == amount;

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
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              backgroundColor: isDarkMode
                  ? AppColors.backgroundDarkSecondary
                  : AppColors.backgroundLightSecondary,
              selectedColor: _cardColor,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              onSelected: (bool selected) {
                if (selected) {
                  _selectAmount(amount);
                }
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
                ? AppColors.backgroundDarkSecondary
                    .withAlpha(153) // ~0.6 opacity
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
        title: AppText.titleLarge(
          'Card Top-up',
          color: isDarkMode
              ? AppColors.textDarkPrimary
              : AppColors.textLightPrimary,
        ),
        centerTitle: true,
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
                  // Card visualization
                  _buildFlippableCard(),
                  Spacing.verticalL,

                  // Card number field
                  CustomFormField(
                    label: 'Card Number',
                    hint: '0000 0000 0000 0000',
                    controller: _cardNumberController,
                    focusNode: _cardNumberFocus,
                    isRequired: true,
                    inputType: InputFieldType.number,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Card number is required';
                      }
                      if (value.replaceAll(' ', '').length < 16) {
                        return 'Please enter a valid card number';
                      }
                      return null;
                    },
                    prefixIcon: Icon(
                      Iconsax.card,
                      color: isDarkMode
                          ? AppColors.secondaryLight
                          : AppColors.primary,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CustomInputFormatters.creditCard,
                    ],
                    onSubmitted: (_) =>
                        _fieldFocusChange(_cardNumberFocus, _cardHolderFocus),
                  ),
                  Spacing.verticalM,

                  // Card holder field
                  CustomFormField(
                    label: 'Card Holder Name',
                    hint: 'John Doe',
                    controller: _cardHolderController,
                    focusNode: _cardHolderFocus,
                    isRequired: true,
                    textInputAction: TextInputAction.next,
                    validator: (value) => FormUtils.validateRequiredField(
                        value, 'Card holder name'),
                    prefixIcon: Icon(
                      Iconsax.user,
                      color: isDarkMode
                          ? AppColors.secondaryLight
                          : AppColors.primary,
                    ),
                    textCapitalization: TextCapitalization.words,
                    onSubmitted: (_) =>
                        _fieldFocusChange(_cardHolderFocus, _expiryFocus),
                  ),
                  Spacing.verticalM,

                  // Expiry date and CVV row
                  Row(
                    children: [
                      // Expiry date field
                      Expanded(
                        child: CustomFormField(
                          label: 'Expiry Date',
                          hint: 'MM/YY',
                          controller: _expiryController,
                          focusNode: _expiryFocus,
                          isRequired: true,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Expiry date is required';
                            }
                            if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                              return 'Invalid format';
                            }
                            // Extract month and year
                            List<String> parts = value.split('/');
                            int month = int.parse(parts[0]);
                            if (month < 1 || month > 12) {
                              return 'Invalid month';
                            }
                            return null;
                          },
                          prefixIcon: Icon(
                            Iconsax.calendar,
                            color: isDarkMode
                                ? AppColors.secondaryLight
                                : AppColors.primary,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            TextInputFormatter.withFunction(
                                (oldValue, newValue) {
                              final text = newValue.text;
                              if (text.isEmpty) return newValue;

                              String formatted = text;
                              if (text.length > 2) {
                                formatted =
                                    '${text.substring(0, 2)}/${text.substring(2, min(4, text.length))}';
                              }

                              return TextEditingValue(
                                text: formatted,
                                selection: TextSelection.collapsed(
                                    offset: formatted.length),
                              );
                            }),
                            LengthLimitingTextInputFormatter(5),
                          ],
                          onSubmitted: (_) =>
                              _fieldFocusChange(_expiryFocus, _cvvFocus),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // CVV field
                      Expanded(
                        child: CustomFormField(
                          label: 'CVV',
                          hint: '123',
                          controller: _cvvController,
                          focusNode: _cvvFocus,
                          isRequired: true,
                          inputType: InputFieldType.number,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'CVV is required';
                            }
                            if (value.length < 3) {
                              return 'Invalid CVV';
                            }
                            return null;
                          },
                          prefixIcon: Icon(
                            Iconsax.security,
                            color: isDarkMode
                                ? AppColors.secondaryLight
                                : AppColors.primary,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          onSubmitted: (_) =>
                              _fieldFocusChange(_cvvFocus, _amountFocus),
                        ),
                      ),
                    ],
                  ),
                  Spacing.verticalM,

                  // Save card checkbox
                  Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: _saveCard,
                          activeColor: _cardColor,
                          onChanged: (value) {
                            setState(() {
                              _saveCard = value ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      AppText.bodyMedium('Save card for future transactions'),
                    ],
                  ),
                  Spacing.verticalL,

                  // Amount section
                  AppText.titleMedium('Amount'),
                  Spacing.verticalS,

                  // Quick amount selection
                  _buildAmountChips(),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Amount is required';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null) {
                        return 'Invalid amount';
                      }
                      if (amount < 100) {
                        return 'Minimum amount is ₦100';
                      }
                      if (amount > 1000000) {
                        return 'Maximum amount is ₦1,000,000';
                      }
                      return null;
                    },
                    prefixIcon: const Icon(
                      Iconsax.money,
                      color: AppColors.success,
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        final amount = double.tryParse(value);
                        if (amount != null) {
                          setState(() {
                            _amount = amount;
                          });
                        }
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  Spacing.verticalXXL,

                  // Process payment button
                  PrimaryButton(
                    text: 'Top-up ₦${_amount.toInt()}',
                    backgroundColor:
                        isDarkMode ? AppColors.primaryLight : AppColors.primary,
                    onPressed: _isProcessing ? null : _processPayment,
                    isLoading: _isProcessing,
                    size: ButtonSize.large,
                  ),

                  // Card security notice
                  Spacing.verticalL,
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.shield_tick,
                          color: isDarkMode
                              ? AppColors.successLight
                              : AppColors.success,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        AppText.bodySmall(
                          'Your card details are secured with end-to-end encryption',
                          color: isDarkMode
                              ? AppColors.textDarkSecondary
                              : AppColors.textLightSecondary,
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
}

// Helper extension for TextInputFormatter - limiting input length
class LengthLimitingTextInputFormatter extends TextInputFormatter {
  final int maxLength;

  LengthLimitingTextInputFormatter(this.maxLength);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length > maxLength) {
      final newSelection = newValue.selection.copyWith(
        baseOffset: min(newValue.selection.baseOffset, maxLength),
        extentOffset: min(newValue.selection.extentOffset, maxLength),
      );

      return TextEditingValue(
        text: newValue.text.substring(0, maxLength),
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}
