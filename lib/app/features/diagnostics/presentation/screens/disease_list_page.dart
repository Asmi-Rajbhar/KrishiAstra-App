import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/widgets/widgets.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';
import 'package:krishiastra/app/core/navigation/app_router.dart';
import 'package:krishiastra/app/features/diagnostics/presentation/bloc/diagnostic_bloc.dart';
import 'package:krishiastra/app/features/diagnostics/presentation/widgets/diagnostics_widgets/diagnostics_card.dart';

import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/features/crop_variety/presentation/providers/crop_provider.dart';
import 'package:krishiastra/app/core/l10n/app_localizations.dart';

class DiseaseListPage extends StatefulWidget {
  const DiseaseListPage({super.key});

  @override
  State<DiseaseListPage> createState() => _DiseaseListPageState();
}

class _DiseaseListPageState extends State<DiseaseListPage> {
  @override
  void initState() {
    super.initState();
    final varietyId = context.read<CropProvider>().selectedVariety?.name;
    context.read<DiagnosticBloc>().add(FetchDiseaseList(varietyId: varietyId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        leadingIcon: AppIcons.arrowBackIosNew,
        titleText: AppLocalizations.of(context)!.diseaseSymptomChecker,
      ),
      body: BlocBuilder<DiagnosticBloc, DiagnosticState>(
        builder: (context, state) {
          if (state.status == DiagnosticStatus.loading &&
              state.diseases.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == DiagnosticStatus.error &&
              state.diseases.isEmpty) {
            return Center(
              child: Text(
                "${AppLocalizations.of(context)!.errorLabel} ${state.error}",
              ),
            );
          }

          if (state.diseases.isNotEmpty) {
            final diseases = state.diseases;
            return ListView.builder(
              padding: const EdgeInsets.all(AppSizes.md),
              itemCount: diseases.length,
              itemBuilder: (context, index) {
                final disease = diseases[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.md),
                  child: DiagnosticCard(
                    icon: AppIcons.coronavirus,
                    iconColor: _getSeverityColor(disease.severity),
                    title: disease.name,
                    description: disease.description,
                    imageUrl: disease.imageUrl,
                    footer: AppLocalizations.of(context)!.viewDetails,
                    onTap: () {
                      final varietyId = context
                          .read<CropProvider>()
                          .selectedVariety
                          ?.name;
                      Navigator.pushNamed(
                        context,
                        AppRouter.diseaseDetail,
                        arguments: {
                          'diseaseName': disease.name,
                          'varietyId': varietyId,
                        },
                      );
                    },
                  ),
                );
              },
            );
          }

          if (state.status == DiagnosticStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: Text(AppLocalizations.of(context)!.noDiseasesFound),
          );
        },
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  Color _getSeverityColor(String? severity) {
    if (severity == null) return AppColors.redShade;
    final sev = severity.toLowerCase();
    if (sev.contains('high')) return AppColors.red700;
    if (sev.contains('medium')) return AppColors.orange800;
    if (sev.contains('low')) return AppColors.green800;
    return AppColors.error;
  }
}
