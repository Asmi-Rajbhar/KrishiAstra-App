import 'package:equatable/equatable.dart';
import 'package:krishiastra/app/features/climatic_requirements/domain/entities/climatic_model.dart';

/// Base class for all Climatic Requirements events.
abstract class ClimaticEvent extends Equatable {
  const ClimaticEvent();

  @override
  List<Object?> get props => [];
}

/// Event triggered to load/refresh climatic requirements.
class FetchClimaticRequirements extends ClimaticEvent {
  final String? crop;
  final String? land;
  const FetchClimaticRequirements({this.crop, this.land});

  @override
  List<Object?> get props => [crop, land];
}

/// Base class for all Climatic Requirements states.
abstract class ClimaticState extends Equatable {
  const ClimaticState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any action is taken.
class ClimaticInitial extends ClimaticState {}

/// State emitted while fetching data from the repository.
class ClimaticLoading extends ClimaticState {}

/// State emitted when climatic requirements are successfully loaded.
class ClimaticLoaded extends ClimaticState {
  /// The loaded climatic requirement entity.
  final ClimaticRequirement climaticRequirement;

  const ClimaticLoaded(this.climaticRequirement);

  @override
  List<Object> get props => [climaticRequirement];
}

/// State emitted when an error occurs during data fetching.
class ClimaticError extends ClimaticState {
  /// The error message to display in the UI.
  final String message;

  const ClimaticError(this.message);

  @override
  List<Object> get props => [message];
}
