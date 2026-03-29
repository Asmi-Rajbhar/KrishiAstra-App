import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_info.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_requirement.dart';
import 'package:krishiastra/app/features/crop_variety/domain/repositories/i_crop_repository.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/bloc/crop_requirements/crop_requirements_bloc.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/bloc/crop_requirements/crop_requirements_event.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/bloc/crop_requirements/crop_requirements_state.dart';
import 'package:flutter/material.dart';
import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CropRequirementsPage extends StatefulWidget {
  final CropInfo cropInfo;

  const CropRequirementsPage({super.key, required this.cropInfo});

  @override
  State<CropRequirementsPage> createState() => _CropRequirementsPageState();
}

class _CropRequirementsPageState extends State<CropRequirementsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CropRequirementsBloc(repository: context.read<ICropRepository>())
            ..add(FetchCropRequirementsEvent(widget.cropInfo.cropName)),
      child: BlocBuilder<CropRequirementsBloc, CropRequirementsState>(
        builder: (context, state) {
          if (state is CropRequirementsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          } else if (state is CropRequirementsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: AppSizes.iconXl * 1.5,
                    ),
                    const SizedBox(height: AppSizes.md),
                    Text(
                      "${AppLocalizations.of(context)!.errorLabel} ${state.message}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.error),
                    ),
                    const SizedBox(height: AppSizes.md),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CropRequirementsBloc>().add(
                          FetchCropRequirementsEvent(widget.cropInfo.cropName),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.retry),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is CropRequirementsLoaded) {
            return _buildContent(context, state.data);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, CropRequirement data) {
    // Process soil types
    final soilLines = data.soilType.split('\n\n');
    final soilDetails = <RequirementDetail>[];
    for (var line in soilLines) {
      if (line.trim().isEmpty) continue;

      String displayValue = line.trim();
      String displaySubtitle = 'Preferred soil conditions';

      // Try to split by en-dash (\u2013) or hyphen
      if (line.contains(' \u2013 ')) {
        final parts = line.split(' \u2013 ');
        displayValue = parts[0].trim();
        displaySubtitle = parts[1].trim();
      } else if (line.contains(' - ')) {
        final parts = line.split(' - ');
        displayValue = parts[0].trim();
        displaySubtitle = parts[1].trim();
      }
      soilDetails.add(
        RequirementDetail(value: displayValue, subtitle: displaySubtitle),
      );
    }

    // Process seasons
    final seasonDetails = data.cropSeason.map((season) {
      return RequirementDetail(
        value: season,
        subtitle: data.rainfall.rainfallAdvice,
      );
    }).toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.lg,
          AppSizes.xl,
          AppSizes.lg,
          AppSizes.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Requirements:',
              style: TextStyle(
                fontSize: AppSizes.fontHero,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            Text(
              data.cropName,
              style: const TextStyle(
                fontSize: AppSizes.fontHeading,
                fontWeight: FontWeight.w600,
                color: AppColors.accentGreen,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            const Text(
              'Can you grow it?',
              style: TextStyle(
                fontSize: AppSizes.fontTitle,
                fontWeight: FontWeight.w600,
                color: AppColors.accentGreen,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            const Text(
              'Check if your environment meets the essential needs for high-yield crop.',
              style: TextStyle(
                fontSize: AppSizes.fontBody,
                color: AppColors.grey500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSizes.lg),

            // // Cultivation Insights card
            // GestureDetector(
            //   onTap: () {
            //     setState(() {
            //       _isCultivationExpanded = !_isCultivationExpanded;
            //     });
            //   },
            //   child: Container(
            //     width: double.infinity,
            //     padding: const EdgeInsets.all(20),
            //     decoration: BoxDecoration(
            //       color: AppColors.white,
            //       borderRadius: BorderRadius.circular(20),
            //       boxShadow: [
            //         BoxShadow(
            //           color: AppColors.black.withValues(alpha: 0.06),
            //           blurRadius: 12,
            //           offset: const Offset(0, 4),
            //         ),
            //       ],
            //     ),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         const Text(
            //           'Cultivation Insights',
            //           style: TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.bold,
            //             color: AppColors.primaryColor,
            //           ),
            //         ),
            //         const SizedBox(height: 8),
            //         Text(
            //           '${data.cropName} thrives in specific conditions. ${data.waterIntensive}',
            //           maxLines: _isCultivationExpanded ? null : 3,
            //           overflow: _isCultivationExpanded
            //               ? TextOverflow.visible
            //               : TextOverflow.ellipsis,
            //           style: const TextStyle(
            //             fontSize: 13,
            //             color: AppColors.greyShade,
            //             height: 1.5,
            //           ),
            //         ),
            //         if (!_isCultivationExpanded &&
            //             data.waterIntensive.length > 80)
            //           const Padding(
            //             padding: EdgeInsets.only(top: 4.0),
            //             child: Text(
            //               'Read more...',
            //               style: TextStyle(
            //                 color: AppColors.primaryColor,
            //                 fontWeight: FontWeight.bold,
            //                 fontSize: 12,
            //               ),
            //             ),
            //           ),
            //         const SizedBox(height: 16),
            //         // Soil image placeholder
            //         ClipRRect(
            //           borderRadius: BorderRadius.circular(12),
            //           child: Container(
            //             height: 140,
            //             width: double.infinity,
            //             color: AppColors.green100,
            //             child: Stack(
            //               children: [
            //                 Image.network(
            //                   widget.cropInfo.imageUrl,
            //                   fit: BoxFit.cover,
            //                   width: double.infinity,
            //                   height: 140,
            //                   errorBuilder: (context, error, stackTrace) =>
            //                       Container(
            //                         color: AppColors.green100,
            //                         child: const Center(
            //                           child: Icon(
            //                             Icons.landscape,
            //                             size: 48,
            //                             color: AppColors.accentGreen,
            //                           ),
            //                         ),
            //                       ),
            //                 ),
            //                 Positioned(
            //                   bottom: 0,
            //                   left: 0,
            //                   right: 0,
            //                   child: Container(
            //                     padding: const EdgeInsets.all(10),
            //                     decoration: BoxDecoration(
            //                       gradient: LinearGradient(
            //                         begin: Alignment.topCenter,
            //                         end: Alignment.bottomCenter,
            //                         colors: [
            //                           AppColors.transparent,
            //                           AppColors.black.withValues(alpha: 0.55),
            //                         ],
            //                       ),
            //                     ),
            //                     child: const Text(
            //                       'Healthy field ready for cultivation.',
            //                       style: TextStyle(
            //                         color: AppColors.white,
            //                         fontSize: 11,
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 20),

            // Requirements grid
            _buildMultiRequirementItem(
              icon: Icons.landscape_outlined,
              label: 'Soil Type',
              details: soilDetails,
              color: AppColors.accentGreen,
            ),
            const SizedBox(height: 12),
            _buildRequirementItem(
              icon: Icons.water_drop_outlined,
              label: 'Rainfall',
              value: data.rainfall.annualRequirement,
              subtitle: data.rainfall.rainfallDescription,
              color: AppColors.blueShade,
            ),
            const SizedBox(height: 12),
            _buildMultiRequirementItem(
              icon: Icons.wb_sunny_outlined,
              label: 'Ideal Season',
              details: seasonDetails,
              color: AppColors.orangeShade,
            ),
            const SizedBox(height: 12),
            _buildRequirementItem(
              icon: Icons.schedule_outlined,
              label: 'Crop Duration',
              value: '${data.maturityTime} Months',
              subtitle: 'From planting to harvest',
              color: AppColors.primaryColor,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementItem({
    required IconData icon,
    required String label,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return _buildMultiRequirementItem(
      icon: icon,
      label: label,
      details: [RequirementDetail(value: value, subtitle: subtitle)],
      color: color,
    );
  }

  Widget _buildMultiRequirementItem({
    required IconData icon,
    required String label,
    required List<RequirementDetail> details,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.greyShade.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 2),
                ...List.generate(details.length, (index) {
                  final detail = details[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index > 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(
                            height: 1,
                            color: AppColors.greyShade.withValues(alpha: 0.1),
                          ),
                        ),
                      Text(
                        detail.value,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Text(
                        detail.subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.greyShade,
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Icon(
              Icons.check_circle,
              color: AppColors.neonGreen,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class RequirementDetail {
  final String value;
  final String subtitle;

  RequirementDetail({required this.value, required this.subtitle});
}
