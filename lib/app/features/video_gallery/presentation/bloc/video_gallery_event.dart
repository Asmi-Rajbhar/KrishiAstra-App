part of 'video_gallery_bloc.dart';

abstract class VideoGalleryEvent extends Equatable {
  const VideoGalleryEvent();

  @override
  List<Object?> get props => [];
}

class FetchVideos extends VideoGalleryEvent {
  const FetchVideos();

  @override
  List<Object?> get props => [];
}

class FilterVideos extends VideoGalleryEvent {
  final String query;
  final String? category;
  const FilterVideos(this.query, {this.category});

  @override
  List<Object?> get props => [query, category];
}
