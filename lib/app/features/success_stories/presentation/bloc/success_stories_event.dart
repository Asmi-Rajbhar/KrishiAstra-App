part of 'success_stories_bloc.dart';

abstract class SuccessStoriesEvent extends Equatable {
  const SuccessStoriesEvent();

  @override
  List<Object?> get props => [];
}

class FetchSuccessStories extends SuccessStoriesEvent {
  final String filter;

  const FetchSuccessStories({this.filter = 'All'});

  @override
  List<Object?> get props => [filter];
}

class FilterSuccessStories extends SuccessStoriesEvent {
  final String filter;

  const FilterSuccessStories(this.filter);

  @override
  List<Object?> get props => [filter];
}

class FetchStoryDetail extends SuccessStoriesEvent {
  final String title;

  const FetchStoryDetail(this.title);

  @override
  List<Object?> get props => [title];
}

class ReturnToList extends SuccessStoriesEvent {
  const ReturnToList();

  @override
  List<Object?> get props => [];
}
