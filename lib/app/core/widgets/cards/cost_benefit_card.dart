import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';

class CostBenefitCard extends StatelessWidget {
  final String cost;
  final String costUnit;
  final String benefit;
  final String benefitUnit;

  const CostBenefitCard({
    super.key,
    required this.cost,
    this.costUnit = '',
    required this.benefit,
    this.benefitUnit = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.grey100),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: AppSizes.sm,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: const BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSizes.radiusLg),
                topRight: Radius.circular(AppSizes.radiusLg),
              ),
              border: Border(bottom: BorderSide(color: AppColors.grey100)),
            ),
            child: Row(
              children: [
                const Icon(
                  AppIcons.payments,
                  color: AppColors.primaryColor,
                  size: AppSizes.iconMd,
                ),
                const SizedBox(width: AppSizes.sm),
                Text(
                  AppLocalizations.of(context)!.costbenefitSummary,
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: AppSizes.fontTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Metrics
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Row(
              children: [
                // Cost metric
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'EST. COST',
                          style: TextStyle(
                            color: AppColors.redShade,
                            fontSize: AppSizes.fontCaption,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: AppSizes.xxs),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                cost,
                                style: const TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: AppSizes.fontHero,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              costUnit,
                              style: const TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: AppSizes.fontBody,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                // Yield boost metric
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'YIELD BOOST',
                          style: TextStyle(
                            color: Colors.green.shade600,
                            fontSize: AppSizes.fontCaption,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: AppSizes.xxs),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              benefit,
                              style: const TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: AppSizes.fontHero,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              benefitUnit,
                              style: const TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: AppSizes.fontBody,
                              ),
                            ),
                          ],
                        ),
                      ],
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
}
