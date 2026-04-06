import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class PlantingSeasonHeroCard extends StatelessWidget {
  final Map<String, dynamic>? data;

  const PlantingSeasonHeroCard({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final title = data?['title'] ?? 'Ideal Planting';
    final subtitle = data?['subtitle'] ?? 'Optimal seasons for maximum yield';
    final badgeText = data?['badgeText'] ?? 'SUGARCANE';
    final items = data?['seasons'] as List<dynamic>?;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.3),
            blurRadius: AppSizes.md,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background glow effects
          Positioned(
            top: -64,
            right: -64,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.accentGreen.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.sm,
                    vertical: AppSizes.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: AppSizes.fontHero,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                // Subtitle
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.green100,
                    fontSize: AppSizes.fontBody,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                // Season cards
                Row(
                  children: items != null
                      ? items.map((item) {
                          final isLast = items.last == item;
                          final map = item is Map ? item : const {};
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: isLast ? 0 : AppSizes.md,
                              ),
                              child: _buildSeasonInfo(
                                label: map['label']?.toString() ?? '',
                                months: map['months']?.toString() ?? '',
                              ),
                            ),
                          );
                        }).toList()
                      : [
                          Expanded(
                            child: _buildSeasonInfo(
                              label: 'AUTUMN',
                              months: 'Oct-Nov',
                            ),
                          ),
                          const SizedBox(width: AppSizes.md),
                          Expanded(
                            child: _buildSeasonInfo(
                              label: 'SPRING',
                              months: 'Jan-Feb',
                            ),
                          ),
                        ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonInfo({required String label, required String months}) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.greenShade,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            months,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: AppSizes.fontHeading,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
