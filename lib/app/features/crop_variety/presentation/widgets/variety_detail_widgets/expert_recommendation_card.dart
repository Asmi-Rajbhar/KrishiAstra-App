import 'package:flutter/material.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/l10n/app_localizations.dart';

class ExpertRecommendationCard extends StatelessWidget {
  final String? recommendation;

  const ExpertRecommendationCard({super.key, this.recommendation});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: AppSizes.xl,
        left: AppSizes.md,
        right: AppSizes.md,
      ),
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.4),
            blurRadius: AppSizes.lg,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.expertRecommendation,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: AppSizes.fontTitle,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            recommendation ??
                AppLocalizations.of(context)!.noExpertRecommendation,
            style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.9),
              fontSize: AppSizes.fontBody,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
