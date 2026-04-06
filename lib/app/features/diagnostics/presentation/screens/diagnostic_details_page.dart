import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/widgets/widgets.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';
import 'package:krishiastra/app/features/diagnostics/domain/entities/disease.dart';
import 'package:krishiastra/app/features/diagnostics/presentation/bloc/diagnostic_bloc.dart';
import 'package:krishiastra/app/features/diagnostics/presentation/widgets/diagnostics_widgets/ai_scanner_card.dart';
import 'package:krishiastra/app/core/l10n/app_localizations.dart';

class DiagnosticDetailPage extends StatefulWidget {
  final Disease disease;
  const DiagnosticDetailPage({super.key, required this.disease});

  @override
  State<DiagnosticDetailPage> createState() => _DiagnosticDetailPageState();
}

class _DiagnosticDetailPageState extends State<DiagnosticDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        leadingIcon: AppIcons.arrowBackIosNew,
        titleText: AppLocalizations.of(context)!.diagnosticDetailsTitle,
      ),
      body: BlocBuilder<DiagnosticBloc, DiagnosticState>(
        builder: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          Disease currentDisease = widget.disease;

          if (state.status == DiagnosticStatus.loading &&
              state.selectedDisease == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == DiagnosticStatus.loaded &&
              state.selectedDisease != null) {
            currentDisease = state.selectedDisease!.copyWith(
              imageUrl: state.selectedDisease!.imageUrl?.isNotEmpty == true
                  ? state.selectedDisease!.imageUrl
                  : widget.disease.imageUrl,
            );
          }

          if (state.status == DiagnosticStatus.error &&
              currentDisease.symptoms.isEmpty) {
            return Center(child: Text("${l10n.errorLabel}${state.error}"));
          }

          return ListView(
            padding: const EdgeInsets.only(bottom: AppSizes.xl * 4),
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AIScannerCard(),
                    const SizedBox(height: AppSizes.lg),
                    HeroCard(
                      title: '',
                      imageUrls: [
                        currentDisease.imageUrl?.isNotEmpty == true
                            ? currentDisease.imageUrl!
                            : '',
                      ],
                    ),
                    const SizedBox(height: AppSizes.md),
                    CardHeader(
                      title: currentDisease.name,
                      description: currentDisease.details.isNotEmpty
                          ? currentDisease.details.first
                          : '',
                      badgeText: currentDisease.severity?.isNotEmpty == true
                          ? currentDisease.severity!
                          : l10n.inDepthView,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.md),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                child: Row(
                  children: [
                    Expanded(
                      child: PrimaryActionButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.comingSoon)),
                          );
                        },
                        icon: AppIcons.playCircle,
                        label: l10n.watchVideoButton,
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        border: Border.all(color: AppColors.grey200),
                      ),
                      child: IconButton(
                        icon: const Icon(AppIcons.bookmarkOutline),
                        color: AppColors.primaryColor,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.comingSoon)),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              if (currentDisease.symptoms.isNotEmpty)
                InfoSection.list(
                  context: context,
                  title: l10n.symptoms,
                  icon: AppIcons.visibility,
                  items: currentDisease.symptoms
                      .split(RegExp(r'\s{2,}|\n'))
                      .where((s) => s.trim().isNotEmpty)
                      .map((s) => InfoItem(content: s.trim()))
                      .toList(),
                ),
              const SizedBox(height: AppSizes.lg),
              if (currentDisease.remedies.isNotEmpty)
                InfoSection.table(
                  context: context,
                  title: l10n.remedies,
                  icon: AppIcons.healthAndSafety,
                  headers: [l10n.type, l10n.actionDescription],
                  columnFlex: const [1, 2],
                  rows: currentDisease.remedies
                      .expand(
                        (r) => [
                          if (r.preventiveMeasures.isNotEmpty)
                            [l10n.preventive, r.preventiveMeasures],
                          if (r.biologicalControl.isNotEmpty)
                            [l10n.biological, r.biologicalControl],
                          if (r.chemicalControl.isNotEmpty)
                            [l10n.chemical, r.chemicalControl],
                        ],
                      )
                      .toList(),
                ),
              const SizedBox(height: AppSizes.lg),
            ],
          );
        },
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}
