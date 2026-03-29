part of 'success_stories_bloc.dart';

abstract class SuccessStoriesState extends Equatable {
  const SuccessStoriesState();

  @override
  List<Object?> get props => [];
}

class SuccessStoriesInitial extends SuccessStoriesState {}

class SuccessStoriesLoading extends SuccessStoriesState {}

class SuccessStoriesLoaded extends SuccessStoriesState {
  final List<StoryDetail> stories;
  final String currentFilter;

  const SuccessStoriesLoaded({
    required this.stories,
    this.currentFilter = 'All',
  });

  @override
  List<Object?> get props => [stories, currentFilter];
}

class SuccessStoriesError extends SuccessStoriesState {
  final String message;

  const SuccessStoriesError(this.message);

  @override
  List<Object?> get props => [message];
}

class StoryDetailLoaded extends SuccessStoriesState {
  final StoryDetail story;

  const StoryDetailLoaded(this.story);

  @override
  List<Object?> get props => [story];
}
