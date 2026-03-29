import 'package:flutter/material.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:krishiastra/app/core/widgets/widgets.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_variety.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_variety_detail.dart';

class VarietyCharacteristicsGroup extends StatelessWidget {
  final CropVariety variety;
  final CropVarietyDetail? detail;

  const VarietyCharacteristicsGroup({
    super.key,
    required this.variety,
    this.detail,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final items = [
      (
        Icons.account_tree,
        l10n.parantage,
        detail?.parentage ?? variety.parentage,
      ),
      (
        Icons.scale,
        l10n.averageYield,
        detail?.expectedYield ?? variety.expectedYield ?? '',
      ),
      (
        Icons.percent,
        l10n.sucrosePercentage,
        detail?.sucrosePercentage ?? variety.sucrosePercentage,
      ),
      (
        Icons.security,
        l10n.resistanceToPestsDiseases,
        detail?.diseaseResistance ?? variety.resistance,
      ),
      (
        Icons.grass,
        l10n.recommendedSoilType,
        detail?.recommendedSoilType ?? variety.soilType,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.characteristicsTitle,
          style: TextStyle(
            color: AppColors.primaryColor.withValues(alpha: 0.6),
            fontSize: AppSizes.fontCaption,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: AppSizes.md),
        for (int i = 0; i < items.length; i++) ...[
          InfoCard(
            icon: items[i].$1,
            label: items[i].$2,
            value: items[i].$3 ?? "N/A",
            primaryColor: AppColors.primaryColor,
          ),
          if (i < items.length - 1) const SizedBox(height: AppSizes.sm),
        ],
      ],
    );
  }
}
