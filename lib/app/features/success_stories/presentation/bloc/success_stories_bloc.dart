import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:krishiastra/app/features/success_stories/domain/entities/story_detail.dart';
import 'package:krishiastra/app/features/success_stories/domain/repositories/i_success_story_repository.dart';
import 'package:krishiastra/app/core/utils/result.dart';

part 'success_stories_event.dart';
part 'success_stories_state.dart';

class SuccessStoriesBloc
    extends Bloc<SuccessStoriesEvent, SuccessStoriesState> {
  final ISuccessStoryRepository repository;
  List<StoryDetail> _allStories = [];

  SuccessStoriesBloc({required this.repository})
    : super(SuccessStoriesInitial()) {
    on<FetchSuccessStories>((event, emit) async {
      emit(SuccessStoriesLoading());
      final Result<List<StoryDetail>> result = await repository
          .getSuccessStories();
      if (result.isSuccess) {
        _allStories = result.data!;
        add(FilterSuccessStories(event.filter));
      } else {
        emit(SuccessStoriesError(result.failure?.message ?? 'Unknown error'));
      }
    });

    on<FilterSuccessStories>((event, emit) {
      final filteredStories = event.filter == 'All'
          ? _allStories
          : _allStories.where((s) {
              switch (event.filter) {
                case 'Pest':
                  return s.pest.isNotEmpty;
                case 'Disease':
                  return s.disease.isNotEmpty;
                case 'Nutrient':
                  return s.nutrient.isNotEmpty;
                default:
                  return true;
              }
            }).toList();
      emit(
        SuccessStoriesLoaded(
          stories: filteredStories,
          currentFilter: event.filter,
        ),
      );
    });

    on<FetchStoryDetail>((event, emit) async {
      emit(SuccessStoriesLoading());
      final result = await repository.getStoryDetail(event.title);
      if (result.isSuccess) {
        emit(StoryDetailLoaded(result.data!));
      } else {
        emit(SuccessStoriesError(result.failure?.message ?? 'Unknown error'));
      }
    });

    on<ReturnToList>((event, emit) {
      emit(SuccessStoriesLoaded(stories: _allStories));
    });
  }
}
