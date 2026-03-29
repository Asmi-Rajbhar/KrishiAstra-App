part of 'video_gallery_bloc.dart';

abstract class VideoGalleryState extends Equatable {
  const VideoGalleryState();

  @override
  List<Object> get props => [];
}

class VideoGalleryInitial extends VideoGalleryState {}

class VideoGalleryLoading extends VideoGalleryState {}

class VideoGalleryLoaded extends VideoGalleryState {
  final List<Video> videos;

  const VideoGalleryLoaded(this.videos);

  @override
  List<Object> get props => [videos];
}

class VideoGalleryError extends VideoGalleryState {
  final String message;

  const VideoGalleryError(this.message);

  @override
  List<Object> get props => [message];
}
