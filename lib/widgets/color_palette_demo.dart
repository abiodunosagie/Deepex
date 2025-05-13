import 'package:deepex/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Widget to demonstrate the app's color palette
class ColorPaletteDemo extends StatelessWidget {
  const ColorPaletteDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deepex Color Palette'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            'Brand Colors',
            [
              _buildColorCard('Primary', AppColors.primary),
              _buildColorCard('Primary Light', AppColors.primaryLight),
              _buildColorCard('Primary Lighter', AppColors.primaryLighter),
              _buildColorCard('Primary Lightest', AppColors.primaryLightest),
              _buildColorCard('Primary Dark', AppColors.primaryDark),
              _buildColorCard('Primary Darker', AppColors.primaryDarker),
              const SizedBox(height: 16),
              _buildColorCard('Secondary', AppColors.secondary),
              _buildColorCard('Secondary Light', AppColors.secondaryLight),
              _buildColorCard('Secondary Lighter', AppColors.secondaryLighter),
              _buildColorCard(
                  'Secondary Lightest', AppColors.secondaryLightest),
              _buildColorCard('Secondary Dark', AppColors.secondaryDark),
              _buildColorCard('Secondary Darker', AppColors.secondaryDarker),
            ],
          ),
          _buildSection(
            'Accent Colors',
            [
              _buildColorCard('Accent 1', AppColors.accent1),
              _buildColorCard('Accent 2', AppColors.accent2),
              _buildColorCard('Accent 3', AppColors.accent3),
            ],
          ),
          _buildSection(
            'Background Colors',
            isDarkMode
                ? [
                    _buildColorCard('Background', AppColors.backgroundDark),
                    _buildColorCard('Background Secondary',
                        AppColors.backgroundDarkSecondary),
                    _buildColorCard('Background Tertiary',
                        AppColors.backgroundDarkTertiary),
                    _buildColorCard('Background Elevated',
                        AppColors.backgroundDarkElevated),
                  ]
                : [
                    _buildColorCard('Background', AppColors.backgroundLight),
                    _buildColorCard('Background Secondary',
                        AppColors.backgroundLightSecondary),
                    _buildColorCard('Background Tertiary',
                        AppColors.backgroundLightTertiary),
                    _buildColorCard('Background Elevated',
                        AppColors.backgroundLightElevated),
                  ],
          ),
          _buildSection(
            'Text Colors',
            isDarkMode
                ? [
                    _buildColorCard('Text Primary', AppColors.textDarkPrimary),
                    _buildColorCard(
                        'Text Secondary', AppColors.textDarkSecondary),
                    _buildColorCard(
                        'Text Disabled', AppColors.textDarkDisabled),
                    _buildColorCard('Text Inverse', AppColors.textDarkInverse),
                  ]
                : [
                    _buildColorCard('Text Primary', AppColors.textLightPrimary),
                    _buildColorCard(
                        'Text Secondary', AppColors.textLightSecondary),
                    _buildColorCard(
                        'Text Disabled', AppColors.textLightDisabled),
                    _buildColorCard('Text Inverse', AppColors.textLightInverse),
                  ],
          ),
          _buildSection(
            'Status Colors',
            [
              _buildColorCard('Success', AppColors.success),
              _buildColorCard('Success Light', AppColors.successLight),
              _buildColorCard('Success Dark', AppColors.successDark),
              const SizedBox(height: 8),
              _buildColorCard('Error', AppColors.error),
              _buildColorCard('Error Light', AppColors.errorLight),
              _buildColorCard('Error Dark', AppColors.errorDark),
              const SizedBox(height: 8),
              _buildColorCard('Warning', AppColors.warning),
              _buildColorCard('Warning Light', AppColors.warningLight),
              _buildColorCard('Warning Dark', AppColors.warningDark),
              const SizedBox(height: 8),
              _buildColorCard('Info', AppColors.info),
              _buildColorCard('Info Light', AppColors.infoLight),
              _buildColorCard('Info Dark', AppColors.infoDark),
            ],
          ),
          _buildSection(
            'Feature Colors',
            [
              _buildColorCard('Gift Card', AppColors.giftCard),
              _buildColorCard('Gift Card Light', AppColors.giftCardLight),
              const SizedBox(height: 8),
              _buildColorCard('Airtime', AppColors.airtime),
              _buildColorCard('Airtime Light', AppColors.airtimeLight),
              const SizedBox(height: 8),
              _buildColorCard('Data', AppColors.data),
              _buildColorCard('Data Light', AppColors.dataLight),
              const SizedBox(height: 8),
              _buildColorCard('Electricity', AppColors.electricity),
              _buildColorCard('Electricity Light', AppColors.electricityLight),
            ],
          ),
          _buildSection(
            'Gradients',
            [
              _buildGradientCard('Brand Gradient', AppColors.brandGradient),
              _buildGradientCard('Primary Gradient', AppColors.primaryGradient),
              _buildGradientCard(
                  'Secondary Gradient', AppColors.secondaryGradient),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
        const Divider(height: 32),
      ],
    );
  }

  Widget _buildColorCard(String name, Color color) {
    final textColor = _contrastingTextColor(color);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                color.value.toRadixString(16).toUpperCase().substring(2),
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '#${color.value.toRadixString(16).toUpperCase().substring(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientCard(String name, Gradient gradient) {
    if (gradient is LinearGradient) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Color _contrastingTextColor(Color backgroundColor) {
    // Calculate luminance - this is a value between 0 and 1
    final luminance = backgroundColor.computeLuminance();
    // If luminance is greater than 0.5, use black text, otherwise white
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
