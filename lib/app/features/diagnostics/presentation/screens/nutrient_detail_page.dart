import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/widgets/widgets.dart';
import 'package:krishiastra/app/features/video_gallery/presentation/widgets/video_gallery_widgets/video_card.dart';
import 'package:krishiastra/app/features/video_gallery/domain/entities/video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:krishiastra/app/features/crop_variety/presentation/providers/crop_provider.dart';
import 'package:krishiastra/app/features/diagnostics/domain/entities/nutrient.dart';
import 'package:krishiastra/app/features/diagnostics/presentation/bloc/diagnostic_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';

class NutrientDetailPage extends StatelessWidget {
  final String nutrientName;

  const NutrientDetailPage({super.key, required this.nutrientName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        leadingIcon: AppIcons.arrowBackIosNew,
        titleText: nutrientName,
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
                      state.error ??
                          AppLocalizations.of(context)!.somethingWentWrong,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: AppSizes.fontBody),
                    ),
                    const SizedBox(height: AppSizes.lg),
                    ElevatedButton(
                      onPressed: () {
                        context.read<DiagnosticBloc>().add(
                          FetchNutrientDetails(
                            nutrientName,
                            varietyId: context
                                .read<CropProvider>()
                                .selectedVariety
                                ?.name,
                          ),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.tryAgain),
                    ),
                  ],
                ),
              ),
            );
          }

          final nutrient = state.selectedNutrient;
          if (nutrient == null) {
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
                    "${AppLocalizations.of(context)!.noDataFound} $nutrientName",
                    style: const TextStyle(color: AppColors.grey600),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
            children: [
              _buildImageHeader(nutrient),
              const SizedBox(height: AppSizes.md),
              _buildInfoSection(nutrient),
              if (nutrient.symptoms != null) ...[
                const SizedBox(height: AppSizes.md),
                _buildSection(
                  title: 'Visual Symptoms',
                  icon: Icons.remove_red_eye_outlined,
                  content: nutrient.symptoms!,
                ),
              ],
              if (nutrient.causeOfDeficiency != null) ...[
                const SizedBox(height: AppSizes.md),
                _buildSection(
                  title: 'Potential Causes',
                  icon: Icons.help_outline,
                  content: nutrient.causeOfDeficiency!,
                  color: AppColors.warningLight,
                  iconColor: AppColors.warning,
                ),
              ],
              if (nutrient.remedies != null &&
                  nutrient.remedies!.isNotEmpty) ...[
                const SizedBox(height: AppSizes.md),
                _buildRemediesSection(nutrient.remedies!),
              ],
              if (nutrient.video != null) ...[
                const SizedBox(height: AppSizes.md),
                _buildVideoSection(nutrient.video!),
              ],
              const SizedBox(height: AppSizes.xl),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImageHeader(Nutrient nutrient) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.sm,
        AppSizes.md,
        0,
      ),
      child: HeroCard.single(
        imageUrl: nutrient.image,
        title: nutrient.nutrient,
        subtitle: 'Nutrient Deficiency Guide',
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        height: 200,
        gradientColors: [
          AppColors.black.withValues(alpha: 0.1),
          AppColors.black.withValues(alpha: 0.8),
        ],
      ),
    );
  }

  Widget _buildInfoSection(Nutrient nutrient) {
    return SectionCard(
      title: 'Overview',
      icon: const Icon(
        Icons.info_outline,
        color: AppColors.accentGreen,
        size: AppSizes.iconMd,
      ),
      child: Text(
        nutrient.description,
        style: const TextStyle(
          color: AppColors.grey600,
          fontSize: AppSizes.fontBody,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required String content,
    Color? color,
    Color? iconColor,
  }) {
    return SectionCard(
      title: title,
      icon: Icon(
        icon,
        color: iconColor ?? AppColors.accentGreen,
        size: AppSizes.iconMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: content.split('\n\n').map((point) {
          if (point.trim().isEmpty) return const SizedBox();
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: AppSizes.xs),
                  child: Container(
                    width: AppSizes.xs,
                    height: AppSizes.xs,
                    decoration: BoxDecoration(
                      color: iconColor ?? AppColors.accentGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
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
        }).toList(),
      ),
    );
  }

  Widget _buildRemediesSection(List<NutrientRemedy> remedies) {
    return SectionCard(
      title: 'Treatment & Remedies',
      icon: const Icon(
        Icons.gavel_outlined,
        color: AppColors.accentGreen,
        size: AppSizes.iconMd,
      ),
      child: Column(
        children: remedies
            .map(
              (remedy) => Column(
                children: [
                  if (remedy.preventiveMeasures != null)
                    _buildRemedyTypeCard(
                      'Preventive',
                      remedy.preventiveMeasures!,
                      Icons.shield_outlined,
                      AppColors.info,
                    ),
                  if (remedy.biologicalControl != null)
                    _buildRemedyTypeCard(
                      'Biological',
                      remedy.biologicalControl!,
                      Icons.eco_outlined,
                      AppColors.success,
                    ),
                  if (remedy.chemicalControl != null)
                    _buildRemedyTypeCard(
                      'Chemical',
                      remedy.chemicalControl!,
                      Icons.science_outlined,
                      AppColors.error,
                    ),
                ],
              ),
            )
            .toList(),
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
          offset: const Offset(0, AppSizes.xs),
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
          const SizedBox(width: AppSizes.sm),
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
                const SizedBox(height: AppSizes.xxs),
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

  Widget _buildVideoSection(NutrientVideo video) {
    // ... video player setup (omitted for brevity in replacement)
    final videoModel = Video(
      imageUrl: '',
      duration: video.duration,
      title: video.title,
      description:
          video.description ??
          'Watch this video to learn more about ${video.title}.',
      uploadTime: 'RECENT',
      youtubeVideoId: YoutubePlayer.convertUrlToId(video.url),
      url: video.url,
    );

    return SectionCard(
      title: 'Educational Video',
      icon: const Icon(
        Icons.play_circle_outline,
        color: AppColors.accentGreen,
        size: AppSizes.iconMd,
      ),
      child: VideoCard(video: videoModel),
    );
  }
}
