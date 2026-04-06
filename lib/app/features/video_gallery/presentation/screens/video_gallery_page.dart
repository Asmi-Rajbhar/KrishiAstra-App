import 'package:krishiastra/app/core/l10n/app_localizations.dart';
import 'package:krishiastra/app/core/theme/app_sizes.dart';
import 'package:krishiastra/app/features/video_gallery/presentation/bloc/video_gallery_bloc.dart';
import 'package:krishiastra/app/core/bloc/language/language_bloc.dart';
import 'package:krishiastra/app/core/bloc/language/language_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krishiastra/app/core/theme/app_theme.dart';
import 'package:krishiastra/app/core/widgets/widgets.dart';
import 'package:krishiastra/app/features/video_gallery/presentation/widgets/video_gallery_widgets/video_card.dart';
import 'package:krishiastra/app/core/utils/app_icons.dart';

class VideoGalleryPage extends StatefulWidget {
  const VideoGalleryPage({super.key});

  @override
  State<VideoGalleryPage> createState() => _VideoGalleryPageState();
}

class _VideoGalleryPageState extends State<VideoGalleryPage> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<VideoGalleryBloc>().add(const FetchVideos());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        leadingIcon: AppIcons.arrowBackIosNew,
        titleText: AppLocalizations.of(context)!.videoGalleryTitle,
      ),
      body: BlocListener<LanguageBloc, LanguageState>(
        listener: (context, state) {
          if (state.status == LanguageStatus.ready) {
            context.read<VideoGalleryBloc>().add(const FetchVideos());
          }
        },
        child: _buildBody(context),
      ),
      bottomNavigationBar: const BottomNav(activeIndex: 1),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<VideoGalleryBloc, VideoGalleryState>(
      builder: (context, state) {
        if (state is VideoGalleryLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is VideoGalleryError) {
          return Center(
            child: Text(
              '${AppLocalizations.of(context)!.errorLabel} ${state.message}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        if (state is VideoGalleryLoaded) {
          final videos = state.videos;
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: AppSizes.lg),
            itemCount: videos.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildFilterHeader(videos.length);
              }

              final video = videos[index - 1];
              return VideoCard(video: video);
            },
            separatorBuilder: (context, index) =>
                SizedBox(height: index == 0 ? AppSizes.md : AppSizes.xl),
          );
        }
        return Center(child: Text(AppLocalizations.of(context)!.somethingWentWrong));
      },
    );
  }

  Widget _buildFilterHeader(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!_isSearching)
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.educationalVideosCount(count),
                    style: const TextStyle(
                      color: AppColors.greyShade,
                      fontSize: AppSizes.fontBody,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              if (_isSearching)
                Expanded(
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.only(right: AppSizes.md),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.searchVideosHint,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.md,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMax,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.white,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            context.read<VideoGalleryBloc>().add(
                              const FilterVideos(''),
                            );
                          },
                        ),
                      ),
                      onChanged: (value) {
                        context.read<VideoGalleryBloc>().add(
                          FilterVideos(value),
                        );
                      },
                    ),
                  ),
                ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (_isSearching) {
                        _searchFocusNode.unfocus();
                      }
                      setState(() {
                        _isSearching = !_isSearching;
                        if (!_isSearching) {
                          _searchController.clear();
                          context.read<VideoGalleryBloc>().add(
                            const FilterVideos(''),
                          );
                        }
                      });
                    },
                    icon: Icon(
                      _isSearching ? Icons.close : Icons.search,
                      color: AppColors.primaryColor,
                      size: AppSizes.iconMd,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _showFilterBottomSheet(context),
                    icon: const Icon(
                      AppIcons.tune,
                      size: AppSizes.iconSm,
                      color: AppColors.primaryColor,
                    ),
                    label: Text(
                      AppLocalizations.of(context)!.filter,
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    String? currentCategory;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSizes.radiusMax),
            ),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
            ],
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.xl,
            left: AppSizes.lg,
            right: AppSizes.lg,
            top: AppSizes.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSizes.lg),
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.filterCategories,
                    style: const TextStyle(
                      fontSize: AppSizes.fontHeading,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setModalState(() => currentCategory = null);
                      context.read<VideoGalleryBloc>().add(
                        FilterVideos(_searchController.text),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.reset,
                      style: const TextStyle(
                        color: AppColors.grey600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.lg),
              Text(
                AppLocalizations.of(context)!.filterCategoryDescription,
                style: const TextStyle(
                  fontSize: AppSizes.fontBody,
                  color: AppColors.grey600,
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              Wrap(
                spacing: AppSizes.sm,
                runSpacing: AppSizes.sm,
                children: [
                  _buildCategoryChip(
                    AppLocalizations.of(context)!.pest,
                    currentCategory == "Pest",
                    () {
                      setModalState(() => currentCategory = "Pest");
                      context.read<VideoGalleryBloc>().add(
                        FilterVideos(_searchController.text, category: "Pest"),
                      );
                    },
                  ),
                  _buildCategoryChip(
                    AppLocalizations.of(context)!.nutrient,
                    currentCategory == "Nutrient",
                    () {
                      setModalState(() => currentCategory = "Nutrient");
                      context.read<VideoGalleryBloc>().add(
                        FilterVideos(
                          _searchController.text,
                          category: "Nutrient",
                        ),
                      );
                    },
                  ),
                  _buildCategoryChip(
                    AppLocalizations.of(context)!.disease,
                    currentCategory == "Disease",
                    () {
                      setModalState(() => currentCategory = "Disease");
                      context.read<VideoGalleryBloc>().add(
                        FilterVideos(
                          _searchController.text,
                          category: "Disease",
                        ),
                      );
                    },
                  ),
                  _buildCategoryChip(
                    AppLocalizations.of(context)!.lifecycle,
                    currentCategory == "Lifecycle",
                    () {
                      setModalState(() => currentCategory = "Lifecycle");
                      context.read<VideoGalleryBloc>().add(
                        FilterVideos(
                          _searchController.text,
                          category: "Lifecycle",
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.xl * 1.5),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.applyFilters,
                    style: const TextStyle(
                      fontSize: AppSizes.fontTitle,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primaryColor.withValues(alpha: 0.2),
      checkmarkColor: AppColors.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primaryColor : AppColors.grey600,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: AppSizes.fontCaption,
      ),
      backgroundColor: AppColors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMax),
        side: BorderSide(
          color: isSelected ? AppColors.primaryColor : AppColors.grey300,
        ),
      ),
    );
  }
}
