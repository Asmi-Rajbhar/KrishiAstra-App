import 'package:flutter/material.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/l10n/app_localizations.dart';

class SeasonFilter extends StatelessWidget {
  final List<String> availableSeasons;
  final String? selectedSeason;
  final Function(String) onSeasonSelected;

  const SeasonFilter({
    super.key,
    required this.availableSeasons,
    required this.selectedSeason,
    required this.onSeasonSelected,
  });

  String _getLocalizedSeason(BuildContext context, String season) {
    final l10n = AppLocalizations.of(context)!;
    switch (season.toLowerCase()) {
      case 'khodwa':
        return l10n.khodwa;
      case 'suru':
        return l10n.suru;
      case 'adasali':
        return l10n.adasali;
      case 'purva hangami':
        return l10n.purvaHangami;
      case 'kharif':
        return l10n.kharif;
      default:
        return season.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: availableSeasons.map((season) {
          final isSelected =
              selectedSeason?.toLowerCase().trim() ==
              season.toLowerCase().trim();
          return Padding(
            padding: const EdgeInsets.only(right: AppSizes.sm),
            child: InkWell(
              onTap: () => onSeasonSelected(season),
              borderRadius: BorderRadius.circular(AppSizes.radiusMax),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md,
                  vertical: AppSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryColor : AppColors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMax),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.primaryColor.withValues(alpha: 0.15),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.2,
                            ),
                            spreadRadius: 1,
                            blurRadius: AppSizes.sm,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  _getLocalizedSeason(context, season),
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.white
                        : AppColors.primaryColor,
                    fontSize: AppSizes.fontCaption,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
