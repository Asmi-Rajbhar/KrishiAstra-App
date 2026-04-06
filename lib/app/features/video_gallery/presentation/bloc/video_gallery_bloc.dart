import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:krishiastra/app/features/video_gallery/domain/entities/video.dart';
import 'package:krishiastra/app/features/video_gallery/domain/repositories/i_video_repository.dart';
import 'package:krishiastra/app/core/utils/result.dart';

part 'video_gallery_event.dart';
part 'video_gallery_state.dart';

class VideoGalleryBloc extends Bloc<VideoGalleryEvent, VideoGalleryState> {
  final IVideoRepository videoRepository;
  List<Video> _allVideos = [];

  VideoGalleryBloc({required this.videoRepository})
    : super(VideoGalleryInitial()) {
    on<FetchVideos>((event, emit) async {
      emit(VideoGalleryLoading());
      final Result<List<Video>> result = await videoRepository.getVideos();
      if (result.isSuccess) {
        _allVideos = result.data!;
        emit(VideoGalleryLoaded(_allVideos));
      } else {
        emit(VideoGalleryError(result.failure?.message ?? 'Unknown error'));
      }
    });

    on<FilterVideos>((event, emit) {
      if (event.query.isEmpty && event.category == null) {
        emit(VideoGalleryLoaded(_allVideos));
      } else {
        final filtered = _allVideos.where((video) {
          bool matchesQuery = true;
          if (event.query.isNotEmpty) {
            final query = event.query.toLowerCase();
            matchesQuery =
                video.title.toLowerCase().contains(query) ||
                video.description.toLowerCase().contains(query);
          }

          bool matchesCategory = true;
          if (event.category != null) {
            final cat = event.category!.toLowerCase();
            if (cat == 'pest') {
              matchesCategory = video.pest != null && video.pest!.isNotEmpty;
            } else if (cat == 'nutrient') {
              matchesCategory =
                  video.nutrient != null && video.nutrient!.isNotEmpty;
            } else if (cat == 'disease') {
              matchesCategory =
                  video.disease != null && video.disease!.isNotEmpty;
            } else if (cat == 'lifecycle') {
              matchesCategory =
                  video.lifecycle != null && video.lifecycle!.isNotEmpty;
            }
          }

          return matchesQuery && matchesCategory;
        }).toList();
        emit(VideoGalleryLoaded(filtered));
      }
    });
  }
}
