import 'package:krishiastra/app/features/climatic_requirements/domain/repositories/i_climatic_repository.dart';
import 'package:krishiastra/app/features/climatic_requirements/presentation/bloc/climatic_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// BLoC (Business Logic Component) that manages the state of Climatic Requirements.
/// It reacts to [ClimaticEvent]s and emits [ClimaticState]s.
class ClimaticBloc extends Bloc<ClimaticEvent, ClimaticState> {
  /// The repository instance requested via dependency injection.
  final IClimaticRepository climaticRepository;

  ClimaticBloc({required this.climaticRepository}) : super(ClimaticInitial()) {
    // Registering the handler for FetchClimaticRequirements event.
    on<FetchClimaticRequirements>(_onFetchClimaticRequirements);
  }

  /// Handler for the [FetchClimaticRequirements] event.
  /// Handles loading, success, and error states during data fetching.
  Future<void> _onFetchClimaticRequirements(
    FetchClimaticRequirements event,
    Emitter<ClimaticState> emit,
  ) async {
    // Show loading indicator in the UI.
    emit(ClimaticLoading());
    try {
      // Fetching data from the repository.
      final result = await climaticRepository.getClimaticConditions(
        crop: event.crop,
        land: event.land,
      );

      if (result.isSuccess) {
        emit(ClimaticLoaded(result.data!));
      } else {
        emit(ClimaticError(result.failure!.message));
      }
    } catch (e) {
      // Emitting error state if the fetch fails.
      emit(ClimaticError(e.toString()));
    }
  }
}
