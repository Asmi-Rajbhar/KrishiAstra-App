part of 'stage_bloc.dart';

abstract class StageEvent extends Equatable {
  const StageEvent();

  @override
  List<Object> get props => [];
}

class FetchChecklist extends StageEvent {
  final String stageNumber;

  const FetchChecklist(this.stageNumber);

  @override
  List<Object> get props => [stageNumber];
}

class ToggleCompletion extends StageEvent {
  final int index;
  final bool? value;

  const ToggleCompletion(this.index, this.value);

  @override
  List<Object> get props => [index, value!];
}

class ToggleReminder extends StageEvent {
  final int index;

  const ToggleReminder(this.index);

  @override
  List<Object> get props => [index];
}

class LoadChecklistDirectly extends StageEvent {
  final List<ChecklistItem> checklist;

  const LoadChecklistDirectly(this.checklist);

  @override
  List<Object> get props => [checklist];
}
