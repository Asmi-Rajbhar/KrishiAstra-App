import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:krishiastra/app/core/widgets/widgets.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_variety_detail.dart';

class EnvironmentalStressSection extends StatelessWidget {
  final VarietyEnvironmentalStress? stress;

  const EnvironmentalStressSection({super.key, this.stress});

  @override
  Widget build(BuildContext context) {
    if (stress == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;

    final name = stress!.stressName;
    final severity = stress!.severity;
    final symptoms = stress!.symptoms;
    final causes = stress!.causes;
    final impact = stress!.impactOnCrop;
    final prevention = stress!.preventiveMeasures;

    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.xl),
      child: InfoSection.list(
        context: context,
        title: l10n.environmentalStress,
        description: l10n.detailedImpactAnalysis,
        icon: Icons.thermostat,
        style: InfoListStyle.boxed,
        items: [
          if (name != null) InfoItem(title: 'Stress Type', content: name),
          if (severity != null)
            InfoItem(title: 'Severity Level', content: severity),
          if (symptoms != null && symptoms.isNotEmpty)
            InfoItem(title: 'Symptoms', content: symptoms),
          if (causes != null && causes.isNotEmpty)
            InfoItem(title: 'Causes', content: causes),
          if (impact != null && impact.isNotEmpty)
            InfoItem(title: 'Impact on Crop', content: impact),
          if (prevention != null && prevention.isNotEmpty)
            InfoItem(title: 'Preventive Measures', content: prevention),
        ],
      ),
    );
  }
}
