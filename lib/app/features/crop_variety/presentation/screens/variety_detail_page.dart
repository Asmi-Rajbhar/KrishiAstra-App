import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';
import 'package:krishiastra/app/core/widgets/widgets.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_variety.dart';
import 'package:krishiastra/app/features/crop_variety/presentation/bloc/crop_variety_detail_bloc.dart';
import 'package:krishiastra/app/features/crop_variety/presentation/bloc/crop_variety_detail_event.dart';
import 'package:krishiastra/app/features/crop_variety/presentation/bloc/crop_variety_detail_state.dart';
import 'package:krishiastra/app/features/crop_variety/presentation/providers/crop_provider.dart';
import 'package:krishiastra/app/features/crop_variety/presentation/widgets/variety_detail_widgets/environmental_stress_section.dart';
import 'package:krishiastra/app/features/crop_variety/presentation/widgets/variety_detail_widgets/expert_recommendation_card.dart';
import 'package:krishiastra/app/features/crop_variety/presentation/widgets/variety_detail_widgets/fertilizer_schedule_section.dart';

import 'package:krishiastra/app/features/crop_variety/presentation/widgets/variety_detail_widgets/variety_characteristics_group.dart';
import 'package:krishiastra/app/features/crop_variety/presentation/widgets/variety_detail_widgets/variety_management_sections.dart';
import 'package:krishiastra/app/features/video_gallery/presentation/widgets/video_gallery_widgets/video_card.dart';
import 'package:krishiastra/app/core/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VarietyDetailPage extends StatefulWidget {
  final CropVariety variety;

  const VarietyDetailPage({super.key, required this.variety});

  @override
  State<VarietyDetailPage> createState() => _VarietyDetailPageState();
}

class _VarietyDetailPageState extends State<VarietyDetailPage> {
  @override
  void initState() {
    super.initState();
    final cropProvider = context.read<CropProvider>();
    final cropName = cropProvider.cropInfo?.name;
    final season = cropProvider.selectedSeason;

      
    // ADD THIS DEBUG LINE
    debugPrint('=== VARIETY DETAIL DEBUG ===');
    debugPrint('cropName: $cropName');
    debugPrint('season: $season');
    debugPrint('variety: ${widget.variety.name}');

    context.read<CropVarietyDetailBloc>().add(
      LoadCropVarietyDetail(
        widget.variety.name,
        cropName: cropName,
        season: season,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        leadingIcon: AppIcons.arrowBackIosNew,
        titleText: widget.variety.name,
      ),
      body: BlocBuilder<CropVarietyDetailBloc, CropVarietyDetailState>(
        builder: (context, state) {
          if (state is CropVarietyDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CropVarietyDetailLoaded) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.md),
                    child: HeroCard.single(
                      imageUrl: widget.variety.imageUrl,
                      title: widget.variety.name,
                      subtitle:
                          widget.variety.expertRecommendation ??
                          widget.variety.name,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                    ),
                    child: VarietyCharacteristicsGroup(
                      variety: widget.variety,
                      detail: state.detail,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xl),
                  FertilizerScheduleSection(
                    schedule: state.detail.fertilizerSchedule,
                  ),
                  VarietyManagementSections(detail: state.detail),
                  EnvironmentalStressSection(
                    stress: state.detail.environmentalStress,
                  ),
                  ExpertRecommendationCard(
                    recommendation: state.detail.expertRecommendation,
                  ),
                  if (state.varietyVideo != null)
                    _buildVideoSection(context, l10n, state.varietyVideo!),

                  const SizedBox(height: AppSizes.xl * 2),
                ],
              ),
            );
          }

          if (state is CropVarietyDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${l10n.errorLabel} ${state.message}'),
                  const SizedBox(height: AppSizes.md),
                  ElevatedButton(
                    onPressed: () {
                      final cropName = context
                          .read<CropProvider>()
                          .cropInfo
                          ?.name;
                      context.read<CropVarietyDetailBloc>().add(
                        LoadCropVarietyDetail(
                          widget.variety.name,
                          cropName: cropName,
                        ),
                      );
                    },
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildVideoSection(
    BuildContext context,
    AppLocalizations l10n,
    dynamic video,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.watchVideoButton,
                style: TextStyle(
                  color: AppColors.primaryColor.withValues(alpha: 0.6),
                  fontSize: AppSizes.fontCaption,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRouter.videoGallery),
                child: Text(
                  l10n.seeAll,
                  style: const TextStyle(
                    color: AppColors.accentGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          VideoCard(video: video),
        ],
      ),
    );
  }
  
}
