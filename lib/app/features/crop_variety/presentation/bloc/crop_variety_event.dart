part of 'crop_variety_bloc.dart';

abstract class CropVarietyEvent extends Equatable {
  const CropVarietyEvent();

  @override
  List<Object?> get props => [];
}

class FetchCropVarieties extends CropVarietyEvent {
  final String? season;
  final String? cropName;
  const FetchCropVarieties({this.season, this.cropName});

  @override
  List<Object?> get props => [season, cropName];
}
