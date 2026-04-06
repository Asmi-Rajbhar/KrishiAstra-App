import 'package:equatable/equatable.dart';

abstract class CropVarietyDetailEvent extends Equatable {
  const CropVarietyDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadCropVarietyDetail extends CropVarietyDetailEvent {
  final String varietyName;
  final String? season;
  final String? cropName;
  const LoadCropVarietyDetail(this.varietyName, {this.season, this.cropName});

  @override
  List<Object?> get props => [varietyName, season, cropName];
}
