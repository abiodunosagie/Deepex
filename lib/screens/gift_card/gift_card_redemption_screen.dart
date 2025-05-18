// lib/screens/gift_card/gift_card_redemption_screen.dart
import 'dart:io';

import 'package:deepex/components/button_base.dart';
import 'package:deepex/components/custom_form_field.dart';
import 'package:deepex/components/primary_button.dart';
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:deepex/utilities/form_validators.dart';
import 'package:deepex/utilities/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class GiftCardRedemptionScreen extends StatefulWidget {
  const GiftCardRedemptionScreen({super.key});

  @override
  State<GiftCardRedemptionScreen> createState() =>
      _GiftCardRedemptionScreenState();
}

class _GiftCardRedemptionScreenState extends State<GiftCardRedemptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardCodeController = TextEditingController();
  final _cardPinController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  // Focus nodes
  final _cardCodeFocus = FocusNode();
  final _cardPinFocus = FocusNode();
  final _amountFocus = FocusNode();
  final _notesFocus = FocusNode();

  // Selected gift card type
  String _selectedCardType = 'amazon';

  // Image picker
  final ImagePicker _picker = ImagePicker();
  XFile? _cardImage;
  bool _isImageUploading = false;

  // Conversion rates (sample data)
  final Map<String, dynamic> _conversionRates = {
    'amazon': {
      'name': 'Amazon',
      'rates': {
        'physical': 680.0, // Rate per USD
        'digital': 650.0, // Rate per USD
      },
      'icon': 'assets/images/amazon.png',
      'color': const Color(0xFFFF9900),
    },
    'itunes': {
      'name': 'iTunes',
      'rates': {
        'physical': 640.0,
        'digital': 620.0,
      },
      'icon': 'assets/images/itunes.png',
      'color': const Color(0xFFEA4CC0),
    },
    'google_play': {
      'name': 'Google Play',
      'rates': {
        'physical': 630.0,
        'digital': 610.0,
      },
      'icon': 'assets/images/google_play.png',
      'color': const Color(0xFF4CAF50),
    },
    'steam': {
      'name': 'Steam',
      'rates': {
        'physical': 650.0,
        'digital': 630.0,
      },
      'icon': 'assets/images/steam.png',
      'color': const Color(0xFF1A2033),
    },
    'xbox': {
      'name': 'Xbox',
      'rates': {
        'physical': 620.0,
        'digital': 600.0,
      },
      'icon': 'assets/images/xbox.png',
      'color': const Color(0xFF107C10),
    },
    'playstation': {
      'name': 'PlayStation',
      'rates': {
        'physical': 630.0,
        'digital': 610.0,
      },
      'icon': 'assets/images/playstation.png',
      'color': const Color(0xFF003791),
    },
  };

  String _cardSubtype = 'physical'; // physical or digital
  bool _isLoading = false;
  double _calculatedAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_updateCalculatedAmount);
  }

  @override
  void dispose() {
    // Dispose controllers
    _cardCodeController.dispose();
    _cardPinController.dispose();
    _amountController.dispose();
    _notesController.dispose();

    // Dispose focus nodes
    _cardCodeFocus.dispose();
    _cardPinFocus.dispose();
    _amountFocus.dispose();
    _notesFocus.dispose();

    super.dispose();
  }

  // Update calculated amount based on USD value and conversion rate
  void _updateCalculatedAmount() {
    if (_amountController.text.isNotEmpty) {
      try {
        final amount = double.parse(_amountController.text);
        final rate = _conversionRates[_selectedCardType]['rates'][_cardSubtype];
        setState(() {
          _calculatedAmount = amount * rate;
        });
      } catch (e) {
        setState(() {
          _calculatedAmount = 0.0;
        });
      }
    } else {
      setState(() {
        _calculatedAmount = 0.0;
      });
    }
  }

  // Pick image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() {
        _isImageUploading = true;
      });

      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        setState(() {
          _cardImage = pickedFile;
        });
      }
    } catch (e) {
      SnackBarUtils.showError(context, 'Error picking image: $e');
    } finally {
      setState(() {
        _isImageUploading = false;
      });
    }
  }

  // Show image source selection dialog
  Future<void> _showImageSourceDialog() async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor:
          isDarkMode ? AppColors.backgroundDarkElevated : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText.headingMedium('Upload Gift Card Image'),
                Spacing.verticalM,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImageSourceOption(
                      context: context,
                      icon: Iconsax.camera,
                      label: 'Camera',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                      isDarkMode: isDarkMode,
                    ),
                    _buildImageSourceOption(
                      context: context,
                      icon: Iconsax.gallery,
                      label: 'Gallery',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
                Spacing.verticalL,
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: isDarkMode
                          ? AppColors.textDarkSecondary
                          : AppColors.textLightSecondary,
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

  Widget _buildImageSourceOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.backgroundDarkSecondary
              : AppColors.backgroundLightSecondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 36,
              color: isDarkMode ? AppColors.primaryLight : AppColors.primary,
            ),
            Spacing.verticalS,
            Text(
              label,
              style: TextStyle(
                color: isDarkMode
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Form field focus change helper
  void _fieldFocusChange(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  // Handle submit with validation
  Future<void> _handleSubmit() async {
    // Unfocus to trigger form validation
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      // Form is invalid
      return;
    }

    // Check if image is required and provided
    if (_cardImage == null) {
      SnackBarUtils.showError(
          context, 'Please upload an image of the gift card');
      return;
    }

    // Set loading state
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Create data to pass to confirmation screen
      final Map<String, dynamic> redemptionData = {
        'cardType': _selectedCardType,
        'cardTypeName': _conversionRates[_selectedCardType]['name'],
        'cardSubtype': _cardSubtype,
        'cardCode': _cardCodeController.text,
        'cardPin': _cardPinController.text,
        'amountUSD': double.parse(_amountController.text),
        'amountNGN': _calculatedAmount,
        'notes': _notesController.text,
        'conversionRate': _conversionRates[_selectedCardType]['rates']
            [_cardSubtype],
        'cardImage': _cardImage?.path,
      };

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Navigate to confirmation screen with redemption data
        context.push('/gift-cards/confirmation', extra: redemptionData);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        SnackBarUtils.showError(context, 'An error occurred: $e');
      }
    }
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
        title: AppText.titleLarge(
          'Gift Card Redemption',
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gift card types horizontal list
                  AppText.titleMedium('Select Gift Card Type'),
                  Spacing.verticalS,
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _conversionRates.length,
                      itemBuilder: (context, index) {
                        final String cardType =
                            _conversionRates.keys.elementAt(index);
                        final bool isSelected = _selectedCardType == cardType;
                        final cardData = _conversionRates[cardType];

                        return Padding(
                          padding: EdgeInsets.only(
                              right:
                                  index < _conversionRates.length - 1 ? 12 : 0),
                          child: GiftCardTypeItem(
                            cardType: cardType,
                            cardName: cardData['name'],
                            cardColor: cardData['color'],
                            isSelected: isSelected,
                            onSelect: () {
                              setState(() {
                                _selectedCardType = cardType;
                                _updateCalculatedAmount();
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  Spacing.verticalL,

                  // Card subtype selection (Physical or Digital)
                  AppText.titleMedium('Card Type'),
                  Spacing.verticalS,
                  Row(
                    children: [
                      _buildCardSubtypeButton(
                        'Physical Card',
                        'physical',
                        Iconsax.card,
                        isDarkMode,
                      ),
                      Spacing.horizontalM,
                      _buildCardSubtypeButton(
                        'Digital Code',
                        'digital',
                        Iconsax.code,
                        isDarkMode,
                      ),
                    ],
                  ),

                  Spacing.verticalL,

                  // Card code field
                  CustomFormField(
                    label: 'Card Code/Number',
                    hint: 'Enter gift card code',
                    controller: _cardCodeController,
                    focusNode: _cardCodeFocus,
                    isRequired: true,
                    textInputAction: TextInputAction.next,
                    validator: (value) =>
                        FormValidators.required(value, 'Card code'),
                    prefixIcon: Icon(
                      Iconsax.code_1,
                      color: isDarkMode
                          ? AppColors.secondaryLight
                          : AppColors.primary,
                    ),
                    onSubmitted: (_) =>
                        _fieldFocusChange(_cardCodeFocus, _cardPinFocus),
                  ),

                  Spacing.verticalM,

                  // Card PIN field
                  CustomFormField(
                    label: 'Card PIN (if applicable)',
                    hint: 'Enter gift card PIN',
                    controller: _cardPinController,
                    focusNode: _cardPinFocus,
                    isRequired: false,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icon(
                      Iconsax.password_check,
                      color: isDarkMode
                          ? AppColors.secondaryLight
                          : AppColors.primary,
                    ),
                    onSubmitted: (_) =>
                        _fieldFocusChange(_cardPinFocus, _amountFocus),
                  ),

                  Spacing.verticalM,

                  // Amount field with calculated value
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomFormField(
                        label: 'Card Amount (USD)',
                        hint: 'Enter amount in USD',
                        controller: _amountController,
                        focusNode: _amountFocus,
                        isRequired: true,
                        inputType: InputFieldType.number,
                        textInputAction: TextInputAction.next,
                        validator: FormValidators.compose([
                          (value) => FormValidators.required(value, 'Amount'),
                          (value) => FormValidators.numeric(value),
                        ]),
                        prefixIcon: Icon(
                          Iconsax.dollar_circle,
                          color: isDarkMode
                              ? AppColors.secondaryLight
                              : AppColors.primary,
                        ),
                        onSubmitted: (_) =>
                            _fieldFocusChange(_amountFocus, _notesFocus),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                      ),
                      if (_calculatedAmount > 0) ...[
                        Spacing.verticalS,
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? AppColors.successDark.withOpacity(0.1)
                                : AppColors.successLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Iconsax.money,
                                color: AppColors.success,
                                size: 20,
                              ),
                              Spacing.horizontalS,
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? AppColors.textDarkPrimary
                                          : AppColors.textLightPrimary,
                                      fontSize: 14,
                                    ),
                                    children: [
                                      const TextSpan(text: 'You will receive '),
                                      TextSpan(
                                        text:
                                            '₦${_calculatedAmount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.success,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            ' @ ₦${_conversionRates[_selectedCardType]['rates'][_cardSubtype]}/\$',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDarkMode
                                              ? AppColors.textDarkSecondary
                                              : AppColors.textLightSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),

                  Spacing.verticalM,

                  // Optional notes field
                  CustomFormField(
                    label: 'Additional Notes (Optional)',
                    hint: 'Any other information about your card',
                    controller: _notesController,
                    focusNode: _notesFocus,
                    isRequired: false,
                    inputType: InputFieldType.multiline,
                    maxLines: 3,
                    prefixIcon: Icon(
                      Iconsax.note_2,
                      color: isDarkMode
                          ? AppColors.secondaryLight
                          : AppColors.primary,
                    ),
                  ),

                  Spacing.verticalL,

                  // Card image upload
                  AppText.titleMedium('Gift Card Image'),
                  Spacing.verticalS,
                  GestureDetector(
                    onTap: _isImageUploading ? null : _showImageSourceDialog,
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppColors.backgroundDarkSecondary
                            : AppColors.backgroundLightSecondary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDarkMode
                              ? Colors.grey.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: _isImageUploading
                          ? const Center(child: CircularProgressIndicator())
                          : _cardImage != null
                              ? ClipRoundedRectangle(
                                  borderRadius: 12,
                                  child: Image.file(
                                    File(_cardImage!.path),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Iconsax.gallery_add,
                                      size: 48,
                                      color: isDarkMode
                                          ? AppColors.primaryLight
                                          : AppColors.primary,
                                    ),
                                    Spacing.verticalS,
                                    Text(
                                      'Upload Gift Card Image',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: isDarkMode
                                            ? AppColors.textDarkPrimary
                                            : AppColors.textLightPrimary,
                                      ),
                                    ),
                                    Spacing.verticalXS,
                                    Text(
                                      'Click to upload image of gift card',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDarkMode
                                            ? AppColors.textDarkSecondary
                                            : AppColors.textLightSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                    ),
                  ),

                  // Replace image button if image exists
                  if (_cardImage != null) ...[
                    Spacing.verticalS,
                    TextButton.icon(
                      onPressed: _showImageSourceDialog,
                      icon: const Icon(Iconsax.gallery_edit),
                      label: const Text('Replace Image'),
                      style: TextButton.styleFrom(
                        foregroundColor: isDarkMode
                            ? AppColors.secondaryLight
                            : AppColors.primary,
                      ),
                    ),
                  ],

                  Spacing.verticalXXL,

                  // Submit button
                  PrimaryButton(
                    text: 'Continue to Review',
                    onPressed: _isLoading ? null : _handleSubmit,
                    isLoading: _isLoading,
                    size: ButtonSize.large,
                  ),

                  Spacing.verticalXL,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardSubtypeButton(
    String label,
    String value,
    IconData icon,
    bool isDarkMode,
  ) {
    final bool isSelected = _cardSubtype == value;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _cardSubtype = value;
            _updateCalculatedAmount();
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDarkMode ? AppColors.primaryDark : AppColors.primary)
                : (isDarkMode
                    ? AppColors.backgroundDarkSecondary
                    : AppColors.backgroundLightSecondary),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? (isDarkMode ? AppColors.primaryLight : AppColors.primary)
                  : Colors.grey.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : (isDarkMode
                        ? AppColors.textDarkSecondary
                        : AppColors.textLightSecondary),
                size: 24,
              ),
              Spacing.verticalS,
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDarkMode
                          ? AppColors.textDarkPrimary
                          : AppColors.textLightPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Gift card type item widget
class GiftCardTypeItem extends StatelessWidget {
  final String cardType;
  final String cardName;
  final Color cardColor;
  final bool isSelected;
  final VoidCallback onSelect;

  const GiftCardTypeItem({
    super.key,
    required this.cardType,
    required this.cardName,
    required this.cardColor,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onSelect,
      child: Container(
        width: 80,
        decoration: BoxDecoration(
          color: isSelected
              ? cardColor.withOpacity(isDarkMode ? 0.2 : 0.1)
              : (isDarkMode
                  ? AppColors.backgroundDarkSecondary
                  : AppColors.backgroundLightSecondary),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? cardColor : Colors.grey.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: cardColor.withOpacity(isDarkMode ? 0.8 : 1.0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  Iconsax.card,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            Spacing.verticalS,
            Text(
              cardName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? cardColor
                    : (isDarkMode
                        ? AppColors.textDarkPrimary
                        : AppColors.textLightPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper widget to clip image with rounded corners
class ClipRoundedRectangle extends StatelessWidget {
  final Widget child;
  final double borderRadius;

  const ClipRoundedRectangle({
    super.key,
    required this.child,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: child,
    );
  }
}
