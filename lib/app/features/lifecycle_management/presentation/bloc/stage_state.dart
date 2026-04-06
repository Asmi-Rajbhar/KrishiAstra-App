part of 'stage_bloc.dart';

abstract class StageState extends Equatable {
  const StageState();

  @override
  List<Object> get props => [];
}

class StageInitial extends StageState {}

class StageLoading extends StageState {}

class StageLoaded extends StageState {
  final List<ChecklistItem> checklist;

  const StageLoaded(this.checklist);

  @override
  List<Object> get props => [checklist];
}

class StageError extends StageState {
  final String message;

  const StageError(this.message);

  @override
  List<Object> get props => [message];
}
