import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_info.dart';
import 'package:krishiastra/app/features/crop_variety/presentation/bloc/crop_variety_bloc.dart';
import 'package:krishiastra/app/features/crop_variety/presentation/providers/crop_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/navigation/app_router.dart';
import 'package:krishiastra/app/features/crop_variety/presentation/widgets/variety_widgets/variety_card.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';
import 'package:krishiastra/app/core/l10n/app_localizations.dart';

class VarietyPage extends StatefulWidget {
  final CropInfo cropInfo;

  const VarietyPage({super.key, required this.cropInfo});

  @override
  State<VarietyPage> createState() => _VarietyPageState();
}

class _VarietyPageState extends State<VarietyPage> {
  String? _selectedSeason;

  @override
  void initState() {
    super.initState();
    context.read<CropVarietyBloc>().add(
      FetchCropVarieties(cropName: widget.cropInfo.name),
    );
  }

  void _showFilterOptions(List<String> availableSeasons) {
    final l10n = AppLocalizations.of(context)!;
    final Map<String, String> seasons = {'ALL': l10n.allSeasons};

    for (var season in availableSeasons) {
      if (season.isNotEmpty) {
        seasons[season.toUpperCase()] = season;
      }
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXl),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSizes.lg,
            horizontal: AppSizes.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.chooseSeason,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSizes.md),
              Wrap(
                spacing: AppSizes.sm,
                runSpacing: AppSizes.sm,
                children: seasons.entries.map((entry) {
                  final isSelected =
                      (_selectedSeason == null && entry.key == 'ALL') ||
                      (_selectedSeason == entry.key);
                  return FilterChip(
                    label: Text(entry.value),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedSeason = entry.key == 'ALL' ? null : entry.key;
                      });
                      context.read<CropVarietyBloc>().add(
                        FetchCropVarieties(
                          season: _selectedSeason,
                          cropName: widget.cropInfo.name,
                        ),
                      );
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Builder(
        builder: (context) {
          return _buildBody(context);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<CropVarietyBloc, CropVarietyState>(
      builder: (context, state) {
        if (state is CropVarietyLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CropVarietyError) {
          return Center(
            child: Text(
              "${AppLocalizations.of(context)!.errorLabel} ${state.message}",
            ),
          );
        }
        if (state is CropVarietyLoaded) {
          final varieties = state.cropVarieties;
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.md,
              AppSizes.md,
              AppSizes.md,
              AppSizes.navBarHeight,
            ),
            itemCount: varieties.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${varieties.length} ${AppLocalizations.of(context)!.recommendedVarieties}",
                          style: const TextStyle(
                            color: AppColors.greyShade,
                            fontSize: AppSizes.fontCaption,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () =>
                              _showFilterOptions(state.availableSeasons),
                          icon: const Icon(
                            AppIcons.tune,
                            size: AppSizes.iconMd,
                            color: AppColors.primaryColor,
                          ),
                          label: Text(
                            _selectedSeason ??
                                AppLocalizations.of(context)!.filter,
                            style: const TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.sm),
                  ],
                );
              }

              final variety = varieties[index - 1];
              return VarietyCard(
                variety: variety,
                onPressed: () async {
                  await context.read<CropProvider>().updateVariety(variety);
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRouter.landing,
                      (route) => false,
                    );
                  }
                },
              );
            },
          );
        }
        return Center(
          child: Text(AppLocalizations.of(context)!.somethingWentWrong),
        );
      },
    );
  }
}
