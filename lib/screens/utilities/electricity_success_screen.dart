// lib/screens/utilities/electricity_success_screen.dart
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:deepex/components/button_base.dart';
import 'package:deepex/components/primary_button.dart';
import 'package:deepex/components/text_app_button.dart';
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class ElectricitySuccessScreen extends StatefulWidget {
  final String provider;
  final String meterNumber;
  final String meterType;
  final double amount;
  final String? token;

  const ElectricitySuccessScreen({
    super.key,
    required this.provider,
    required this.meterNumber,
    required this.meterType,
    required this.amount,
    this.token,
  });

  @override
  State<ElectricitySuccessScreen> createState() =>
      _ElectricitySuccessScreenState();
}

class _ElectricitySuccessScreenState extends State<ElectricitySuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  // Controls for confetti animation
  bool _showConfetti = false;

  // Global key for capturing receipt widget
  final GlobalKey _receiptKey = GlobalKey();
  bool _isGeneratingReceipt = false;

  @override
  void initState() {
    super.initState();

    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutQuart),
      ),
    );

    // Start animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();

      // Show confetti after a small delay
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _showConfetti = true;
        });
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Copy token to clipboard
  void _copyToken() {
    if (widget.token != null) {
      Clipboard.setData(ClipboardData(text: widget.token!)).then((_) {
        _showCopiedFeedback();
      });
    }
  }

  // Show copy feedback with enhanced UI
  void _showCopiedFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 8),
            const Text(
              'Token copied to clipboard',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  // Share receipt as image
  Future<void> _shareReceiptAsImage() async {
    setState(() {
      _isGeneratingReceipt = true;
    });

    try {
      // Capture receipt widget as image
      final RenderRepaintBoundary boundary = _receiptKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        final Uint8List pngBytes = byteData.buffer.asUint8List();

        // Create a temporary file
        final tempDir = await getTemporaryDirectory();
        final file = File(
            '${tempDir.path}/electricity_receipt_${DateTime.now().millisecondsSinceEpoch}.png');
        await file.writeAsBytes(pngBytes);

        // Share the file
        await Share.shareXFiles(
          [XFile(file.path)],
          subject: 'Electricity Payment Receipt',
          text: 'My Electricity Payment Receipt',
        );
      }
    } catch (e) {
      _showShareErrorSnackBar('Failed to share receipt as image: $e');
    } finally {
      setState(() {
        _isGeneratingReceipt = false;
      });
    }
  }

  // Share receipt as PDF
  Future<void> _shareReceiptAsPDF() async {
    setState(() {
      _isGeneratingReceipt = true;
    });

    try {
      // Create PDF document
      final pdf = pw.Document();

      // Capture receipt widget as image
      final RenderRepaintBoundary boundary = _receiptKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        final Uint8List pngBytes = byteData.buffer.asUint8List();

        // Add image to PDF
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text('Electricity Payment Receipt',
                        style: pw.TextStyle(
                            fontSize: 20, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 20),
                    pw.Image(
                      pw.MemoryImage(pngBytes),
                      fit: pw.BoxFit.contain,
                      width: 400,
                    ),
                    pw.SizedBox(height: 20),
                    pw.Text('Thank you for using Deepex Pay!',
                        style: pw.TextStyle(fontSize: 14)),
                    pw.Text('Date: ${_getCurrentDateTime()}',
                        style: pw.TextStyle(fontSize: 12)),
                  ],
                ),
              );
            },
          ),
        );

        // Save PDF to a file
        final tempDir = await getTemporaryDirectory();
        final file = File(
            '${tempDir.path}/electricity_receipt_${DateTime.now().millisecondsSinceEpoch}.pdf');
        await file.writeAsBytes(await pdf.save());

        // Share the file
        await Share.shareXFiles(
          [XFile(file.path)],
          subject: 'Electricity Payment Receipt',
          text: 'My Electricity Payment Receipt',
        );
      }
    } catch (e) {
      _showShareErrorSnackBar('Failed to share receipt as PDF: $e');
    } finally {
      setState(() {
        _isGeneratingReceipt = false;
      });
    }
  }

  // Show sharing error
  void _showShareErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Show share options dialog
  void _showShareOptionsDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.backgroundDarkSecondary
          : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share Receipt',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(
                  icon: Icons.image,
                  label: 'As Image',
                  onTap: () {
                    Navigator.pop(context);
                    _shareReceiptAsImage();
                  },
                  isDarkMode: Theme.of(context).brightness == Brightness.dark,
                ),
                _buildShareOption(
                  icon: Icons.picture_as_pdf,
                  label: 'As PDF',
                  onTap: () {
                    Navigator.pop(context);
                    _shareReceiptAsPDF();
                  },
                  isDarkMode: Theme.of(context).brightness == Brightness.dark,
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Build share option item
  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.backgroundDarkTertiary
              : AppColors.backgroundLightSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode
                ? Colors.grey.withAlpha(51) // Was withOpacity(0.2)
                : Colors.grey.withAlpha(77), // Was withOpacity(0.3)
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isDarkMode ? AppColors.primaryLight : AppColors.primary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final formatter = NumberFormat.currency(locale: 'en_NG', symbol: '₦');

    // Enhanced color palette for dark and light modes
    final primaryColor =
        isDarkMode ? AppColors.primaryLight : AppColors.primary;
    final secondaryColor =
        isDarkMode ? const Color(0xFF64FFDA) : const Color(0xFF26A69A);
    final tertiaryColor =
        isDarkMode ? const Color(0xFF7986CB) : const Color(0xFF5C6BC0);
    final backgroundColor =
        isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surfaceColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final errorColor =
        isDarkMode ? const Color(0xFFCF6679) : const Color(0xFFB00020);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Confetti animation at the top
          if (_showConfetti)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 200,
                child: _buildConfetti(),
              ),
            ),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Success animation
                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [
                                    AppColors.success
                                        .withAlpha(isDarkMode ? 179 : 128),
                                    // Was withOpacity(0.7/0.5)
                                    AppColors.success
                                        .withAlpha(isDarkMode ? 51 : 26),
                                    // Was withOpacity(0.2/0.1)
                                  ],
                                  radius: 0.8,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.success
                                        .withAlpha(isDarkMode ? 77 : 51),
                                    // Was withOpacity(0.3/0.2)
                                    blurRadius: 16,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.check_circle,
                                color: AppColors.success,
                                size: 70,
                              ),
                            ),
                          ),

                          Spacing.verticalXL,

                          // Success message
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _fadeAnimation.value,
                                child: Transform.translate(
                                  offset: Offset(0, _slideAnimation.value),
                                  child: child,
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                AppText.displaySmall(
                                  'Payment Successful!',
                                  textAlign: TextAlign.center,
                                  color: isDarkMode
                                      ? AppColors.textDarkPrimary
                                      : AppColors.textLightPrimary,
                                ),
                                Spacing.verticalM,
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColors.success
                                            .withAlpha(isDarkMode ? 51 : 26),
                                        // Was withOpacity(0.2/0.1)
                                        AppColors.success.withAlpha(13),
                                        // Was withOpacity(0.05)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppColors.success
                                          .withAlpha(isDarkMode ? 51 : 26),
                                      // Was withOpacity(0.2/0.1)
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Iconsax.flash_1,
                                        size: 18,
                                        color: AppColors.success,
                                      ),
                                      Spacing.horizontalS,
                                      Text(
                                        'Your electricity payment has been processed',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: isDarkMode
                                              ? AppColors.textDarkSecondary
                                              : AppColors.textLightSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Spacing.verticalXXL,

                          // Transaction details card - with RepaintBoundary for screenshot capture
                          RepaintBoundary(
                            key: _receiptKey,
                            child: AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return Opacity(
                                  opacity: _fadeAnimation.value,
                                  child: Transform.translate(
                                    offset: Offset(0, _slideAnimation.value),
                                    child: child,
                                  ),
                                );
                              },
                              child: _buildTransactionDetailsCard(
                                context,
                                isDarkMode,
                                formatter,
                                secondaryColor,
                                tertiaryColor,
                              ),
                            ),
                          ),

                          // Token section (only for prepaid)
                          if (widget.meterType.toLowerCase() == 'prepaid' &&
                              widget.token != null) ...[
                            Spacing.verticalL,
                            AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return Opacity(
                                  opacity: _fadeAnimation.value,
                                  child: Transform.translate(
                                    offset: Offset(0, _slideAnimation.value),
                                    child: child,
                                  ),
                                );
                              },
                              child: _buildTokenCard(
                                context,
                                isDarkMode,
                                secondaryColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom buttons with enhanced design
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        backgroundColor.withAlpha(204), // Was withOpacity(0.8)
                        backgroundColor,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(isDarkMode ? 51 : 13),
                        // Was withOpacity(0.2/0.05)
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              text: 'Go to Dashboard',
                              onPressed: () => context.go('/home'),
                              size: ButtonSize.large,
                              backgroundColor: isDarkMode
                                  ? AppColors.electricityLight
                                  : AppColors.electricity,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Share button
                          Container(
                            height: 56,
                            width: 56,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? AppColors.primaryDark
                                  : AppColors.primary.withAlpha(26),
                              // Was withAlpha(26)
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDarkMode
                                    ? Colors.white
                                        .withAlpha(76) // Was withAlpha(76)
                                    : AppColors.primary
                                        .withAlpha(51), // Was withAlpha(51)
                              ),
                            ),
                            child: _isGeneratingReceipt
                                ? const Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    ),
                                  )
                                : IconButton(
                                    icon: Icon(
                                      Icons.share,
                                      color: isDarkMode
                                          ? Colors.white
                                          : AppColors.primary,
                                    ),
                                    onPressed: _showShareOptionsDialog,
                                  ),
                          ),
                        ],
                      ),
                      Spacing.verticalM,
                      TextAppButton(
                        text: 'Make Another Payment',
                        onPressed: () => context.go('/electricity'),
                        textColor:
                            isDarkMode ? secondaryColor : AppColors.primary,
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

  // Build transaction details card with enhanced design
  Widget _buildTransactionDetailsCard(
    BuildContext context,
    bool isDarkMode,
    NumberFormat formatter,
    Color secondaryColor,
    Color tertiaryColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  const Color(0xFF1E1E1E),
                  const Color(0xFF252525),
                ]
              : [
                  const Color(0xFFF5F5F5),
                  const Color(0xFFFFFFFF),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode
              ? Colors.grey.withAlpha(51) // Was withAlpha(51)
              : Colors.grey.withAlpha(51), // Was withAlpha(51)
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDarkMode ? 51 : 13),
            // Was withAlpha(51/13)
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Enhanced header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.primaryDark
                          .withAlpha(77) // Was withOpacity(0.3)
                      : AppColors.primary.withAlpha(26), // Was withOpacity(0.1)
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.receipt_2,
                  size: 18,
                  color:
                      isDarkMode ? AppColors.primaryLight : AppColors.primary,
                ),
              ),
              Spacing.horizontalS,
              AppText.titleMedium(
                'Transaction Details',
                color: isDarkMode
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary,
              ),
            ],
          ),

          Spacing.verticalL,

          // Transaction ID with enhanced design
          _buildDetailRow(
            context,
            'Transaction ID',
            '#${_generateTransactionId()}',
            isDarkMode,
            showCopy: true,
            iconData: Iconsax.document_1,
            accentColor: secondaryColor,
          ),

          _buildDivider(isDarkMode),

          // Provider with icon
          _buildDetailRow(
            context,
            'Provider',
            widget.provider,
            isDarkMode,
            iconData: Iconsax.electricity,
            accentColor: tertiaryColor,
          ),

          _buildDivider(isDarkMode),

          // Meter number with icon
          _buildDetailRow(
            context,
            'Meter Number',
            widget.meterNumber,
            isDarkMode,
            iconData: Iconsax.card,
            accentColor: secondaryColor,
          ),

          _buildDivider(isDarkMode),

          // Meter type with icon
          _buildDetailRow(
            context,
            'Meter Type',
            widget.meterType.capitalizeFirst(),
            isDarkMode,
            iconData: widget.meterType.toLowerCase() == 'prepaid'
                ? Iconsax.card
                : Iconsax.receipt_1,
            accentColor: tertiaryColor,
          ),

          _buildDivider(isDarkMode),

          // Amount with enhanced design and icon
          _buildDetailRow(
            context,
            'Amount',
            formatter.format(widget.amount),
            isDarkMode,
            valueColor:
                isDarkMode ? AppColors.electricityLight : AppColors.electricity,
            valueFontWeight: FontWeight.bold,
            iconData: Iconsax.money,
            accentColor: secondaryColor,
          ),

          _buildDivider(isDarkMode),

          // Date & Time with icon
          _buildDetailRow(
            context,
            'Date & Time',
            _getCurrentDateTime(),
            isDarkMode,
            iconData: Iconsax.calendar,
            accentColor: tertiaryColor,
          ),
        ],
      ),
    );
  }

  // Build token card with enhanced design
  Widget _buildTokenCard(
    BuildContext context,
    bool isDarkMode,
    Color accentColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  AppColors.electricity.withAlpha(51), // Was withAlpha(51)
                  AppColors.electricityLight.withAlpha(13), // Was withAlpha(13)
                ]
              : [
                  AppColors.electricity.withAlpha(26), // Was withAlpha(26)
                  AppColors.electricityLight.withAlpha(8), // Was withAlpha(8)
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode
              ? AppColors.electricityLight.withAlpha(76) // Was withAlpha(76)
              : AppColors.electricity.withAlpha(51), // Was withAlpha(51)
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.electricity.withAlpha(isDarkMode ? 51 : 26),
            // Was withAlpha(51/26)
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.electricity
                          .withAlpha(77) // Was withOpacity(0.3)
                      : AppColors.electricity.withAlpha(51),
                  // Was withOpacity(0.2)
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.key,
                  color: isDarkMode
                      ? AppColors.electricityLight
                      : AppColors.electricity,
                  size: 18,
                ),
              ),
              Spacing.horizontalS,
              Text(
                'Your Meter Token',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode
                      ? AppColors.textDarkPrimary
                      : AppColors.textLightPrimary,
                ),
              ),
            ],
          ),
          Spacing.verticalL,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color:
                  isDarkMode ? AppColors.backgroundDarkTertiary : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode
                    ? Colors.grey.withAlpha(51) // Was withOpacity(0.2)
                    : Colors.grey.withAlpha(51), // Was withOpacity(0.2)
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDarkMode ? 51 : 13),
                  // Was withOpacity(0.2/0.05)
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    _formatToken(widget.token ?? ''),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      color:
                          isDarkMode ? accentColor : AppColors.textLightPrimary,
                    ),
                  ),
                ),
                InkWell(
                  onTap: _copyToken,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.electricity
                              .withAlpha(51) // Was withOpacity(0.2)
                          : AppColors.electricity.withAlpha(26),
                      // Was withOpacity(0.1)
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.copy,
                      color: isDarkMode
                          ? AppColors.electricityLight
                          : AppColors.electricity,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacing.verticalM,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.backgroundDarkSecondary
                  : Colors.white.withAlpha(179), // Was withOpacity(0.7)
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDarkMode
                    ? Colors.grey.withAlpha(51) // Was withOpacity(0.2)
                    : Colors.grey.withAlpha(51), // Was withOpacity(0.2)
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Iconsax.info_circle,
                  size: 16,
                  color: isDarkMode
                      ? AppColors.textDarkSecondary
                      : AppColors.textLightSecondary,
                ),
                Spacing.horizontalS,
                Flexible(
                  child: Text(
                    'Enter this token into your meter to activate your units',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkMode
                          ? AppColors.textDarkSecondary
                          : AppColors.textLightSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build divider with enhanced design
  Widget _buildDivider(bool isDarkMode) {
    return Divider(
      height: 28,
      thickness: 1,
      color: isDarkMode
          ? Colors.grey.withAlpha(41) // Was withOpacity(0.16)
          : Colors.grey.withAlpha(31), // Was withOpacity(0.12)
    );
  }

  // Build detail row with enhanced design
  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    bool isDarkMode, {
    bool showCopy = false,
    Color? valueColor,
    FontWeight? valueFontWeight,
    IconData? iconData,
    Color? accentColor,
  }) {
    final color = valueColor ??
        (isDarkMode ? AppColors.textDarkPrimary : AppColors.textLightPrimary);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          if (iconData != null) ...[
            Icon(
              iconData,
              size: 16,
              color: accentColor ??
                  (isDarkMode
                      ? AppColors.textDarkSecondary
                      : AppColors.textLightSecondary),
            ),
            Spacing.horizontalS,
          ],
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode
                    ? AppColors.textDarkSecondary
                    : AppColors.textLightSecondary,
              ),
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: valueFontWeight ?? FontWeight.w500,
                  color: color,
                ),
              ),
              if (showCopy) ...[
                const SizedBox(width: 6),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value)).then((_) {
                      _showCopiedFeedback();
                    });
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.primaryDark
                              .withAlpha(77) // Was withOpacity(0.3)
                          : AppColors.primary.withAlpha(26),
                      // Was withOpacity(0.1)
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.copy,
                      size: 12,
                      color: isDarkMode
                          ? AppColors.primaryLight
                          : AppColors.primary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // Build confetti animation
  Widget _buildConfetti() {
    return IgnorePointer(
      child: Stack(
        children: List.generate(30, (index) {
          final random = math.Random();
          final size = random.nextDouble() * 10 + 6;
          final initialPosition = random.nextDouble() * 400;
          final horizontalPosition = random.nextDouble() * 400;
          final delay = random.nextDouble() * 1500;
          final rotation = random.nextDouble() * 360;
          final opacity = random.nextDouble() * 0.8 + 0.2;

          // Enhanced confetti colors for better contrast in both dark and light modes
          final colors = [
            Colors.red,
            Colors.blue,
            Colors.green,
            Colors.yellow,
            Colors.purple,
            Colors.orange,
            Colors.pink,
            Colors.teal,
            const Color(0xFF00E5FF), // Cyan accent
            const Color(0xFFFFD54F), // Amber accent
            const Color(0xFF64FFDA), // Teal accent
            const Color(0xFFFF4081), // Pink accent
          ];

          final color = colors[random.nextInt(colors.length)];

          return Positioned(
            top: -20,
            left: horizontalPosition,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 3000 + delay.toInt()),
              curve: Curves.easeOutQuad,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(
                    math.sin(value * 5) * 20,
                    initialPosition + value * 500,
                  ),
                  child: Transform.rotate(
                    angle: rotation + value * 5,
                    child: Opacity(
                      opacity: opacity * (1 - value),
                      child: child,
                    ),
                  ),
                );
              },
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: color,
                  shape: index % 2 == 0 ? BoxShape.circle : BoxShape.rectangle,
                  // Add subtle shadow for better depth perception
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(26), // Was withOpacity(0.1)
                      blurRadius: 2,
                      spreadRadius: 0,
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // Helper to format token with spaces
  String _formatToken(String token) {
    // If token already contains dashes, return as is
    if (token.contains('-')) return token;

    // Otherwise, insert a space every 4 characters
    String formatted = '';
    for (int i = 0; i < token.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += token[i];
    }
    return formatted;
  }

  // Generate a random transaction ID
  String _generateTransactionId() {
    // In a real app, this would come from the backend
    return '${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
  }

  // Get formatted current date and time
  String _getCurrentDateTime() {
    final now = DateTime.now();

    // Format: May 18, 2025 - 14:30
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');

    return '${months[now.month - 1]} ${now.day}, ${now.year} - $hour:$minute';
  }
}

// Extension to capitalize first letter
extension StringExtension on String {
  String capitalizeFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
