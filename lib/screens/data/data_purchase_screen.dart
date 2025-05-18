// lib/screens/data/data_purchase_screen.dart
import 'dart:math';

import 'package:deepex/components/button_base.dart';
import 'package:deepex/components/custom_form_field.dart';
import 'package:deepex/components/primary_button.dart';
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/app_text.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:deepex/models/data_plan_model.dart';
import 'package:deepex/utilities/form_utils.dart';
import 'package:deepex/utilities/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class DataPurchaseScreen extends StatefulWidget {
  const DataPurchaseScreen({Key? key}) : super(key: key);

  @override
  State<DataPurchaseScreen> createState() => _DataPurchaseScreenState();
}

class _DataPurchaseScreenState extends State<DataPurchaseScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _phoneFocus = FocusNode();

  // Animation controller for content transitions
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Selected provider
  String _selectedProvider = 'mtn';

  // Selected plan
  DataPlanModel? _selectedPlan;

  // Loading state
  bool _isProcessing = false;

  // Tracks whether we're showing plans or form
  bool _showingPlans = false;

  // Selected filter tab
  String _selectedFilter = 'Daily';

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start with the "Choose Provider" view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocus.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Show plans for the selected provider
  void _showDataPlans() {
    setState(() {
      _showingPlans = true;
    });

    // Reset animation and play forward
    _animationController.reset();
    _animationController.forward();
  }

  // Return to provider selection
  void _backToProviders() {
    setState(() {
      _showingPlans = false;
      _selectedPlan = null;
    });

    // Reset animation and play forward
    _animationController.reset();
    _animationController.forward();
  }

  // Process data purchase
  Future<void> _processDataPurchase() async {
    // Validate form
    if (!_formKey.currentState!.validate()) return;

    // Ensure plan is selected
    if (_selectedPlan == null) {
      SnackBarUtils.showError(context, 'Please select a data plan');
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // Navigate to success screen
      context.push('/data/success', extra: {
        'provider': _selectedProvider,
        'plan': _selectedPlan,
        'phoneNumber': _phoneController.text,
      });
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showError(context, 'Failed to process purchase');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  // Local method to get data plans by provider
  List<DataPlanModel> _getDataPlansForProvider(String provider) {
    // This would normally come from an API or a provider
    switch (provider.toLowerCase()) {
      case 'mtn':
        return [
          DataPlanModel(
            id: 'mtn_1',
            provider: 'mtn',
            name: 'Daily Plan',
            description: 'Perfect for light browsing and social media',
            price: 100,
            duration: '1 Day',
            dataAmount: '100MB',
          ),
          DataPlanModel(
            id: 'mtn_2',
            provider: 'mtn',
            name: 'Daily Plus',
            description: 'Browse, stream music and use social media apps',
            price: 200,
            duration: '1 Day',
            dataAmount: '200MB',
          ),
          DataPlanModel(
            id: 'mtn_3',
            provider: 'mtn',
            name: 'Weekly Lite',
            description:
                'Weekly data for streaming videos, browsing and gaming',
            price: 500,
            duration: '7 Days',
            dataAmount: '1GB',
            isPopular: true,
          ),
          DataPlanModel(
            id: 'mtn_4',
            provider: 'mtn',
            name: 'Monthly Basic',
            description: 'Standard data for daily use and light streaming',
            price: 1000,
            duration: '30 Days',
            dataAmount: '1.5GB',
          ),
          DataPlanModel(
            id: 'mtn_5',
            provider: 'mtn',
            name: 'Monthly Plus',
            description: 'High-speed data for streaming, gaming and downloads',
            price: 2000,
            duration: '30 Days',
            dataAmount: '4.5GB',
            isPopular: true,
          ),
          DataPlanModel(
            id: 'mtn_6',
            provider: 'mtn',
            name: 'Monthly Premium',
            description: 'Unlimited browsing and heavy streaming',
            price: 3500,
            duration: '30 Days',
            dataAmount: '10GB',
          ),
        ];
      case 'airtel':
        return [
          DataPlanModel(
            id: 'airtel_1',
            provider: 'airtel',
            name: 'Daily Basic',
            description: 'Light browsing and social media',
            price: 100,
            duration: '1 Day',
            dataAmount: '100MB',
          ),
          DataPlanModel(
            id: 'airtel_2',
            provider: 'airtel',
            name: 'Daily Plus',
            description: 'More data for streaming and browsing',
            price: 300,
            duration: '1 Day',
            dataAmount: '300MB',
          ),
          DataPlanModel(
            id: 'airtel_3',
            provider: 'airtel',
            name: 'Weekly Value',
            description: 'Perfect for a week of browsing and social media',
            price: 500,
            duration: '7 Days',
            dataAmount: '1.5GB',
            isPopular: true,
          ),
          DataPlanModel(
            id: 'airtel_4',
            provider: 'airtel',
            name: 'Monthly Lite',
            description: 'Great for daily use and social media',
            price: 1000,
            duration: '30 Days',
            dataAmount: '2GB',
          ),
          DataPlanModel(
            id: 'airtel_5',
            provider: 'airtel',
            name: 'Monthly Plus',
            description: 'Perfect for streaming and gaming',
            price: 2000,
            duration: '30 Days',
            dataAmount: '5GB',
            isPopular: true,
          ),
          DataPlanModel(
            id: 'airtel_6',
            provider: 'airtel',
            name: 'Monthly Premium',
            description: 'High speed data for heavy users',
            price: 3000,
            duration: '30 Days',
            dataAmount: '8GB',
          ),
        ];
      case 'glo':
        return [
          DataPlanModel(
            id: 'glo_1',
            provider: 'glo',
            name: 'Daily Mini',
            description: 'Quick data for essential tasks',
            price: 50,
            duration: '1 Day',
            dataAmount: '50MB',
          ),
          DataPlanModel(
            id: 'glo_2',
            provider: 'glo',
            name: 'Daily Plus',
            description: 'More data for browsing and social media',
            price: 200,
            duration: '1 Day',
            dataAmount: '250MB',
          ),
          DataPlanModel(
            id: 'glo_3',
            provider: 'glo',
            name: 'Weekly Standard',
            description: 'Sufficient data for a week of normal use',
            price: 500,
            duration: '7 Days',
            dataAmount: '1.6GB',
            isPopular: true,
          ),
          DataPlanModel(
            id: 'glo_4',
            provider: 'glo',
            name: 'Monthly Basic',
            description: 'Affordable option for regular users',
            price: 1000,
            duration: '30 Days',
            dataAmount: '2.5GB',
          ),
          DataPlanModel(
            id: 'glo_5',
            provider: 'glo',
            name: 'Monthly Standard',
            description: 'Good balance for streaming and browsing',
            price: 2000,
            duration: '30 Days',
            dataAmount: '5.8GB',
            isPopular: true,
          ),
          DataPlanModel(
            id: 'glo_6',
            provider: 'glo',
            name: 'Monthly Max',
            description: 'Heavy use with large data allocation',
            price: 2500,
            duration: '30 Days',
            dataAmount: '7.7GB',
          ),
        ];
      case '9mobile':
        return [
          DataPlanModel(
            id: '9mobile_1',
            provider: '9mobile',
            name: 'Daily Lite',
            description: 'Light browsing and social media',
            price: 100,
            duration: '1 Day',
            dataAmount: '100MB',
          ),
          DataPlanModel(
            id: '9mobile_2',
            provider: '9mobile',
            name: 'Daily Plus',
            description: 'More data for daily needs',
            price: 200,
            duration: '1 Day',
            dataAmount: '150MB',
          ),
          DataPlanModel(
            id: '9mobile_3',
            provider: '9mobile',
            name: 'Weekly Saver',
            description: 'Economical plan for the whole week',
            price: 500,
            duration: '7 Days',
            dataAmount: '1GB',
            isPopular: true,
          ),
          DataPlanModel(
            id: '9mobile_4',
            provider: '9mobile',
            name: 'Monthly Starter',
            description: 'Basic data for the entire month',
            price: 1000,
            duration: '30 Days',
            dataAmount: '1.5GB',
          ),
          DataPlanModel(
            id: '9mobile_5',
            provider: '9mobile',
            name: 'Monthly Plus',
            description: 'Ideal for regular users who stream and browse',
            price: 2000,
            duration: '30 Days',
            dataAmount: '4.5GB',
            isPopular: true,
          ),
          DataPlanModel(
            id: '9mobile_6',
            provider: '9mobile',
            name: 'Monthly Max',
            description: 'For heavy data users who need more',
            price: 3500,
            duration: '30 Days',
            dataAmount: '11GB',
          ),
        ];
      default:
        return [];
    }
  }

  // Filter plans based on selected filter
  List<DataPlanModel> _getFilteredPlans(List<DataPlanModel> plans) {
    if (_selectedFilter == 'All') return plans;

    return plans.where((plan) {
      switch (_selectedFilter) {
        case 'Daily':
          return plan.duration.contains('Day') || plan.duration.contains('day');
        case 'Weekly':
          return plan.duration.contains('Week') ||
              plan.duration.contains('week') ||
              plan.duration.contains('7 Days');
        case 'Monthly':
          return plan.duration.contains('Month') ||
              plan.duration.contains('month') ||
              plan.duration.contains('30 Days');
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Get data plans locally based on selected provider
    List<DataPlanModel> dataPlans = _getDataPlansForProvider(_selectedProvider);

    // Apply filter if showing plans
    if (_showingPlans) {
      dataPlans = _getFilteredPlans(dataPlans);
    }

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
                _showingPlans ? Icons.arrow_back : Icons.close,
                color: isDarkMode
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary,
                size: 20,
              ),
              onPressed: () {
                if (_showingPlans) {
                  _backToProviders();
                } else {
                  context.pop();
                }
              },
            ),
          ),
        ),
        title: AppText.titleLarge(
          'Buy Data',
          color: isDarkMode
              ? AppColors.textDarkPrimary
              : AppColors.textLightPrimary,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: _showingPlans
                  ? _buildDataPlansView(context, isDarkMode, dataPlans)
                  : _buildProvidersView(context, isDarkMode),
            );
          },
        ),
      ),
    );
  }

  // Provider selection view
  Widget _buildProvidersView(BuildContext context, bool isDarkMode) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          AppText.displaySmall(
            'Mobile Data Purchase',
            color: isDarkMode
                ? AppColors.textDarkPrimary
                : AppColors.textLightPrimary,
          ),
          Spacing.verticalS,
          AppText.bodyLarge(
            'Purchase data bundles for any network',
            color: isDarkMode
                ? AppColors.textDarkSecondary
                : AppColors.textLightSecondary,
          ),
          Spacing.verticalXL,

          // Network selection title
          AppText.titleMedium(
            'Select Network Provider',
            color: isDarkMode
                ? AppColors.textDarkPrimary
                : AppColors.textLightPrimary,
          ),
          Spacing.verticalL,

          // Network Provider Cards
          _buildProviderCard(
            context: context,
            isDarkMode: isDarkMode,
            providerId: 'mtn',
            name: 'MTN',
            logoPath: 'assets/images/mtn_logo.png',
            fallbackIcon: Icons.network_cell,
            color: const Color(0xFFFFCC00),
          ),

          Spacing.verticalM,

          _buildProviderCard(
            context: context,
            isDarkMode: isDarkMode,
            providerId: 'airtel',
            name: 'Airtel',
            logoPath: 'assets/images/airtel_logo.png',
            fallbackIcon: Icons.network_cell,
            color: const Color(0xFFFF0000),
          ),

          Spacing.verticalM,

          _buildProviderCard(
            context: context,
            isDarkMode: isDarkMode,
            providerId: 'glo',
            name: 'Glo',
            logoPath: 'assets/images/glo_logo.png',
            fallbackIcon: Icons.network_cell,
            color: const Color(0xFF00AB4E),
          ),

          Spacing.verticalM,

          _buildProviderCard(
            context: context,
            isDarkMode: isDarkMode,
            providerId: '9mobile',
            name: '9Mobile',
            logoPath: 'assets/images/9mobile_logo.png',
            fallbackIcon: Icons.network_cell,
            color: const Color(0xFF006F53),
          ),

          Spacing.verticalXXL,

          // Recent purchases suggestions (Optional)
          AppText.titleMedium('Recent Purchases'),
          Spacing.verticalM,

          // Recent purchase card
          _buildRecentPurchaseCard(
            context,
            isDarkMode,
            '0902*****50',
            'MTN',
            '1GB (30 Days)',
            '₦1,000',
            onTap: () {
              // Pre-fill form with recent purchase data
              _selectedProvider = 'mtn';
              _phoneController.text = '09021234550';
              _showDataPlans();
            },
          ),
        ],
      ),
    );
  }

  // Data plans view
  Widget _buildDataPlansView(
      BuildContext context, bool isDarkMode, List<DataPlanModel> plans) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Provider logo and name
            Row(
              children: [
                _buildProviderLogo(_selectedProvider, 40, isDarkMode),
                Spacing.horizontalM,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.bodySmall(
                      'Selected Network',
                      color: isDarkMode
                          ? AppColors.textDarkSecondary
                          : AppColors.textLightSecondary,
                    ),
                    AppText.titleLarge(
                      _getProviderName(_selectedProvider),
                      color: isDarkMode
                          ? AppColors.textDarkPrimary
                          : AppColors.textLightPrimary,
                    ),
                  ],
                ),
              ],
            ),

            Spacing.verticalXL,

            // Phone number input
            CustomFormField(
              label: 'Phone Number',
              hint: 'Enter recipient phone number',
              controller: _phoneController,
              focusNode: _phoneFocus,
              isRequired: true,
              inputType: InputFieldType.phone,
              textInputAction: TextInputAction.done,
              validator: FormUtils.validatePhoneNumber,
              prefixIcon: Icon(
                Iconsax.mobile,
                color:
                    isDarkMode ? AppColors.secondaryLight : AppColors.primary,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
            ),

            Spacing.verticalL,

            // Data plans section
            AppText.titleMedium(
              'Select Data Bundle',
              color: isDarkMode
                  ? AppColors.textDarkPrimary
                  : AppColors.textLightPrimary,
            ),
            Spacing.verticalM,

            // Filter tabs (Daily, Weekly, Monthly)
            _buildFilterTabs(isDarkMode),

            Spacing.verticalM,

            // Data plans grid
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                return _buildDataPlanCard(
                  context,
                  isDarkMode,
                  plan,
                  isSelected: _selectedPlan?.id == plan.id,
                  onTap: () {
                    setState(() {
                      _selectedPlan = plan;
                    });
                  },
                );
              },
            ),

            Spacing.verticalXXL,

            // Purchase button
            PrimaryButton(
              text: _selectedPlan != null
                  ? 'Buy ${_selectedPlan!.dataAmount} for ₦${_selectedPlan!.price.toInt()}'
                  : 'Select a Plan',
              onPressed: _selectedPlan != null ? _processDataPurchase : null,
              isLoading: _isProcessing,
              size: ButtonSize.large,
              backgroundColor:
                  isDarkMode ? AppColors.primaryLight : AppColors.primary,
            ),

            Spacing.verticalL,

            // Help text
            Align(
              alignment: Alignment.center,
              child: AppText.bodySmall(
                'You can check your data balance by dialing *556#',
                color: isDarkMode
                    ? AppColors.textDarkSecondary
                    : AppColors.textLightSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Provider card widget
  Widget _buildProviderCard({
    required BuildContext context,
    required bool isDarkMode,
    required String providerId,
    required String name,
    required String logoPath,
    required IconData fallbackIcon,
    required Color color,
  }) {
    final isSelected = _selectedProvider == providerId;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedProvider = providerId;
        });
        _showDataPlans();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDarkMode
              ? isSelected
                  ? AppColors.backgroundDarkTertiary
                  : AppColors.backgroundDarkSecondary
              : isSelected
                  ? AppColors.backgroundLightTertiary
                  : AppColors.backgroundLightSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? isDarkMode
                    ? AppColors.primaryLight
                    : AppColors.primary
                : isDarkMode
                    ? Colors.grey.withAlpha(41) // ~0.16 opacity
                    : Colors.grey.withAlpha(31), // ~0.12 opacity
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Logo
            _buildProviderLogo(providerId, 48, isDarkMode, color: color),

            const SizedBox(width: 16),

            // Name and description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? AppColors.textDarkPrimary
                          : AppColors.textLightPrimary,
                    ),
                  ),
                  Text(
                    'Tap to select',
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

            // Selection indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? isDarkMode
                        ? AppColors.primaryLight
                        : AppColors.primary
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : isDarkMode
                          ? Colors.grey.withAlpha(51) // ~0.2 opacity
                          : Colors.grey.withAlpha(77), // ~0.3 opacity
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // Build provider logo with fallback to icon
  Widget _buildProviderLogo(String providerId, double size, bool isDarkMode,
      {Color? color}) {
    final logoPath = 'assets/images/${providerId}_logo.png';
    final providerColor = color ?? _getProviderColor(providerId, isDarkMode);

    // Try to load logo, fallback to colored circle with letter
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: providerColor.withAlpha(40),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _getProviderName(providerId)[0].toUpperCase(),
          style: TextStyle(
            color: providerColor,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.4,
          ),
        ),
      ),
    );
  }

  // Get provider name from ID
  String _getProviderName(String providerId) {
    switch (providerId) {
      case 'mtn':
        return 'MTN';
      case 'airtel':
        return 'Airtel';
      case 'glo':
        return 'Glo';
      case '9mobile':
        return '9Mobile';
      default:
        return 'Unknown';
    }
  }

  // Get provider color
  Color _getProviderColor(String providerId, bool isDarkMode) {
    switch (providerId) {
      case 'mtn':
        return const Color(0xFFFFCC00);
      case 'airtel':
        return const Color(0xFFFF0000);
      case 'glo':
        return const Color(0xFF00AB4E);
      case '9mobile':
        return const Color(0xFF006F53);
      default:
        return isDarkMode ? AppColors.primaryLight : AppColors.primary;
    }
  }

  // Recent purchase card
  Widget _buildRecentPurchaseCard(
    BuildContext context,
    bool isDarkMode,
    String phone,
    String provider,
    String plan,
    String amount, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.backgroundDarkSecondary
              : AppColors.backgroundLightSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode
                ? Colors.grey.withAlpha(41) // ~0.16 opacity
                : Colors.grey.withAlpha(31), // ~0.12 opacity
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Network logo
            _buildProviderLogo(
              provider.toLowerCase(),
              40,
              isDarkMode,
            ),

            const SizedBox(width: 12),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    phone,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode
                          ? AppColors.textDarkPrimary
                          : AppColors.textLightPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$provider - $plan',
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

            // Amount
            Text(
              amount,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? AppColors.primaryLight : AppColors.primary,
              ),
            ),

            const SizedBox(width: 8),

            // Reuse icon
            Icon(
              Iconsax.refresh,
              size: 16,
              color: isDarkMode
                  ? AppColors.textDarkSecondary
                  : AppColors.textLightSecondary,
            ),
          ],
        ),
      ),
    );
  }

  // Build filter tabs (Daily, Weekly, Monthly)
  Widget _buildFilterTabs(bool isDarkMode) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.backgroundDarkSecondary
            : AppColors.backgroundLightSecondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterTab(
              'Daily',
              isDarkMode,
              isSelected: _selectedFilter == 'Daily',
            ),
          ),
          Expanded(
            child: _buildFilterTab(
              'Weekly',
              isDarkMode,
              isSelected: _selectedFilter == 'Weekly',
            ),
          ),
          Expanded(
            child: _buildFilterTab(
              'Monthly',
              isDarkMode,
              isSelected: _selectedFilter == 'Monthly',
            ),
          ),
        ],
      ),
    );
  }

  // Individual filter tab
  Widget _buildFilterTab(String text, bool isDarkMode,
      {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = text;
        });
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? isDarkMode
                  ? AppColors.primaryDark
                  : AppColors.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : isDarkMode
                    ? AppColors.textDarkSecondary
                    : AppColors.textLightSecondary,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // Data plan card
  Widget _buildDataPlanCard(
    BuildContext context,
    bool isDarkMode,
    DataPlanModel plan, {
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    final borderColor = isSelected
        ? isDarkMode
            ? AppColors.primaryLight
            : AppColors.primary
        : isDarkMode
            ? Colors.grey.withAlpha(41) // ~0.16 opacity
            : Colors.grey.withAlpha(31); // ~0.12 opacity

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode
              ? isSelected
                  ? AppColors.backgroundDarkTertiary
                  : AppColors.backgroundDarkSecondary
              : isSelected
                  ? AppColors.backgroundLightTertiary
                  : AppColors.backgroundLightSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Popular tag if applicable
            if (plan.isPopular)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.warningDark.withAlpha(40)
                      : AppColors.warningLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Popular',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color:
                        isDarkMode ? AppColors.warningLight : AppColors.warning,
                  ),
                ),
              ),

            // Data amount
            Text(
              plan.dataAmount,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary,
              ),
            ),

            const SizedBox(height: 8),

            // Validity
            Row(
              children: [
                Icon(
                  Iconsax.calendar,
                  size: 12,
                  color: isDarkMode
                      ? AppColors.textDarkSecondary
                      : AppColors.textLightSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  plan.duration,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode
                        ? AppColors.textDarkSecondary
                        : AppColors.textLightSecondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            // Description
            Text(
              plan.description,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode
                    ? AppColors.textDarkSecondary
                    : AppColors.textLightSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const Spacer(),

            // Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₦${plan.price.toInt()}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:
                        isDarkMode ? AppColors.primaryLight : AppColors.primary,
                  ),
                ),

                // Selection indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? isDarkMode
                            ? AppColors.primaryLight
                            : AppColors.primary
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : isDarkMode
                              ? Colors.grey.withAlpha(51) // ~0.2 opacity
                              : Colors.grey.withAlpha(77), // ~0.3 opacity
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// LengthLimitingTextInputFormatter class definition for compatibility
class LengthLimitingTextInputFormatter extends TextInputFormatter {
  final int maxLength;

  LengthLimitingTextInputFormatter(this.maxLength);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length > maxLength) {
      final TextSelection newSelection = newValue.selection.copyWith(
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
