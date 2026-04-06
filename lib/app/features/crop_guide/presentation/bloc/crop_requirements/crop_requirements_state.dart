import 'package:equatable/equatable.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_requirement.dart';

abstract class CropRequirementsState extends Equatable {
  const CropRequirementsState();

  @override
  List<Object?> get props => [];
}

class CropRequirementsInitial extends CropRequirementsState {}

class CropRequirementsLoading extends CropRequirementsState {}

class CropRequirementsLoaded extends CropRequirementsState {
  final CropRequirement data;

  const CropRequirementsLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class CropRequirementsError extends CropRequirementsState {
  final String message;

  const CropRequirementsError(this.message);

  @override
  List<Object?> get props => [message];
}
