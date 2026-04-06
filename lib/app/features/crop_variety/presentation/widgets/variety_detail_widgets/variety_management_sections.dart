import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:krishiastra/app/core/widgets/widgets.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_variety_detail.dart';

class VarietyManagementSections extends StatelessWidget {
  final CropVarietyDetail detail;

  const VarietyManagementSections({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Weed Management
        if (detail.weedManagement != null) ...[
          const SizedBox(height: AppSizes.xl),
          InfoSection.list(
            context: context,
            title: l10n.weedManagement,
            description: l10n.weedManagementDesc,
            icon: Icons.grass,
            style: InfoListStyle.boxed,
            items: [
              InfoItem(
                title: detail.weedManagement!.name,
                content:
                    '${detail.weedManagement!.type}\n${detail.weedManagement!.solution}',
              ),
            ],
          ),
        ],

        // Diseases
        if (detail.diseases.isNotEmpty) ...[
          const SizedBox(height: AppSizes.xl),
          InfoSection.list(
            context: context,
            title: l10n.commonDiseases,
            description: l10n.susceptibilityAndResistance,
            icon: Icons.coronavirus,
            style: InfoListStyle.boxed,
            items: detail.diseases
                .map(
                  (e) => InfoItem(
                    title: e,
                    content: 'Check symptoms in Diagnosis',
                  ),
                )
                .toList(),
          ),
        ],

        // Pests
        if (detail.pests.isNotEmpty) ...[
          const SizedBox(height: AppSizes.xl),
          InfoSection.list(
            context: context,
            title: l10n.commonPests,
            description: l10n.potentialPestThreats,
            icon: Icons.bug_report,
            style: InfoListStyle.boxed,
            items: detail.pests
                .map(
                  (e) =>
                      InfoItem(title: e, content: 'Check for signs in field'),
                )
                .toList(),
          ),
        ],

        // Nutrients
        if (detail.nutrients.isNotEmpty) ...[
          const SizedBox(height: AppSizes.xl),
          InfoSection.list(
            context: context,
            title: l10n.nutrientRequirements,
            description: l10n.recommendedNourishment,
            icon: Icons.science,
            style: InfoListStyle.boxed,
            items: detail.nutrients
                .map(
                  (e) => InfoItem(title: e, content: 'Maintain soil balance'),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}
