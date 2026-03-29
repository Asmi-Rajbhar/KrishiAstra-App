import 'package:equatable/equatable.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_basic_details.dart';

abstract class CropOverviewState extends Equatable {
  const CropOverviewState();

  @override
  List<Object?> get props => [];
}

class CropOverviewInitial extends CropOverviewState {}

class CropOverviewLoading extends CropOverviewState {}

class CropOverviewLoaded extends CropOverviewState {
  final CropBasicDetails details;

  const CropOverviewLoaded(this.details);

  @override
  List<Object?> get props => [details];
}

class CropOverviewError extends CropOverviewState {
  final String message;

  const CropOverviewError(this.message);

  @override
  List<Object?> get props => [message];
}
