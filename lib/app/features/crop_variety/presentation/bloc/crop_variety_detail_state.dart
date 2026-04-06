import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_variety_detail.dart';
import 'package:krishiastra/app/features/video_gallery/domain/entities/video.dart';
import 'package:equatable/equatable.dart';

abstract class CropVarietyDetailState extends Equatable {
  const CropVarietyDetailState();

  @override
  List<Object?> get props => [];
}

class CropVarietyDetailInitial extends CropVarietyDetailState {}

class CropVarietyDetailLoading extends CropVarietyDetailState {}

class CropVarietyDetailLoaded extends CropVarietyDetailState {
  final CropVarietyDetail detail;
  final List<String> availableSeasons;
  final Video? varietyVideo;

  const CropVarietyDetailLoaded(
    this.detail, {
    this.availableSeasons = const [],
    this.varietyVideo,
  });

  @override
  List<Object?> get props => [detail, availableSeasons, varietyVideo];
}

class CropVarietyDetailError extends CropVarietyDetailState {
  final String message;
  const CropVarietyDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
