import 'package:equatable/equatable.dart';

abstract class CropRisksEvent extends Equatable {
  const CropRisksEvent();

  @override
  List<Object> get props => [];
}

class FetchCropRisksEvent extends CropRisksEvent {
  final String cropName;

  const FetchCropRisksEvent(this.cropName);

  @override
  List<Object> get props => [cropName];
}
