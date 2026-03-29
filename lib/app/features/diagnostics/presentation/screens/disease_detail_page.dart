import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/widgets/widgets.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';
import 'package:krishiastra/app/features/diagnostics/domain/entities/disease.dart';
import 'package:krishiastra/app/features/diagnostics/presentation/bloc/diagnostic_bloc.dart';
import 'package:krishiastra/app/core/l10n/app_localizations.dart';

class DiseaseDetailPage extends StatefulWidget {
  final String diseaseName;
  final String? varietyId;

  const DiseaseDetailPage({
    super.key,
    required this.diseaseName,
    this.varietyId,
  });

  @override
  State<DiseaseDetailPage> createState() => _DiseaseDetailPageState();
}

class _DiseaseDetailPageState extends State<DiseaseDetailPage> {
  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  void _fetchDetails() {
    context.read<DiagnosticBloc>().add(
      FetchDiseaseDetails(widget.diseaseName, varietyId: widget.varietyId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        leadingIcon: AppIcons.arrowBackIosNew,
        titleText: widget.diseaseName,
      ),
      body: BlocBuilder<DiagnosticBloc, DiagnosticState>(
        builder: (context, state) {
          if (state.status == DiagnosticStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == DiagnosticStatus.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: AppSizes.iconXl * 2,
                    ),
                    const SizedBox(height: AppSizes.md),
                    Text(
                      state.error ?? l10n.somethingWentWrong,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: AppSizes.fontBody),
                    ),
                    const SizedBox(height: AppSizes.lg),
                    ElevatedButton(
                      onPressed: _fetchDetails,
                      child: Text(l10n.tryAgain),
                    ),
                  ],
                ),
              ),
            );
          }

          final disease = state.selectedDisease;
          if (disease == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.search_off_outlined,
                    color: AppColors.grey400,
                    size: AppSizes.iconXl * 2,
                  ),
                  const SizedBox(height: AppSizes.md),
                  Text(
                    "${l10n.noDataFound} ${widget.diseaseName}",
                    style: const TextStyle(color: AppColors.grey600),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.only(bottom: AppSizes.xl),
            children: [
              _buildImageHeader(disease, l10n),
              const SizedBox(height: AppSizes.md),
              _buildOverviewSection(disease, l10n),
              if (disease.symptoms.isNotEmpty) ...[
                const SizedBox(height: AppSizes.md),
                _buildSymptomsSection(disease, l10n),
              ],
              if (disease.remedies.isNotEmpty) ...[
                const SizedBox(height: AppSizes.md),
                _buildRemediesSection(disease, l10n),
              ],
              if (disease.details.isNotEmpty) ...[
                const SizedBox(height: AppSizes.md),
                _buildInDepthSection(disease, l10n),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildImageHeader(Disease disease, AppLocalizations l10n) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.sm,
        AppSizes.md,
        0,
      ),
      child: HeroCard.single(
        imageUrl: disease.imageUrl ?? '',
        title: disease.name,
        subtitle: disease.severity?.isNotEmpty == true
            ? "${l10n.severityLabel} ${disease.severity}"
            : l10n.diseaseSymptomChecker,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        height: 200,
        gradientColors: [
          AppColors.black.withValues(alpha: 0.1),
          AppColors.black.withValues(alpha: 0.8),
        ],
      ),
    );
  }

  Widget _buildOverviewSection(Disease disease, AppLocalizations l10n) {
    return SectionCard(
      title: l10n.overview,
      icon: const Icon(
        Icons.info_outline,
        color: AppColors.accentGreen,
        size: AppSizes.iconMd,
      ),
      child: Text(
        disease.description,
        style: const TextStyle(
          color: AppColors.grey600,
          fontSize: AppSizes.fontBody,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildSymptomsSection(Disease disease, AppLocalizations l10n) {
    return SectionCard(
      title: l10n.symptoms,
      icon: const Icon(
        AppIcons.visibility,
        color: AppColors.accentGreen,
        size: AppSizes.iconMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: disease.symptoms
            .split(RegExp(r'\n+'))
            .where((s) => s.trim().isNotEmpty)
            .map((point) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: AppSizes.xs),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.accentGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Text(
                        point.trim(),
                        style: const TextStyle(
                          color: AppColors.grey600,
                          fontSize: AppSizes.fontBody,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            })
            .toList(),
      ),
    );
  }

  Widget _buildRemediesSection(Disease disease, AppLocalizations l10n) {
    return SectionCard(
      title: l10n.remedies,
      icon: const Icon(
        AppIcons.healthAndSafety,
        color: AppColors.accentGreen,
        size: AppSizes.iconMd,
      ),
      child: Column(
        children: disease.remedies.map((remedy) {
          return Column(
            children: [
              if (remedy.preventiveMeasures.isNotEmpty)
                _buildRemedyTypeCard(
                  l10n.preventive,
                  remedy.preventiveMeasures,
                  Icons.shield_outlined,
                  AppColors.info,
                ),
              if (remedy.biologicalControl.isNotEmpty)
                _buildRemedyTypeCard(
                  l10n.biological,
                  remedy.biologicalControl,
                  Icons.eco_outlined,
                  AppColors.success,
                ),
              if (remedy.chemicalControl.isNotEmpty)
                _buildRemedyTypeCard(
                  l10n.chemical,
                  remedy.chemicalControl,
                  Icons.science_outlined,
                  AppColors.error,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRemedyTypeCard(
    String type,
    String content,
    IconData icon,
    Color color,
  ) {
    return BaseCard(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      padding: const EdgeInsets.all(AppSizes.sm),
      color: AppColors.white,
      borderRadius: AppSizes.radiusMd,
      boxShadow: [
        BoxShadow(
          color: color.withValues(alpha: 0.1),
          blurRadius: AppSizes.sm,
          offset: const Offset(0, 2),
        ),
      ],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: AppSizes.iconMd),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    color: color,
                    fontSize: AppSizes.fontCaption,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  content,
                  style: const TextStyle(
                    color: AppColors.grey600,
                    fontSize: AppSizes.fontBody,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInDepthSection(Disease disease, AppLocalizations l10n) {
    return SectionCard(
      title: l10n.inDepthDetails,
      icon: const Icon(
        Icons.list_alt_outlined,
        color: AppColors.accentGreen,
        size: AppSizes.iconMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: disease.details.map((detail) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.sm),
            child: Text(
              detail,
              style: const TextStyle(
                color: AppColors.grey600,
                fontSize: AppSizes.fontBody,
                height: 1.5,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
