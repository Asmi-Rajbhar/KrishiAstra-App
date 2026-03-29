import 'package:equatable/equatable.dart';

abstract class CropOverviewEvent extends Equatable {
  const CropOverviewEvent();

  @override
  List<Object> get props => [];
}

class FetchCropOverviewEvent extends CropOverviewEvent {
  final String cropName;

  const FetchCropOverviewEvent(this.cropName);

  @override
  List<Object> get props => [cropName];
}
