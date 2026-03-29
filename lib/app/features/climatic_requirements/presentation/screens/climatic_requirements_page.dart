import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/widgets/cards/action_card.dart';
import 'package:krishiastra/app/core/widgets/cards/climatic_resilance_card.dart';
import 'package:krishiastra/app/core/widgets/cards/water_moisture_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'package:krishiastra/app/core/widgets/navigation/app_bar.dart';
import 'package:krishiastra/app/core/widgets/navigation/bottom_nav.dart';
import 'package:krishiastra/app/core/widgets/cards/hero_card.dart';
import 'package:krishiastra/app/core/widgets/cards/metric_card.dart';
import '../bloc/climatic_bloc.dart';
import '../bloc/climatic_state.dart';
import 'package:krishiastra/app/features/crop_variety/presentation/providers/crop_provider.dart';
import 'package:krishiastra/app/features/climatic_requirements/domain/entities/climatic_model.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';

class ClimaticRequirementsPage extends StatefulWidget {
  const ClimaticRequirementsPage({super.key});

  @override
  State<ClimaticRequirementsPage> createState() =>
      _ClimaticRequirementsPageState();
}

class _ClimaticRequirementsPageState extends State<ClimaticRequirementsPage> {
  @override
  void initState() {
    super.initState();
    final crop = context.read<CropProvider>().selectedCropName;
    context.read<ClimaticBloc>().add(FetchClimaticRequirements(crop: crop));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        leadingIcon: AppIcons.arrowBackIosNew,
        titleText: AppLocalizations.of(context)!.climaticRequirements,
      ),
      body: BlocBuilder<ClimaticBloc, ClimaticState>(
        builder: (context, state) {
          if (state is ClimaticLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accentGreen),
            );
          }

          if (state is ClimaticError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is ClimaticLoaded) {
            final requirement = state.climaticRequirement;
            final l10n = AppLocalizations.of(context)!;
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.backgroundLight, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.only(bottom: AppSizes.xl * 4),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: AppSizes.md,
                      right: AppSizes.md,
                      top: AppSizes.md,
                    ),
                    child: HeroCard.single(
                      imageUrl:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBkeN8SP23gBEzx7VU6CQnT5G1ZtGwd-aPHEYQHPl76Bw7xIJg_UE8gKiohwTNzTDBXLawRRIIpEHuzm0RbKX63RHKABtVNX9tFnJxAURiWSeSkmox4USOjf5jFZ0_4f9tosE3P3OAaWVCQmqkK7qSjBkVIxmgRFVkQj9IRmARVVhzsSkWmHeLmsAxcx1TRJHgvx86q4KXm6CwOFre57iMde46NHvH9b7g7Xo5ISWnZMxXShq0AqJGmseRr90-UsPVh592mYpwSIRw',
                      title: l10n.cropClimateRequirements(requirement.cropName),
                      subtitle:
                          l10n.optimizedFarmingDesc(requirement.cropName),
                      badgeText: l10n.optimalClimateConditions,
                      badgeIcon: Icons.auto_awesome_rounded,
                      height: 280,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  _buildSectionHeader(l10n.environmentalMetrics),
                  _buildTempSunlightCards(requirement, l10n),
                  const SizedBox(height: AppSizes.md),
                  buildWaterMoistureCard(
                    data: {
                      'annual_requirement':
                          requirement.rainfall.annualRequirement,
                      'rainfall_description': requirement.rainfall.description,
                      'humidity_during_growth': requirement.humidity.growth,
                      'humidity_during_maturity': requirement.humidity.maturity,
                    },
                  ),
                  const SizedBox(height: AppSizes.md),
                  buildClimateResilienceCard(
                    data: {'wind_speed': requirement.wind.speed},
                  ),
                  const SizedBox(height: AppSizes.lg),
                  _buildExpertGuidance(requirement, l10n),
                  const SizedBox(height: AppSizes.lg),
                  _buildVideoCard({
                    'title': l10n.aiClimateAnalysis,
                    'subtitle':
                        l10n.atmosphericAdaptationDesc(requirement.cropName),
                  }, l10n),
                  const SizedBox(height: AppSizes.md),
                ],
              ),
            );
          }
          return Center(child: Text(AppLocalizations.of(context)!.noDataFound));
        },
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.lg,
        AppSizes.lg,
        AppSizes.lg,
        AppSizes.md,
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.accentGreen,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primaryColor,
              fontSize: AppSizes.fontCaption,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTempSunlightCards(
    ClimaticRequirement requirement,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: AppSizes.xs),
              child: buildMetricCard(
                icon: Icons.thermostat_rounded,
                backgroundColor: AppColors.white,
                iconColor: Colors.orangeAccent,
                value: requirement.temperature.optimalGrowth,
                label: l10n.optimalTemp,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: AppSizes.xs),
              child: buildMetricCard(
                icon: Icons.wb_sunny_rounded,
                iconColor: Colors.amber,
                value: requirement.sunlight.requiresBrightSunshine,
                label: l10n.sunlightPath,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpertGuidance(
    ClimaticRequirement requirement,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(l10n.expertGuidance),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
          children: [
            _buildGuidanceItem(
              icon: Icons.auto_awesome_rounded,
              title: l10n.growthStrategy,
              description: requirement.rainfall.advice,
              gradient: [Colors.blue, Colors.blueAccent],
            ),
            const SizedBox(height: AppSizes.sm),
            _buildGuidanceItem(
              icon: Icons.tips_and_updates_rounded,
              title: l10n.photosynthesisOptimization,
              description: requirement.sunlight.description,
              gradient: [Colors.amber, Colors.orange],
            ),
            const SizedBox(height: AppSizes.sm),
            _buildGuidanceItem(
              icon: Icons.health_and_safety_rounded,
              title: l10n.moistureControl,
              description: requirement.humidity.maturity,
              gradient: [Colors.teal, Colors.greenAccent],
            ),
            const SizedBox(height: AppSizes.sm),
            _buildGuidanceItem(
              icon: Icons.warning_amber_rounded,
              title: l10n.temperatureRisks,
              description: requirement.temperature.nonOptimal,
              gradient: [Colors.redAccent, Colors.orangeAccent],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGuidanceItem({
    required IconData icon,
    required String title,
    required String description,
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.grey100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.xs),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  gradient[0].withValues(alpha: 0.1),
                  gradient[1].withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Icon(icon, color: gradient[0], size: AppSizes.iconMd),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.primaryColor.withValues(alpha: 0.7),
                    fontSize: AppSizes.fontBody,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(Map<String, dynamic> data, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: ActionCard(
        title: data['title'],
        subtitle: data['subtitle'],
        icon: AppIcons.videoLibrary,
        buttonText: l10n.watchVideo,
        onPressed: () {},
      ),
    );
  }
}
