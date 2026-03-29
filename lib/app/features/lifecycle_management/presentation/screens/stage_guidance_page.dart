import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/features/lifecycle_management/presentation/bloc/stage_bloc.dart';
import 'package:krishiastra/app/features/lifecycle_management/domain/entities/crop_lifecycle_stage.dart';
import 'package:krishiastra/app/features/lifecycle_management/domain/entities/checklist_item.dart';
import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:krishiastra/app/core/navigation/app_router.dart';
import 'package:krishiastra/app/core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/widgets/widgets.dart';
import 'package:krishiastra/app/features/lifecycle_management/presentation/widgets/stage_guidance_widgets/checklist_card.dart';
import 'package:krishiastra/app/core/widgets/cards/cost_benefit_card.dart';
import 'package:krishiastra/app/features/lifecycle_management/presentation/widgets/stage_guidance_widgets/media_item.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';

class StageGuidancePage extends StatefulWidget {
  final CropLifecycleStage stage;
  final String stageNumber;

  const StageGuidancePage({
    super.key,
    required this.stage,
    required this.stageNumber,
  });

  @override
  State<StageGuidancePage> createState() => StageGuidancePageState();
}

class StageGuidancePageState extends State<StageGuidancePage> {
  late AppLocalizations l10n;
  @override
  void initState() {
    super.initState();
    final checklist = widget.stage.timeBoundChecklist
        .map(
          (task) => ChecklistItem(
            title: task.taskTitle,
            subtitle: task.taskDescription,
          ),
        )
        .toList();

    context.read<StageBloc>().add(LoadChecklistDirectly(checklist));
  }

  @override
  Widget build(BuildContext context) {
    l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        leadingIcon: AppIcons.arrowBackIosNew,
        titleText: l10n.stageGuidanceTitle(widget.stageNumber),
      ),
      body: BlocBuilder<StageBloc, StageState>(
        builder: (context, state) {
          if (state is StageLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is StageError) {
            return Center(
              child: Text(
                "${AppLocalizations.of(context)!.errorLabel} ${state.message}",
              ),
            );
          }
          if (state is StageLoaded) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                    ),
                    child: HeroCard.single(
                      imageUrl: AppImages.stageGuidanceHero,
                      title: widget.stage.stageName,
                      badgeText: l10n.durationDays("7-14"),
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),
                  InfoSection.list(
                    context: context,
                    title: AppLocalizations.of(context)!.whatToDo,
                    icon: AppIcons.checkCircle,
                    items: widget.stage.whatToDo
                        .map(
                          (item) =>
                              InfoItem(icon: AppIcons.doneAll, content: item),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: AppSizes.md),
                  InfoSection.list(
                    context: context,
                    title: AppLocalizations.of(context)!.whatToAvoid,
                    icon: AppIcons.cancel,
                    items: widget.stage.whatToAvoid
                        .map(
                          (item) => InfoItem(
                            icon: AppIcons.close,
                            iconColor: AppColors.redShade,
                            content: item,
                          ),
                        )
                        .toList(),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                    padding: const EdgeInsets.all(AppSizes.lg),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withValues(alpha: 0.3),
                          blurRadius: AppSizes.md,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              AppIcons.schedule,
                              color: AppColors.white,
                              size: AppSizes.iconMd,
                            ),
                            const SizedBox(width: AppSizes.sm),
                            Text(
                              l10n.timeBoundChecklist,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: AppSizes.fontTitle,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.lg),
                        for (int i = 0; i < state.checklist.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: AppSizes.sm),
                            child: ChecklistCard(
                              title: state.checklist[i].title,
                              subtitle: state.checklist[i].subtitle,
                              isCompleted: state.checklist[i].isCompleted,
                              isReminderActive:
                                  state.checklist[i].isReminderActive,
                              onToggleCompletion: (value) => context
                                  .read<StageBloc>()
                                  .add(ToggleCompletion(i, value)),
                              onToggleReminder: () => context
                                  .read<StageBloc>()
                                  .add(ToggleReminder(i)),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),
                  const CostBenefitCard(
                    cost: '\$45',
                    costUnit: '/acre',
                    benefit: '+12%',
                  ),
                  const SizedBox(height: AppSizes.md),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.videosgallery,
                              style: const TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: AppSizes.fontHeading,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRouter.videoGallery,
                                );
                              },
                              child: Text(
                                l10n.seeAll,
                                style: const TextStyle(
                                  color: AppColors.accentGreen,
                                  fontSize: AppSizes.fontBody,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.xs),
                        SizedBox(
                          height: 160,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              SizedBox(
                                width: 180,
                                child: MediaItem(
                                  isVideo: true,
                                  duration: '4:20',
                                  title: l10n.soilPreparationTips,
                                ),
                              ),
                              const SizedBox(width: AppSizes.md),
                              SizedBox(
                                width: 180,
                                child: MediaItem(
                                  isVideo: true,
                                  duration: "8:20",
                                  title: l10n.growthProgressSamples,
                                ),
                              ),
                              const SizedBox(width: AppSizes.md),
                              SizedBox(
                                width: 180,
                                child: MediaItem(
                                  isVideo: true,
                                  duration: "8:40",
                                  title: l10n.soilProgressSamples,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.xl),
                ],
              ),
            );
          }
          return Center(
            child: Text(AppLocalizations.of(context)!.somethingWentWrong),
          );
        },
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}
