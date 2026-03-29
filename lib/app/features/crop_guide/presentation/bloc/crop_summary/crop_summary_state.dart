import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_basic_details.dart';
import 'package:equatable/equatable.dart';

abstract class CropSummaryState extends Equatable {
  const CropSummaryState();

  @override
  List<Object?> get props => [];
}

class CropSummaryInitial extends CropSummaryState {}

class CropSummaryLoading extends CropSummaryState {}

class CropSummaryLoaded extends CropSummaryState {
  final CropBasicDetails details;

  const CropSummaryLoaded(this.details);

  @override
  List<Object?> get props => [details];
}

class CropSummaryError extends CropSummaryState {
  final String message;

  const CropSummaryError(this.message);

  @override
  List<Object?> get props => [message];
}
