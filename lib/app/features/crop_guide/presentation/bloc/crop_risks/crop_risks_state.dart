import 'package:equatable/equatable.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_risk_and_care.dart';

abstract class CropRisksState extends Equatable {
  const CropRisksState();

  @override
  List<Object?> get props => [];
}

class CropRisksInitial extends CropRisksState {}

class CropRisksLoading extends CropRisksState {}

class CropRisksLoaded extends CropRisksState {
  final CropRiskAndCare data;

  const CropRisksLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class CropRisksError extends CropRisksState {
  final String message;

  const CropRisksError(this.message);

  @override
  List<Object?> get props => [message];
}
