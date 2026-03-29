import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_info.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_basic_details.dart';
import 'package:krishiastra/app/features/crop_variety/domain/repositories/i_crop_repository.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/bloc/crop_overview/crop_overview_bloc.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/bloc/crop_overview/crop_overview_event.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/bloc/crop_overview/crop_overview_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CropOverviewPage extends StatefulWidget {
  final CropInfo cropInfo;

  const CropOverviewPage({super.key, required this.cropInfo});

  @override
  State<CropOverviewPage> createState() => _CropOverviewPageState();
}

class _CropOverviewPageState extends State<CropOverviewPage> {
  bool _isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CropOverviewBloc(repository: context.read<ICropRepository>())
            ..add(FetchCropOverviewEvent(widget.cropInfo.cropName)),
      child: BlocBuilder<CropOverviewBloc, CropOverviewState>(
        builder: (context, state) {
          if (state is CropOverviewLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          } else if (state is CropOverviewError) {
            return Center(
              child: Text(
                'Failed to load details: ${state.message}',
                style: const TextStyle(color: AppColors.error),
              ),
            );
          } else if (state is CropOverviewLoaded) {
            return _buildContent(context, state.details);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, CropBasicDetails details) {
    return Stack(
      children: [
        // Solid Content at the bottom
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppSizes.xl),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // "Crop Overview" label
                    Text(
                      'Crop Overview',
                      style: TextStyle(
                        color: AppColors.primaryColor.withValues(alpha: 0.7),
                        fontSize: AppSizes.fontCaption,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: AppSizes.xs),

                    // Crop name
                    Text(
                      details.cropName.isNotEmpty
                          ? details.cropName
                          : widget.cropInfo.cropName,
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: AppSizes.fontHero * 1.3,
                        fontWeight: FontWeight.bold,
                        height: 1.05,
                      ),
                    ),

                    // Scientific name
                    Text(
                      widget.cropInfo.scientificName,
                      style: TextStyle(
                        color: AppColors.primaryColor.withValues(alpha: 0.7),
                        fontSize: AppSizes.fontContent,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: AppSizes.md),

                    // "High Yield" badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.md,
                        vertical: AppSizes.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(AppSizes.radiusMax),
                      ),
                      child: const Text(
                        'High Yield',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.fontCaption,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.md),

                    // Description with Expandable Text
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isDescriptionExpanded = !_isDescriptionExpanded;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            details.description,
                            maxLines: _isDescriptionExpanded ? null : 3,
                            overflow: _isDescriptionExpanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.primaryColor.withValues(
                                alpha: 0.85,
                              ),
                              fontSize: AppSizes.fontContent,
                              height: 1.5,
                            ),
                          ),
                          if (!_isDescriptionExpanded &&
                              details.description.length > 100)
                            const Padding(
                              padding: EdgeInsets.only(top: AppSizes.xs),
                              child: Text(
                                'Read more...',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppSizes.fontCaption,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),

                    // Stats row: Duration & Revenue
                    Row(
                      children: [
                        Expanded(
                          child: _buildOverviewStat(
                            icon: Icons.schedule_outlined,
                            label: 'Duration',
                            value: '${details.maturityTime} Months',
                            bgColor: AppColors.info.withValues(alpha: 0.1),
                            iconColor: AppColors.info,
                          ),
                        ),
                        const SizedBox(width: AppSizes.md),
                        Expanded(
                          child: _buildOverviewStat(
                            icon: Icons.currency_rupee,
                            label: 'Revenue',
                            value: '₹${details.revenue} L',
                            bgColor: AppColors.success.withValues(alpha: 0.1),
                            iconColor: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.md),

                    // Feature cards row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildFeatureCard(
                            icon: Icons.water_drop_outlined,
                            title: 'Water Intensive',
                            description: details.waterIntensive,
                            bgColor: AppColors.info.withValues(alpha: 0.1),
                            iconColor: AppColors.info,
                          ),
                        ),
                        const SizedBox(width: AppSizes.md),
                        Expanded(
                          child: _buildFeatureCard(
                            icon: Icons.wb_sunny_outlined,
                            title: 'Climate Needs',
                            description: details.climateNeeds,
                            bgColor: AppColors.warning.withValues(alpha: 0.1),
                            iconColor: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewStat({
    required IconData icon,
    required String label,
    required String value,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: bgColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.xs),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm + 2),
            ),
            child: Icon(icon, color: iconColor, size: AppSizes.iconMd),
          ),
          const SizedBox(width: AppSizes.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: AppSizes.fontContent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.primaryColor.withValues(alpha: 0.7),
                  fontSize: AppSizes.fontCaption,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: bgColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: AppSizes.iconMd + 2),
          const SizedBox(height: AppSizes.sm),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primaryColor,
              fontSize: AppSizes.fontCaption + 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.primaryColor.withValues(alpha: 0.7),
              fontSize: AppSizes.fontCaption,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
