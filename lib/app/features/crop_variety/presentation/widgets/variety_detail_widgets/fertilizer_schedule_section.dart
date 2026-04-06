import 'package:flutter/material.dart';
import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:krishiastra/app/core/widgets/widgets.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_variety_detail.dart';

class FertilizerScheduleSection extends StatelessWidget {
  final List<FertilizerSchedule> schedule;

  const FertilizerScheduleSection({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    if (schedule.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;

    return InfoSection.table(
      context: context,
      title: l10n.fertilizerMicroNutrientsSchedule,
      icon: Icons.compost,
      headers: [l10n.growthStage, l10n.doseStage, l10n.recommendedNutrients],
      columnFlex: const [2, 2, 3],
      rows: schedule
          .map((e) => [e.growthStage, e.doseStage, e.recommendedNutrient])
          .toList(),
    );
  }
}
