import 'package:equatable/equatable.dart';

abstract class CropRequirementsEvent extends Equatable {
  const CropRequirementsEvent();

  @override
  List<Object> get props => [];
}

class FetchCropRequirementsEvent extends CropRequirementsEvent {
  final String cropName;

  const FetchCropRequirementsEvent(this.cropName);

  @override
  List<Object> get props => [cropName];
}
