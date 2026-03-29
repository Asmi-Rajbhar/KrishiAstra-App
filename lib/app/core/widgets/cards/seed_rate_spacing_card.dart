import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'content_card.dart';

class SeedRateSpacingCard extends StatelessWidget {
  final Map<String, dynamic>? data;

  const SeedRateSpacingCard({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final metrics = data?['metrics'] as List<dynamic>?;
    final depth = data?['depth'] as Map<String, dynamic>?;

    return ContentCard(
      title: data?['title'] ?? 'Seed Rate & Spacing',
      subtitle: data?['subtitle'] ?? 'Recommended measurements',
      icon: Icons.straighten,
      child: Column(
        children: [
          // Metric cards
          if (metrics != null)
            Row(
              children: metrics.map((m) {
                final isLast = metrics.last == m;
                final map = m is Map ? m : const {};
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: isLast ? 0 : AppSizes.md),
                    child: _buildMetricCard(
                      icon: _mapIcon(map['icon']?.toString() ?? ''),
                      label: map['label']?.toString() ?? '',
                      value: map['value']?.toString() ?? '',
                      unit: map['unit']?.toString() ?? '',
                    ),
                  ),
                );
              }).toList(),
            )
          else
            const Row(
              children: [
                Expanded(
                  child: SeedRateSpacingMetricCard(
                    icon: Icons.grain,
                    label: 'SEED RATE',
                    value: '6-7',
                    unit: 'tonnes/ha',
                  ),
                ),
                SizedBox(width: AppSizes.md),
                Expanded(
                  child: SeedRateSpacingMetricCard(
                    icon: Icons.space_bar,
                    label: 'SPACING',
                    value: '90-120',
                    unit: 'cm',
                  ),
                ),
              ],
            ),
          const SizedBox(height: AppSizes.md),
          // Planting depth card
          if (depth != null)
            _buildMetricCard(
              icon: _mapIcon(depth['icon']?.toString() ?? ''),
              label: depth['label']?.toString() ?? '',
              value: depth['value']?.toString() ?? '',
              unit: depth['unit']?.toString() ?? '',
              isFullWidth: true,
            )
          else
            const SeedRateSpacingMetricCard(
              icon: Icons.vertical_align_bottom,
              label: 'PLANTING DEPTH',
              value: '5-8',
              unit: 'cm (setts placement)',
              isFullWidth: true,
            ),
        ],
      ),
    );
  }

  IconData _mapIcon(String icon) {
    switch (icon) {
      case 'grain':
        return Icons.grain;
      case 'space_bar':
        return Icons.space_bar;
      case 'vertical_align_bottom':
        return Icons.vertical_align_bottom;
      default:
        return Icons.help;
    }
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    bool isFullWidth = false,
  }) {
    return SeedRateSpacingMetricCard(
      icon: icon,
      label: label,
      value: value,
      unit: unit,
      isFullWidth: isFullWidth,
    );
  }
}

class SeedRateSpacingMetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final bool isFullWidth;

  const SeedRateSpacingMetricCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.grey500, size: AppSizes.iconSm),
              const SizedBox(width: AppSizes.xs),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey600,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.xs),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: AppSizes.fontTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: const TextStyle(
                    fontSize: AppSizes.fontCaption,
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
