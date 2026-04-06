import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:krishiastra/app/features/lifecycle_management/domain/entities/checklist_item.dart';
import 'package:krishiastra/app/features/lifecycle_management/domain/repositories/i_lifecycle_repository.dart';
import 'package:krishiastra/app/core/utils/result.dart';

part 'stage_event.dart';
part 'stage_state.dart';

class StageBloc extends Bloc<StageEvent, StageState> {
  final ILifecycleRepository lifecycleRepository;

  StageBloc({required this.lifecycleRepository}) : super(StageInitial()) {
    on<LoadChecklistDirectly>((event, emit) {
      emit(StageLoaded(event.checklist));
    });

    on<FetchChecklist>((event, emit) async {
      emit(StageLoading());
      final Result<List<ChecklistItem>> result = await lifecycleRepository
          .getChecklist(event.stageNumber);
      if (result.isSuccess) {
        emit(StageLoaded(result.data!));
      } else {
        emit(StageError(result.failure?.message ?? 'Unknown error'));
      }
    });

    on<ToggleCompletion>((event, emit) {
      if (state is StageLoaded) {
        final currentState = state as StageLoaded;
        final updatedChecklist = List<ChecklistItem>.from(
          currentState.checklist,
        );
        updatedChecklist[event.index].isCompleted = event.value ?? false;
        emit(StageLoaded(updatedChecklist));
      }
    });

    on<ToggleReminder>((event, emit) {
      if (state is StageLoaded) {
        final currentState = state as StageLoaded;
        final updatedChecklist = List<ChecklistItem>.from(
          currentState.checklist,
        );
        updatedChecklist[event.index].isReminderActive =
            !updatedChecklist[event.index].isReminderActive;
        emit(StageLoaded(updatedChecklist));
      }
    });
  }
}
