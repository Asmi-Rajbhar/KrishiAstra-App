import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:krishiastra/app/features/lifecycle_management/presentation/bloc/lifecycle_management_bloc.dart';
import 'package:krishiastra/app/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/navigation/app_router.dart';
import 'package:krishiastra/app/features/lifecycle_management/presentation/widgets/lifecycle_widgets/lifecycle_card.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';
import 'package:krishiastra/app/features/lifecycle_management/domain/entities/stage_status.dart';

import 'package:krishiastra/app/features/crop_variety/presentation/providers/crop_provider.dart';

class CropLifecyclePage extends StatefulWidget {
  const CropLifecyclePage({super.key});

  @override
  State<CropLifecyclePage> createState() => _CropLifecyclePageState();
}

class _CropLifecyclePageState extends State<CropLifecyclePage> {
  @override
  void initState() {
    super.initState();
    final cropProvider = context.read<CropProvider>();
    final variety = cropProvider.selectedVariety;
    final cropName = cropProvider.cropInfo?.name;

    if (variety != null) {
      context.read<LifecycleManagementBloc>().add(
        InitializeLifecycleData(
          variety: variety.name,
          season: cropProvider.selectedSeason ?? variety.season,
          cropName: cropName,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        leadingIcon: AppIcons.arrowBackIosNew,
        titleText: AppLocalizations.of(context)!.cropLifecycle,
      ),
      body: BlocBuilder<LifecycleManagementBloc, LifecycleManagementState>(
        builder: (context, state) {
          if (state.isLoading && state.lifecycleStages.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null && state.lifecycleStages.isEmpty) {
            return Center(
              child: Text(
                "${AppLocalizations.of(context)!.errorLabel} ${state.errorMessage}",
              ),
            );
          }

          return Column(
            children: [
              if (state.isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state.lifecycleStages.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(AppLocalizations.of(context)!.noDataAvailable),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                      left: screenWidth * 0.06,
                      right: screenWidth * 0.06,
                      top: screenHeight * 0.04,
                      bottom: screenHeight * 0.12,
                    ),
                    itemCount: state.lifecycleStages.length,
                    itemBuilder: (context, index) {
                      final stage = state.lifecycleStages[index];

                      // User requested Stage 6 (index 5) as current
                      StageStatus status;
                      if (index < 5) {
                        status = StageStatus.completed;
                      } else if (index == 5) {
                        status = StageStatus.current;
                      } else {
                        status = StageStatus.upcoming;
                      }

                      return LifecycleStageCard(
                        stageNumber: (index + 1).toString().padLeft(2, '0'),
                        icon: AppIcons.science, // Placeholder icon
                        title: stage.stageName,
                        description: stage.whatToDo.isNotEmpty
                            ? stage.whatToDo.first
                            : AppLocalizations.of(context)!.viewDetails,
                        status: status,
                        isLast: index == state.lifecycleStages.length - 1,
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
                    },
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}
