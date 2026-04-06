import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_info.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_risk_and_care.dart';
import 'package:krishiastra/app/features/crop_variety/domain/repositories/i_crop_repository.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/bloc/crop_risks/crop_risks_bloc.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/bloc/crop_risks/crop_risks_event.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/bloc/crop_risks/crop_risks_state.dart';
import 'package:flutter/material.dart';
import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CropRisksPage extends StatefulWidget {
  final CropInfo cropInfo;

  const CropRisksPage({super.key, required this.cropInfo});

  @override
  State<CropRisksPage> createState() => _CropRisksPageState();
}

class _CropRisksPageState extends State<CropRisksPage> {
  final Set<int> _expandedDiseases = {};
  final Set<String> _expandedCare = {};

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CropRisksBloc(repository: context.read<ICropRepository>())
            ..add(FetchCropRisksEvent(widget.cropInfo.cropName)),
      child: BlocBuilder<CropRisksBloc, CropRisksState>(
        builder: (context, state) {
          if (state is CropRisksLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          } else if (state is CropRisksError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: AppSizes.iconXl * 1.5,
                    ),
                    const SizedBox(height: AppSizes.md),
                    Text(
                      "${AppLocalizations.of(context)!.errorLabel} ${state.message}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.error),
                    ),
                    const SizedBox(height: AppSizes.md),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CropRisksBloc>().add(
                          FetchCropRisksEvent(widget.cropInfo.cropName),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.retry),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is CropRisksLoaded) {
            return _buildContent(context, state.data);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, CropRiskAndCare data) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.lg,
          AppSizes.xl,
          AppSizes.lg,
          AppSizes.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              l10n.watchOut,
              style: const TextStyle(
                fontSize: AppSizes.fontHero,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: AppSizes.xxs),
            Text(
              l10n.commonThreats,
              style: const TextStyle(
                fontSize: AppSizes.fontTitle,
                fontWeight: FontWeight.w600,
                color: AppColors.red700,
              ),
            ),
            const SizedBox(height: AppSizes.xxs),
            Text(
              l10n.seasonalRisksVigilance,
              style: const TextStyle(
                fontSize: AppSizes.fontBody,
                color: AppColors.grey500,
              ),
            ),
            const SizedBox(height: AppSizes.lg),

            // Dynamic Disease cards
            if (data.cropDiseases.isEmpty)
              Center(
                child: Text(AppLocalizations.of(context)!.noCommonThreats),
              ),
            ...data.cropDiseases.asMap().entries.map((entry) {
              final index = entry.key;
              final disease = entry.value;
              final isExpanded = _expandedDiseases.contains(index);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildThreatCard(
                  icon: index % 2 == 0
                      ? Icons.coronavirus_outlined
                      : Icons.bug_report_outlined,
                  title: disease.diseaseName,
                  subtitle: index % 2 == 0 ? l10n.disease : l10n.risk,
                  description: disease.description,
                  isExpanded: isExpanded,
                  onToggle: () {
                    setState(() {
                      if (isExpanded) {
                        _expandedDiseases.remove(index);
                      } else {
                        _expandedDiseases.add(index);
                      }
                    });
                  },
                  color: index % 2 == 0
                      ? AppColors.redShade
                      : AppColors.orangeShade,
                  bgColor:
                      (index % 2 == 0 ? AppColors.red100 : AppColors.orange100)
                          .withValues(alpha: 0.4),
                ),
              );
            }),

            const SizedBox(height: 12),

            // Care Instruction section
            Text(
              l10n.careInstruction,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 12),

            // Dynamic Care Instruction cards
            if (data.riskAndCare.highFertilizerLoad.isNotEmpty)
              _buildCareInstructionCard(
                id: 'fert_load',
                icon: Icons.science_outlined,
                iconColor: AppColors.yellowShade,
                title: l10n.highFertilizerLoad,
                description: data.riskAndCare.highFertilizerLoad,
                riskText: l10n.riskOverFertilization,
                riskLevel: 0.75,
                riskColor: AppColors.redShade,
              ),
            if (data.riskAndCare.fertilizerRequirements.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildCareInstructionCard(
                id: 'fert_req',
                icon: Icons.science_outlined,
                iconColor: AppColors.yellowShade,
                title: l10n.fertilizerRequirements,
                description: data.riskAndCare.fertilizerRequirements,
                riskText: l10n.riskOverFertilization,
                riskLevel: 0.50,
                riskColor: AppColors.blue800,
              ),
            ],
            if (data.riskAndCare.waterManagement.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildCareInstructionCard(
                id: 'water_mng',
                icon: Icons.water_drop_outlined,
                iconColor: AppColors.blueShade,
                title: l10n.waterManagement,
                description: data.riskAndCare.waterManagement,
                riskText: l10n.riskIrrigationIssues,
                riskLevel: 0.30,
                riskColor: AppColors.green400,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildThreatCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Color color,
    required Color bgColor,
  }) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border(left: BorderSide(color: color, width: 4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 10,
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    maxLines: isExpanded ? null : 2,
                    overflow: isExpanded ? null : TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.greyShade,
                      height: 1.4,
                    ),
                  ),
                  if (!isExpanded && description.length > 60)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        AppLocalizations.of(context)!.readMore,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCareInstructionCard({
    required String id,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String riskText,
    required double riskLevel,
    required Color riskColor,
  }) {
    final isExpanded = _expandedCare.contains(id);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isExpanded) {
            _expandedCare.remove(id);
          } else {
            _expandedCare.add(id);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              maxLines: isExpanded ? null : 3,
              overflow: isExpanded ? null : TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.greyShade,
                height: 1.5,
              ),
            ),
            if (!isExpanded && description.length > 80)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  AppLocalizations.of(context)!.readMore,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              riskText,
              style: const TextStyle(fontSize: 12, color: AppColors.greyShade),
            ),
            const SizedBox(height: 8),
            // Risk indicator bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: riskLevel,
                backgroundColor: AppColors.grey200,
                valueColor: AlwaysStoppedAnimation<Color>(riskColor),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
