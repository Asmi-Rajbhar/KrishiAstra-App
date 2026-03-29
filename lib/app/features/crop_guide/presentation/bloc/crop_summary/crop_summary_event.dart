import 'package:equatable/equatable.dart';

abstract class CropSummaryEvent extends Equatable {
  const CropSummaryEvent();

  @override
  List<Object> get props => [];
}

class FetchCropSummaryEvent extends CropSummaryEvent {
  final String cropName;

  const FetchCropSummaryEvent(this.cropName);

  @override
  List<Object> get props => [cropName];
}
