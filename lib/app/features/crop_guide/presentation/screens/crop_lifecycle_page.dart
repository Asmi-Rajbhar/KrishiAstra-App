import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:krishiastra/app/core/navigation/app_router.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_info.dart';
import 'package:krishiastra/app/features/lifecycle_management/domain/entities/stage_status.dart';
import 'package:krishiastra/app/features/lifecycle_management/presentation/bloc/lifecycle_management_bloc.dart';
import 'package:krishiastra/app/features/lifecycle_management/presentation/widgets/lifecycle_widgets/lifecycle_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CropLifecyclePage extends StatefulWidget {
  final CropInfo cropInfo;

  const CropLifecyclePage({super.key, required this.cropInfo});

  @override
  State<CropLifecyclePage> createState() => _CropLifecyclePageState();
}

class _CropLifecyclePageState extends State<CropLifecyclePage> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    final cropName = widget.cropInfo.cropName;
    context.read<LifecycleManagementBloc>().add(
      FetchCropLifecycleStagesEvent(cropName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LifecycleManagementBloc, LifecycleManagementState>(
      builder: (context, state) {
        if (state.isLoading && state.lifecycleStages.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.accentGreen),
          );
        }

        if (state.errorMessage != null && state.lifecycleStages.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: AppSizes.iconXl * 1.5,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: AppSizes.md),
                  Text(
                    "${AppLocalizations.of(context)!.errorLabel} ${state.errorMessage}",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.md),
                  ElevatedButton(
                    onPressed: _fetchData,
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            ),
          );
        }

        final stages = state.lifecycleStages;

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.lg,
                  AppSizes.xl * 1.5,
                  AppSizes.lg,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.cropLifecycle}:',
                      style: const TextStyle(
                        fontSize: AppSizes.fontHeading,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Text(
                      widget.cropInfo.cropName,
                      style: const TextStyle(
                        fontSize: AppSizes.fontTitle,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentGreen,
                      ),
                    ),
                    const SizedBox(height: AppSizes.xxs),
                    const Text(
                      'A detailed timeline for farmers and students.',
                      style: TextStyle(
                        fontSize: AppSizes.fontBody,
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Timeline list
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: Column(
                    children: [
                      if (stages.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Text(
                              AppLocalizations.of(context)!.noDataAvailable,
                              style: const TextStyle(
                                color: AppColors.greyShade,
                              ),
                            ),
                          ),
                        )
                      else
                        ...stages.asMap().entries.map((entry) {
                          final index = entry.key;
                          final stage = entry.value;

                          // Logic for status (can be improved by connecting to real user progress)
                          StageStatus status;
                          if (index < 1) {
                            status = StageStatus.completed;
                          } else if (index == 1) {
                            status = StageStatus.current;
                          } else {
                            status = StageStatus.upcoming;
                          }

                          return LifecycleStageCard(
                            stageNumber: (index + 1).toString().padLeft(2, '0'),
                            icon: AppIcons.science,
                            title: stage.stageName,
                            description: stage.whatToDo.isNotEmpty
                                ? stage.whatToDo.first
                                : 'Check details for more info.',
                            status: status,
                            isLast: index == stages.length - 1,
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRouter.stageGuidance,
                                arguments: {
                                  'stage': stage,
                                  'stageNumber': (index + 1).toString().padLeft(
                                    2,
                                    '0',
                                  ),
                                },
                              );
                            },
                          );
                        }),
                      const SizedBox(height: 16),

                      // Expert Tip card (only if we have stages)
                      if (stages.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.green100.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.neonGreen.withValues(alpha: 0.4),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.neonGreen.withValues(
                                    alpha: 0.15,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.lightbulb_outline,
                                  color: AppColors.accentGreen,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Expert Tip',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      state.lifecycleStages.length > 2
                                          ? "During the '${state.lifecycleStages[1].stageName}' phase, ensure consistent irrigation and check for pests twice a week."
                                          : "Ensure consistent crop care and check for pest infestation twice a week.",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.greyShade,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
