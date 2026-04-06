import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';
import 'package:krishiastra/app/core/widgets/navigation/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:krishiastra/app/core/widgets/navigation/app_bar.dart';
import 'package:krishiastra/app/core/widgets/cards/action_card.dart';
import 'package:krishiastra/app/core/widgets/cards/planting_season_hero_card.dart';
import 'package:krishiastra/app/core/widgets/cards/sowing_calendar_card.dart';
import 'package:krishiastra/app/core/widgets/cards/soil_preparation_card.dart';
import 'package:krishiastra/app/core/widgets/cards/seed_rate_spacing_card.dart';

import 'package:krishiastra/app/features/crop_guide/domain/entities/variety_plantation_data.dart';
import 'package:krishiastra/app/features/crop_guide/domain/repositories/i_crop_guide_repository.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/features/video_gallery/presentation/widgets/video_gallery_widgets/video_card.dart';
import 'package:krishiastra/app/features/video_gallery/domain/entities/video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:provider/provider.dart';

import 'package:krishiastra/app/features/crop_variety/presentation/providers/crop_provider.dart';
import 'package:krishiastra/app/features/video_gallery/presentation/widgets/video_gallery_widgets/compact_video_card.dart';

class PlantingSeasonGuidePage extends StatefulWidget {
  const PlantingSeasonGuidePage({super.key});

  @override
  State<PlantingSeasonGuidePage> createState() =>
      _PlantingSeasonGuidePageState();
}

class _PlantingSeasonGuidePageState extends State<PlantingSeasonGuidePage> {
  VarietyPlantationData? _plantationData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final provider = context.read<CropProvider>();
      final varietyId = provider.selectedVariety?.name;
      final season = provider.selectedSeason;

      if (varietyId == null || season == null) {
        if (mounted) {
          setState(() {
            _error = "Please select a variety and season first";
            _isLoading = false;
          });
        }
        return;
      }

      final result = await context
          .read<ICropGuideRepository>()
          .getPlantationSeasonData(varietyId: varietyId, season: season);
      if (mounted) {
        setState(() {
          if (result.isSuccess) {
            final list = result.data!;
            _plantationData = list.isNotEmpty ? list.first : null;
          } else {
            _error = result.failure?.message;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        leadingIcon: AppIcons.arrowBackIosNew,
        titleText: AppLocalizations.of(context)!.plantingSeason,
      ),
      body: _buildBody(),
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accentGreen),
      );
    }

    if (_error != null) {
      return Center(
        child: Text(
          "${AppLocalizations.of(context)!.errorLabel} $_error",
          style: const TextStyle(color: AppColors.error),
        ),
      );
    }

    if (_plantationData == null) {
      return Center(child: Text(AppLocalizations.of(context)!.noDataFound));
    }

    // Map VarietyPlantationData to existing UI requirements
    final heroSeasons = _plantationData!.plantationSeasons.map((s) {
      return {'label': s.season.toUpperCase(), 'months': s.month};
    }).toList();

    final heroData = {
      'title': 'Ideal Planting',
      'subtitle': 'Optimal seasons for ${_plantationData!.cropVariety}',
      'badgeText': 'SUGARCANE',
      'seasons': heroSeasons,
    };

    // Calculate suitable months for the calendar
    final List<int> suitableMonths = [];
    final monthMap = {
      'jan': 0,
      'feb': 1,
      'mar': 2,
      'apr': 3,
      'may': 4,
      'jun': 5,
      'jul': 6,
      'aug': 7,
      'sep': 8,
      'oct': 9,
      'nov': 10,
      'dec': 11,
    };

    for (var season in _plantationData!.plantationSeasons) {
      final months = season.month.split('-');
      if (months.length == 2) {
        final start = monthMap[months[0].trim().toLowerCase()] ?? 0;
        final end = monthMap[months[1].trim().toLowerCase()] ?? 0;

        for (int i = start; ; i = (i + 1) % 12) {
          suitableMonths.add(i);
          if (i == end) break;
          if (suitableMonths.length > 24) break;
        }
      }
    }

    final calendarData = {
      'title': 'Sowing Calendar',
      'subtitle': 'Monthly suitability guide',
      'suitableMonths': suitableMonths,
    };

    final seedRateAndSpacing = _plantationData!.seedRateAndSpacing.isNotEmpty
        ? _plantationData!.seedRateAndSpacing.first
        : const SeedRateSpacingInfo(
            seedRate: 'N/A',
            spacing: 'N/A',
            depth: 'N/A',
          );

    final seedRateSpacingData = {
      'title': 'Seed Rate & Spacing',
      'subtitle': 'Recommended measurements',
      'metrics': [
        {
          'icon': 'grain',
          'label': 'SEED RATE',
          'value': seedRateAndSpacing.seedRate,
          'unit': 'tonnes/ha',
        },
        {
          'icon': 'space_bar',
          'label': 'SPACING',
          'value': seedRateAndSpacing.spacing,
          'unit': 'cm',
        },
      ],
      'depth': {
        'icon': 'vertical_align_bottom',
        'label': 'PLANTING DEPTH',
        'value': seedRateAndSpacing.depth,
        'unit': 'cm (setts placement)',
      },
    };

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSizes.xl * 3),
      children: [
        const SizedBox(height: AppSizes.lg),
        PlantingSeasonHeroCard(data: heroData),
        const SizedBox(height: AppSizes.md),
        SowingCalendarCard(data: calendarData),
        const SizedBox(height: AppSizes.md),
        if (_plantationData!.soilPreparation.isNotEmpty)
          SoilPreparationCard(
            data: {
              'title': 'Soil Preparation',
              'subtitle': 'Requirements for growth',
              'steps': _plantationData!.soilPreparation
                  .expand(
                    (s) => [
                      if (s.deepPloughing.isNotEmpty)
                        {
                          'icon': 'filter_hdr',
                          'title': 'Deep Ploughing',
                          'description': s.deepPloughing,
                        },
                      if (s.harrowing.isNotEmpty)
                        {
                          'icon': 'grid_on',
                          'title': 'Harrowing',
                          'description': s.harrowing,
                        },
                      if (s.manureApplication.isNotEmpty)
                        {
                          'icon': 'water',
                          'title': 'Manure Application',
                          'description': s.manureApplication,
                        },
                    ],
                  )
                  .toList(),
            },
          ),
        const SizedBox(height: AppSizes.md),
        SeedRateSpacingCard(data: seedRateSpacingData),
        if (_plantationData!.videos.isNotEmpty) ...[
          const SizedBox(height: AppSizes.lg),
          _buildVideoSection(_plantationData!.videos, context),
        ] else ...[
          const SizedBox(height: AppSizes.md),
          _buildVideoButton({
            'title': 'Watch Tutorial',
            'subtitle': 'Learn the best planting techniques',
            'buttonText': 'Watch Now',
          }),
        ],
        const SizedBox(height: AppSizes.xl),
      ],
    );
  }

  Widget _buildVideoSection(
    List<PlantationVideo> videos,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Videos & Gallery',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: AppSizes.fontTitle,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.accentGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        if (videos.length > 1)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
            child: Row(
              children: videos.map((video) {
                final videoModel = Video(
                  imageUrl: '',
                  duration: video.duration,
                  title: video.title,
                  description: video.description ?? '',
                  uploadTime: 'RECENT',
                  youtubeVideoId: YoutubePlayer.convertUrlToId(video.url),
                  url: video.url,
                );

                return Padding(
                  padding: const EdgeInsets.only(right: AppSizes.md),
                  child: CompactVideoCard(video: videoModel),
                );
              }).toList(),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
            child: VideoCard(
              video: Video(
                imageUrl: '',
                duration: videos.first.duration,
                title: videos.first.title,
                description: videos.first.description ?? '',
                uploadTime: 'RECENT',
                youtubeVideoId: YoutubePlayer.convertUrlToId(videos.first.url),
                url: videos.first.url,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVideoButton(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      child: ActionCard(
        title: data['title'],
        subtitle: data['subtitle'],
        icon: Icons.play_circle,
        buttonText: data['buttonText'],
        onPressed: () {},
        backgroundColor: AppColors.primaryColor,
        textColor: AppColors.white,
        iconColor: AppColors.white,
        buttonColor: AppColors.white,
        buttonTextColor: AppColors.primaryColor,
      ),
    );
  }
}
