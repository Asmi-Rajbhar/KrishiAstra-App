import 'package:krishiastra/app/core/utils/result.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_variety_detail.dart';
import 'package:krishiastra/app/features/crop_variety/domain/repositories/i_crop_repository.dart';
import 'package:krishiastra/app/features/video_gallery/domain/entities/video.dart';
import 'package:krishiastra/app/features/video_gallery/domain/repositories/i_video_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'crop_variety_detail_event.dart';
import 'crop_variety_detail_state.dart';

class CropVarietyDetailBloc
    extends Bloc<CropVarietyDetailEvent, CropVarietyDetailState> {
  final ICropRepository _repository;
  final IVideoRepository _videoRepository;

  CropVarietyDetailBloc(this._repository, this._videoRepository)
    : super(CropVarietyDetailInitial()) {
    on<LoadCropVarietyDetail>(_onLoadCropVarietyDetail);
  }

  Future<void> _onLoadCropVarietyDetail(
    LoadCropVarietyDetail event,
    Emitter<CropVarietyDetailState> emit,
  ) async {
    emit(CropVarietyDetailLoading());
    final cropName = event.cropName;
    if (cropName == null) {
      emit(const CropVarietyDetailError('Crop name is required'));
      return;
    }

    try {
      final results = await Future.wait([
        _repository.getCropVarietyDetails(
          event.varietyName,
          season: event.season,
        ),
        _repository.getAvailableCropSeasons(cropName),
        _videoRepository.getVideos(),
      ]);

      final detailResult = results[0] as Result<CropVarietyDetail?>;
      final seasonsResult = results[1] as Result<List<String>>;
      final videosResult = results[2] as Result<List<Video>>;

      final detail = detailResult.data;
      final seasons = seasonsResult.data ?? [];
      final videos = videosResult.data ?? [];

      // Find a video matching variety name or a general lifecycle video
      Video? varietyVideo;
      if (videos.isNotEmpty) {
        varietyVideo = videos.firstWhere(
          (v) =>
              v.title.toLowerCase().contains(event.varietyName.toLowerCase()) ||
              v.description.toLowerCase().contains(
                event.varietyName.toLowerCase(),
              ),
          orElse: () => videos.firstWhere(
            (v) =>
                v.lifecycle != null && v.lifecycle!.isNotEmpty ||
                v.description.toLowerCase().contains('harvesting') ||
                v.title.toLowerCase().contains('management'),
            orElse: () => videos.first,
          ),
        );
      }

      if (detail != null) {
        emit(
          CropVarietyDetailLoaded(
            detail,
            availableSeasons: seasons,
            varietyVideo: varietyVideo,
          ),
        );
      } else {
        emit(const CropVarietyDetailError('Failed to load variety details'));
      }
    } catch (e) {
      emit(CropVarietyDetailError(e.toString()));
    }
  }
}
