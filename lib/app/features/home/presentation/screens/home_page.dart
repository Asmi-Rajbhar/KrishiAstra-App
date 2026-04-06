import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:krishiastra/app/core/bloc/language/language_bloc.dart';
import 'package:krishiastra/app/core/bloc/language/language_state.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';
import 'package:krishiastra/app/core/widgets/cards/hero_card.dart';
import 'package:krishiastra/app/core/navigation/app_router.dart';
import 'package:krishiastra/app/core/widgets/navigation/app_bar.dart';
import 'package:krishiastra/app/core/widgets/cards/section_header.dart';
import 'package:flutter/material.dart';
import 'package:krishiastra/app/features/crop_variety/presentation/providers/crop_provider.dart';
import 'package:krishiastra/app/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krishiastra/app/features/home/domain/entities/crop_card_entity.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const FetchHomeCrops());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(titleText: l10n.agriUniversity),
      body: BlocListener<LanguageBloc, LanguageState>(
        listener: (context, state) {
          if (state.status == LanguageStatus.ready) {
            context.read<HomeBloc>().add(const FetchHomeCrops());
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: HeroCard.single(
                  height: 400,
                  borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDj6oSvUXIrflLqjqrDq_hpblqYDTvMtWalGku8EkY4-Yqm8j13Aih6PSHCWLd-UAQb5AeqWLG-AseGXBeqGafNtRE8tl4fbeonyAzO0Z9Xv6f0dj4SFKykoScQhZUiMsV1bcAJQbR-Cj4m5SlaL69s0bhg4-ZA3BFXQZcFOiyi6JgkskqF0_FTrFTV8lrzndSe8Hxwywbi-lomsw3XFf8ib0NOGwoOstQWiobTTAWVK92EX_ARg_i7qf7BwMkm64Z23QWJD_WwKzsQ',
                  badgeText: l10n.cropOfTheMonth,
                  badgeIcon: AppIcons.checkCircle,
                  badgeColor: AppColors.neonGreen.withValues(alpha: 0.2),
                  badgeTextColor: AppColors.neonGreen,
                  showBorder: true,
                  title: l10n.sugarcane,
                  titleFontSize: AppSizes.fontHero,
                  subtitle: l10n.sugarcaneSubtitle,
                  subtitleFontSize: AppSizes.fontCaption,
                  gradientColors: [
                    AppColors.transparent,
                    AppColors.explorerBackground.withValues(alpha: 0.5),
                    AppColors.explorerBackground,
                  ],
                  action: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            AppRouter.cropHome,
                            arguments: 'Sugarcane',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.neonGreen,
                          foregroundColor: AppColors.explorerBackground,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.xl,
                            vertical: AppSizes.md,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusMax,
                            ),
                          ),
                          elevation: 0,
                          shadowColor: AppColors.neonGreen.withValues(
                            alpha: 0.3,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.exploreDetails,
                              style: const TextStyle(
                                fontSize: AppSizes.fontBody,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: AppSizes.sm),
                            const Icon(
                              AppIcons.chevronRight,
                              size: AppSizes.iconMd,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SectionHeader(
                title: l10n.browseCrops,
                actionText: l10n.seeAll,
                onActionPressed: () {},
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.md,
                  0,
                  AppSizes.md,
                  120,
                ),
                child: _buildBody(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.xl),
              child: CircularProgressIndicator(color: AppColors.neonGreen),
            ),
          );
        }

        if (state is HomeError) {
          return Center(
            child: Text(
              "${AppLocalizations.of(context)!.errorLabel} ${state.message}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is HomeLoaded) {
          if (state.crops.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.noCropsFound),
            );
          }
          return _buildCropGrid(context, state.crops);
        }

        return const SizedBox.shrink();
      },
    );
  }

  /// Builds the crop grid
  Widget _buildCropGrid(BuildContext context, List<CropCardEntity> crops) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: crops.length,
      itemBuilder: (context, index) => _buildCropCard(context, crops[index]),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: AppSizes.md,
        mainAxisSpacing: AppSizes.md,
      ),
    );
  }

  /// Builds a single crop card
  Widget _buildCropCard(BuildContext context, CropCardEntity crop) {
    final l10n = AppLocalizations.of(context)!;

    // Convert keys from JSON to localized strings
    String localizedBadge = _getLocalizedValue(l10n, crop.badge);
    String localizedName = _getLocalizedValue(l10n, crop.name);
    // If _getLocalizedValue returned the key (meaning it's not in l10n),
    // and crop.name was actually translated by ML Kit, it's already correct.
    // If it wasn't translated, it's the English key.

    return InkWell(
      onTap: () {
        context.read<CropProvider>().updateCrop(crop.name);
        Navigator.of(
          context,
        ).pushNamed(AppRouter.cropHome, arguments: crop.name);
      },
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          boxShadow: [
            const BoxShadow(
              color: AppColors.black26,
              blurRadius: AppSizes.radiusMd,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                crop.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: AppColors.explorerBackground),
              ),
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.transparent,
                        AppColors.black26,
                        AppColors.black,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: AppSizes.md,
                right: AppSizes.md,
                bottom: AppSizes.md,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizedBadge,
                      style: const TextStyle(
                        color: AppColors.neonGreen,
                        fontSize: AppSizes.fontCaption,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      localizedName,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: AppSizes.fontContent,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLocalizedValue(AppLocalizations l10n, String key) {
    // Mapping keys to l10n properties
    switch (key) {
      case 'highYield':
        return l10n.highYield;
      case 'resilient':
        return l10n.resilient;
      case 'waterIntensive':
        return l10n.waterIntensive;
      case 'cashCrop':
        return l10n.cashCrop;
      case 'proteinRich':
        return l10n.proteinRich;
      case 'exportQuality':
        return l10n.exportQuality;
      case 'wheat':
        return l10n.wheat;
      case 'maize':
        return l10n.maize;
      case 'rice':
        return l10n.rice;
      case 'cotton':
        return l10n.cotton;
      case 'soybeans':
        return l10n.soybeans;
      case 'coffee':
        return l10n.coffee;
      case 'grapes':
        return l10n.grapes;
      case 'corn':
        return l10n.corn;
      default:
        return key;
    }
  }
}
