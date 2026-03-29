import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:krishiastra/app/features/crop_variety/presentation/providers/crop_provider.dart';
import 'package:krishiastra/app/core/navigation/app_router.dart';
import 'package:krishiastra/app/core/widgets/widgets.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';
import 'package:krishiastra/app/features/crop_variety/presentation/bloc/crop_variety_detail_bloc.dart';
import 'package:krishiastra/app/features/crop_variety/presentation/bloc/crop_variety_detail_event.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    // Use `listen: false` to prevent listening to changes in initState
    final provider = Provider.of<CropProvider>(context, listen: false);
    provider.loadData();

    if (provider.selectedVariety != null) {
      context.read<CropVarietyDetailBloc>().add(
        LoadCropVarietyDetail(
          provider.selectedVariety!.name,
          season: provider.selectedVariety!.season,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider to rebuild when data changes
    final provider = context.watch<CropProvider>();
    final cropInfo = provider.cropInfo;
    final selectedVariety = provider.selectedVariety;

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        leadingIcon: AppIcons.arrowBackIosNew,
        titleText: selectedVariety != null
            ? "${cropInfo?.cropName ?? ''} - ${selectedVariety.name}"
            : AppLocalizations.of(context)!.agriUniversity,
        onLeadingPressed: () {
          final cropName = provider.cropInfo?.name;
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRouter.cropHome,
            (route) => false,
            arguments: {'cropName': cropName, 'initialIndex': 4},
          );
        },
      ),
      // Handle loading/error states if needed, but for Home we often show skeletal or wait.
      // Since `loadData` is called in main, it might be ready or loading.
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Use data from provider
                        HeroCard.single(
                          imageUrl:
                              selectedVariety?.imageUrl ??
                              cropInfo?.imageUrl ??
                              '',
                          title:
                              selectedVariety?.name ??
                              cropInfo?.cropName ??
                              l10n.cropDetails,
                          subtitle:
                              selectedVariety?.expertRecommendation ??
                              cropInfo?.scientificName ??
                              l10n.cropInformation,
                        ),
                        const SizedBox(height: AppSizes.xxs),
                        if (selectedVariety == null)
                          Text(
                            cropInfo?.cropDescription ?? 'Description...',
                            style: const TextStyle(
                              fontSize: AppSizes.fontBody,
                              height: AppSizes.xxs,
                              color: AppColors.black,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // if (selectedVariety != null) ...[
                  //   const SizedBox(height: AppSizes.md),
                  //   // Optional: Show a small "Current Variety" status card here if needed
                  // ],
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.md,
                      AppSizes.xl,
                      AppSizes.md,
                      AppSizes.md,
                    ),
                    child: Row(
                      children: [
                        Text(
                          l10n.cropDetails,
                          style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: AppSizes.fontHeading,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        _SeasonDropdown(
                          selectedSeason: provider.selectedSeason,
                          availableSeasons: provider.availableSeasons,
                          onSeasonSelected: (season) {
                            provider.updateSeason(season);
                            if (selectedVariety != null) {
                              context.read<CropVarietyDetailBloc>().add(
                                LoadCropVarietyDetail(
                                  selectedVariety.name,
                                  season: season,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                    ),
                    child: Column(
                      children: [
                        CropCard(
                          icon: AppIcons.autorenew,
                          title: l10n.cropLifecycle,
                          description: l10n.cropLifecycleDesc,
                          buttonText: l10n.cropLifecycleButton,
                          buttonIcon: AppIcons.navigation,
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamed(AppRouter.lifecycle);
                          },
                        ),
                        const SizedBox(height: AppSizes.md),
                        CropCard(
                          icon: AppIcons.book,
                          title: l10n.cropInformation,
                          description: selectedVariety != null
                              ? "${l10n.seeFullDetails} ${selectedVariety.name}"
                              : l10n.cropInformationDesc,
                          buttonIcon: selectedVariety != null
                              ? AppIcons.chevronRight
                              : AppIcons.gridView,
                          buttonText: selectedVariety != null
                              ? l10n.seeFullDetails
                              : l10n.cropInformationButton,
                          onPressed: () {
                            if (selectedVariety != null) {
                              Navigator.of(context).pushNamed(
                                AppRouter.varietyDetail,
                                arguments: selectedVariety,
                              );
                            } else {
                              if (cropInfo != null) {
                                Navigator.of(context).pushNamed(
                                  AppRouter.variety,
                                  arguments: cropInfo,
                                );
                              }
                            }
                          },
                        ),
                        const SizedBox(height: AppSizes.lg),
                        CropCard(
                          icon: AppIcons.thermostat,
                          title: l10n.climaticRequirements,
                          description: l10n.climaticRequirementsDesc,
                          duration:
                              '08 mins', // Hardcoded duration is fine for now as it's metadata
                          buttonIcon: AppIcons.chevronRight,
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamed(AppRouter.climaticRequirements);
                          },
                          buttonText: l10n.viewClimaticRequirements,
                        ),
                        const SizedBox(height: AppSizes.lg),
                        CropCard(
                          icon: AppIcons.calendarMonth,
                          title: l10n.plantingSeason,
                          description: l10n.plantingSeasonDesc,
                          buttonIcon: AppIcons.chevronRight,
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamed(AppRouter.plantingSeason);
                          },
                          buttonText: l10n.plantingSeason,
                        ),
                        const SizedBox(height: AppSizes.lg),
                        CropCard(
                          icon: AppIcons.bugReport,
                          title: l10n.pestManagement,
                          description: l10n.pestManagementDesc,
                          buttonText: l10n.pestManagementButton,
                          buttonIcon: AppIcons.searchRounded,
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamed(AppRouter.diagnostics);
                          },
                        ),
                        const SizedBox(height: AppSizes.xl * 2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}

/// A pill-shaped DropdownButton for selecting the crop season.
class _SeasonDropdown extends StatelessWidget {
  const _SeasonDropdown({
    required this.selectedSeason,
    required this.availableSeasons,
    required this.onSeasonSelected,
  });

  final String? selectedSeason;
  final List<String> availableSeasons;
  final ValueChanged<String> onSeasonSelected;

  @override
  Widget build(BuildContext context) {
    final bool hasSelection = selectedSeason != null;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: hasSelection ? AppColors.accentGreen : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(AppSizes.radiusMax),
        border: Border.all(color: AppColors.accentGreen, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGreen.withValues(alpha: 0.18),
            blurRadius: AppSizes.sm,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedSeason,
          hint: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: AppSizes.fontCaption,
                color: AppColors.accentGreen,
              ),
              const SizedBox(width: AppSizes.xs),
              Text(
                l10n.chooseSeason,
                style: const TextStyle(
                  fontSize: AppSizes.fontCaption,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accentGreen,
                ),
              ),
            ],
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: hasSelection ? AppColors.white : AppColors.accentGreen,
            size: AppSizes.fontContent,
          ),
          isDense: true,
          dropdownColor: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          style: const TextStyle(
            fontSize: AppSizes.fontCaption,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
          selectedItemBuilder: (_) => availableSeasons
              .map(
                (s) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: AppSizes.fontCaption,
                      color: AppColors.white,
                    ),
                    const SizedBox(width: AppSizes.xs),
                    Text(
                      s,
                      style: const TextStyle(
                        fontSize: AppSizes.fontCaption,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
          items: availableSeasons
              .map(
                (season) => DropdownMenuItem<String>(
                  value: season,
                  child: Row(
                    children: [
                      Icon(
                        Icons.wb_sunny_rounded,
                        size: AppSizes.iconMd,
                        color: season == selectedSeason
                            ? AppColors.accentGreen
                            : AppColors.grey400,
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Text(
                        season,
                        style: TextStyle(
                          fontSize: AppSizes.fontCaption,
                          fontWeight: season == selectedSeason
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: season == selectedSeason
                              ? AppColors.accentGreen
                              : AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) onSeasonSelected(value);
          },
        ),
      ),
    );
  }
}
