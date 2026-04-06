import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:krishiastra/app/features/diagnostics/domain/entities/diagnostic_category_model.dart';
import 'package:krishiastra/app/features/diagnostics/presentation/bloc/diagnostic_bloc.dart';
import 'package:krishiastra/app/core/navigation/app_router.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krishiastra/app/core/widgets/widgets.dart';
import 'package:krishiastra/app/features/diagnostics/presentation/widgets/diagnostics_widgets/lifecycle_guide_card.dart';
import 'package:krishiastra/app/features/diagnostics/presentation/widgets/diagnostics_widgets/diagnostics_card.dart';
import 'package:krishiastra/app/features/diagnostics/presentation/widgets/diagnostics_widgets/ai_scanner_card.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';
import 'package:krishiastra/app/core/utils/l10n_helper.dart';

class DiagnosticCenterPage extends StatefulWidget {
  const DiagnosticCenterPage({super.key});

  @override
  State<DiagnosticCenterPage> createState() => _DiagnosticCenterPageState();
}

class _DiagnosticCenterPageState extends State<DiagnosticCenterPage> {
  @override
  void initState() {
    super.initState();
    context.read<DiagnosticBloc>().add(const FetchDiagnostics());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        leadingIcon: AppIcons.arrowBackIosNew,
        titleText: AppLocalizations.of(context)!.diagnosticDetailsTitle,
      ),
      body: BlocListener<DiagnosticBloc, DiagnosticState>(
        listener: (context, state) {
          if (state.status == DiagnosticStatus.error && state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(
              SnackBar(
                content: Text(
                  L10nHelper.getLocalizedMessage(context, state.error),
                ),
              ),
            );
          }
        },
        child: BlocBuilder<DiagnosticBloc, DiagnosticState>(
          builder: (context, state) {
            if (state.status == DiagnosticStatus.loading &&
                state.diagnostics.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == DiagnosticStatus.error &&
                state.diagnostics.isEmpty) {
              return Center(
                child: Text(
                  "${AppLocalizations.of(context)!.errorLabel} ${L10nHelper.getLocalizedMessage(context, state.error)}",
                ),
              );
            }

            if (state.diagnostics.isNotEmpty) {
              return ListView(
                padding: const EdgeInsets.only(
                  bottom: AppSizes.navBarHeight + AppSizes.xl,
                ),
                children: [
                  const SizedBox(height: AppSizes.xl),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.md),
                    child: AIScannerCard(),
                  ),
                  const SizedBox(height: AppSizes.xl),
                  _buildDiagnosticHub(context, state.diagnostics),
                  const SizedBox(height: AppSizes.xl),
                  const LifecycleGuideCard(),
                ],
              );
            }

            if (state.status == DiagnosticStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            return Center(
              child: Text(AppLocalizations.of(context)!.noDiagnosticsAvailable),
            );
          },
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  IconData _getCategoryIcon(DiagnosticType type) {
    switch (type) {
      case DiagnosticType.pest:
        return AppIcons.bugReport;
      case DiagnosticType.disease:
        return AppIcons.coronavirus;
      case DiagnosticType.nutrient:
        return AppIcons.science;
      case DiagnosticType.environment:
        return AppIcons.waterDrop;
    }
  }

  Color _getCategoryColor(DiagnosticType type) {
    switch (type) {
      case DiagnosticType.pest:
        return AppColors.warning;
      case DiagnosticType.disease:
        return AppColors.error;
      case DiagnosticType.nutrient:
        return AppColors.yellowShade;
      case DiagnosticType.environment:
        return AppColors.info;
    }
  }

  String _getCategoryTitle(BuildContext context, DiagnosticType type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case DiagnosticType.pest:
        return l10n.pestIdentification;
      case DiagnosticType.disease:
        return l10n.diseaseSymptomChecker;
      case DiagnosticType.nutrient:
        return l10n.nutrientDeficiency;
      case DiagnosticType.environment:
        return l10n.environmentalStress;
    }
  }

  String _getCategoryDescription(BuildContext context, DiagnosticType type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case DiagnosticType.pest:
        return l10n.pestIdentificationDesc;
      case DiagnosticType.disease:
        return l10n.diseaseSymptomCheckerDesc;
      case DiagnosticType.nutrient:
        return l10n.nutrientDeficiencyDesc;
      case DiagnosticType.environment:
        return l10n.environmentalStressDesc;
    }
  }

  String _getCategoryFooter(BuildContext context, DiagnosticType type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case DiagnosticType.pest:
        return l10n.pestIdentificationFooter;
      case DiagnosticType.disease:
        return l10n.diseaseSymptomCheckerFooter;
      case DiagnosticType.nutrient:
        return l10n.nutrientDeficiencyFooter;
      case DiagnosticType.environment:
        return l10n.environmentalStressFooter;
    }
  }

  /// Builds the diagnostic hub section with all categories
  Widget _buildDiagnosticHub(BuildContext context, List<dynamic> categories) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: Column(
        children: [
          // Section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.diagnosticDetailsTitle,
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: AppSizes.fontHeading,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // const Text(
              //   'SUGARCANE FOCUS',
              //   style: TextStyle(
              //     color: AppColors.accentGreen,
              //     fontSize: AppSizes.fontCaption,
              //     fontWeight: FontWeight.bold,
              //     letterSpacing: 1,
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          // Diagnostic cards
          ...categories.map((category) {
            final DiagnosticCategory diagCategory =
                category as DiagnosticCategory;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.md),
              child: DiagnosticCard(
                icon: _getCategoryIcon(diagCategory.type),
                iconColor: _getCategoryColor(diagCategory.type),
                title: _getCategoryTitle(context, diagCategory.type),
                description: _getCategoryDescription(
                  context,
                  diagCategory.type,
                ),
                footer: _getCategoryFooter(context, diagCategory.type),
                onTap: () {
                  if (diagCategory.type == DiagnosticType.pest ||
                      diagCategory.type == DiagnosticType.disease) {
                    Navigator.pushNamed(context, AppRouter.diseaseList);
                  } else if (diagCategory.type == DiagnosticType.nutrient) {
                    Navigator.pushNamed(context, AppRouter.nutrientDeficiency);
                  } else if (diagCategory.type == DiagnosticType.environment) {
                    Navigator.pushNamed(context, AppRouter.environmentalStress);
                  }
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
