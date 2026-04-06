import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/widgets/widgets.dart';
import 'package:krishiastra/app/features/diagnostics/domain/entities/nutrient.dart';
import 'package:krishiastra/app/features/diagnostics/domain/repositories/i_diagnostic_repository.dart';
import 'package:krishiastra/app/features/diagnostics/presentation/bloc/diagnostic_bloc.dart';
import 'package:krishiastra/app/features/diagnostics/presentation/screens/nutrient_detail_page.dart';
import 'package:krishiastra/app/features/diagnostics/presentation/widgets/nutrient_widgets/deficiency_card.dart';
import 'package:krishiastra/app/features/diagnostics/presentation/widgets/nutrient_widgets/nutrient_remedies_card.dart';
import 'package:krishiastra/app/features/diagnostics/presentation/widgets/nutrient_widgets/nutrient_symptom_item.dart';
import 'package:krishiastra/app/features/crop_variety/presentation/providers/crop_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';
import 'package:krishiastra/app/core/l10n/app_localizations.dart';

/// Nutrient Deficiency Page - Comprehensive guide for soil health monitoring
class NutrientDeficiencyPage extends StatelessWidget {
  const NutrientDeficiencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cropProvider = context.read<CropProvider>();
    final varietyId = cropProvider.selectedVariety?.name;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        leadingIcon: AppIcons.arrowBackIosNew,
        titleText: l10n.agriUniversity,
      ),
      body: BlocProvider(
        create: (context) => DiagnosticBloc(
          diagnosticRepository: context.read<IDiagnosticRepository>(),
        )..add(FetchNutrients(varietyId: varietyId)),
        child: BlocBuilder<DiagnosticBloc, DiagnosticState>(
          builder: (context, state) {
            if (state.status == DiagnosticStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == DiagnosticStatus.error) {
              return Center(child: Text(state.error ?? 'Error loading data'));
            }

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(
                      bottom: AppSizes.navBarHeight + AppSizes.xl,
                    ),
                    children: [
                      const SizedBox(height: AppSizes.md),
                      _buildCommonDeficienciesSection(context, state.nutrients),
                      const SizedBox(height: AppSizes.md),
                      _buildSymptomChecker(context, state.nutrients),
                      const SizedBox(height: AppSizes.md),
                      const NutrientRemediesCard(),
                      const SizedBox(height: AppSizes.md),
                      _buildVideoCard(context),
                      const SizedBox(height: AppSizes.md),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget _buildCommonDeficienciesSection(
    BuildContext context,
    List<Nutrient> nutrients,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: l10n.commonDeficiencies,
          titleColor: AppColors.primaryColor,
        ),
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
            itemCount: nutrients.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSizes.md),
            itemBuilder: (context, index) {
              final nutrient = nutrients[index];
              return InkWell(
                onTap: () => _navigateToDetail(context, nutrient.nutrient),
                child: DeficiencyCard(
                  imageUrl: nutrient.image,
                  nutrient: nutrient.nutrient,
                  color: _getNutrientColor(nutrient.nutrient),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSymptomChecker(BuildContext context, List<Nutrient> nutrients) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: l10n.detailedSymptomChecker,
          titleColor: AppColors.primaryColor,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          child: Column(
            children: [
              ...nutrients.map(
                (nutrient) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.sm),
                  child: InkWell(
                    onTap: () => _navigateToDetail(context, nutrient.nutrient),
                    child: NutrientSymptomItem(
                      icon: _getNutrientIcon(nutrient.nutrient),
                      iconColor: _getNutrientColor(nutrient.nutrient),
                      title: nutrient.nutrient,
                      description: nutrient.description,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToDetail(BuildContext context, String nutrientName) {
    final varietyId = context.read<CropProvider>().selectedVariety?.name;
    context.read<DiagnosticBloc>().add(
      FetchNutrientDetails(nutrientName, varietyId: varietyId),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (routeContext) => BlocProvider.value(
          value: context.read<DiagnosticBloc>(),
          child: NutrientDetailPage(nutrientName: nutrientName),
        ),
      ),
    );
  }

  Color _getNutrientColor(String nutrientName) {
    final nameLower = nutrientName.toLowerCase();
    if (nameLower.contains('nitrogen')) return AppColors.warning;
    if (nameLower.contains('phosphorus')) {
      return Colors.purple; // Keep purple or use accent
    }
    if (nameLower.contains('potassium')) return AppColors.info;
    return AppColors.success;
  }

  IconData _getNutrientIcon(String nutrientName) {
    final nameLower = nutrientName.toLowerCase();
    if (nameLower.contains('nitrogen')) return Icons.waves;
    if (nameLower.contains('phosphorus')) return Icons.colorize;
    if (nameLower.contains('potassium')) return Icons.water_drop;
    return Icons.eco;
  }

  Widget _buildVideoCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: ActionCard(
        title: l10n.soilTestingTitle,
        subtitle: l10n.soilTestingSubtitle,
        icon: Icons.play_circle,
        buttonText: l10n.watchVideo,
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.comingSoon)));
        },
        backgroundColor: AppColors.primaryColor,
        textColor: AppColors.white,
        iconColor: AppColors.white,
        buttonColor: AppColors.white,
        buttonTextColor: AppColors.primaryColor,
      ),
    );
  }
}
