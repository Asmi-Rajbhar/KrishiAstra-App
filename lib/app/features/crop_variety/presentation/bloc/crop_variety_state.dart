part of 'crop_variety_bloc.dart';

abstract class CropVarietyState extends Equatable {
  const CropVarietyState();

  @override
  List<Object> get props => [];
}

class CropVarietyInitial extends CropVarietyState {}

class CropVarietyLoading extends CropVarietyState {}

class CropVarietyLoaded extends CropVarietyState {
  final List<CropVariety> cropVarieties;
  final List<String> availableSeasons;

  const CropVarietyLoaded(
    this.cropVarieties, {
    this.availableSeasons = const [],
  });

  @override
  List<Object> get props => [cropVarieties, availableSeasons];
}

class CropVarietyError extends CropVarietyState {
  final String message;

  const CropVarietyError(this.message);

  @override
  List<Object> get props => [message];
}
