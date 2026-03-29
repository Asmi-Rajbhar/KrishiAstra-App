import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/features/success_stories/presentation/widgets/success_stories_widgets/story_card.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';
import 'package:krishiastra/app/core/widgets/navigation/app_bar.dart';
import 'package:krishiastra/app/core/widgets/navigation/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';

import 'package:krishiastra/app/features/success_stories/domain/entities/story_detail.dart';
import 'package:krishiastra/app/features/success_stories/presentation/bloc/success_stories_bloc.dart';
import 'package:krishiastra/app/core/bloc/language/language_bloc.dart';
import 'package:krishiastra/app/core/bloc/language/language_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuccessStoriesPage extends StatefulWidget {
  const SuccessStoriesPage({super.key});

  @override
  State<SuccessStoriesPage> createState() => _SuccessStoriesPageState();
}

class _SuccessStoriesPageState extends State<SuccessStoriesPage> {
  final List<String> _filters = ['All', 'Pest', 'Disease', 'Nutrient'];

  @override
  void initState() {
    super.initState();
    context.read<SuccessStoriesBloc>().add(const FetchSuccessStories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        titleText: AppLocalizations.of(context)!.successStories,
        leadingIcon: AppIcons.arrowBackIosNew,
      ),
      body: BlocListener<LanguageBloc, LanguageState>(
        listener: (context, state) {
          if (state.status == LanguageStatus.ready) {
            context.read<SuccessStoriesBloc>().add(const FetchSuccessStories());
          }
        },
        child: BlocBuilder<SuccessStoriesBloc, SuccessStoriesState>(
          builder: (context, state) {
            if (state is SuccessStoriesLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.accentGreen),
              );
            }
            if (state is SuccessStoriesError) {
              return Center(
                child: Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            if (state is SuccessStoriesLoaded) {
              return Column(
                children: [
                  _buildFilterChips(state.currentFilter),
                  Expanded(child: _buildBody(state.stories)),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      bottomNavigationBar: const BottomNav(activeIndex: 2),
    );
  }

  Widget _buildBody(List<StoryDetail> stories) {
    if (stories.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noStoriesFound));
    }

    return ListView.builder(
      padding: const EdgeInsets.only(
        left: AppSizes.md,
        right: AppSizes.md,
        top: AppSizes.md,
        bottom: AppSizes.xl * 2,
      ),
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.md),
          child: StoryCard(story: story),
        );
      },
    );
  }

  Widget _buildFilterChips(String currentFilter) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = currentFilter == filter;

          return Container(
            margin: EdgeInsets.only(
              right: index < _filters.length - 1 ? AppSizes.sm : 0,
            ),
            child: FilterChip(
              label: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? AppColors.white : AppColors.primaryColor,
                  fontSize: AppSizes.fontBody,
                  fontWeight: FontWeight.w500,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                context.read<SuccessStoriesBloc>().add(
                  FilterSuccessStories(filter),
                );
              },
              backgroundColor: AppColors.white,
              selectedColor: AppColors.accentGreen,
              side: BorderSide(
                color: isSelected ? AppColors.accentGreen : AppColors.grey200,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.sm,
                vertical: AppSizes.xs,
              ),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }
}
