import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:krishiastra/app/features/lifecycle_management/domain/repositories/i_lifecycle_repository.dart';
import 'package:krishiastra/app/core/utils/result.dart';

import 'package:krishiastra/app/features/lifecycle_management/domain/entities/crop_lifecycle_stage.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_variety.dart';

part 'lifecycle_management_event.dart';
part 'lifecycle_management_state.dart';

class LifecycleManagementBloc
    extends Bloc<LifecycleManagementEvent, LifecycleManagementState> {
  final ILifecycleRepository lifecycleRepository;

  LifecycleManagementBloc({required this.lifecycleRepository})
    : super(const LifecycleManagementState(isLoading: true)) {
    on<InitializeLifecycleData>(_onInitialize);
    on<OnSelectionChanged>(_onSelectionChanged);
    on<OnSeasonChanged>(_onSeasonChanged);
    on<FetchCropLifecycleStagesEvent>(_onFetchCropLifecycleStages);
  }

  Future<void> _onFetchCropLifecycleStages(
    FetchCropLifecycleStagesEvent event,
    Emitter<LifecycleManagementState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await lifecycleRepository.getCropLifecycleStages(
      event.cropName,
    );

    if (result.isSuccess) {
      emit(state.copyWith(isLoading: false, lifecycleStages: result.data));
    } else {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: result.failure?.message ?? 'Unknown error',
        ),
      );
    }
  }

  Future<void> _onInitialize(
    InitializeLifecycleData event,
    Emitter<LifecycleManagementState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        selectedVariety: event.variety,
        selectedSeason: event.season,
      ),
    );
    try {
      final cropName = event.cropName;
      if (cropName == null) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Crop name is required',
          ),
        );
        return;
      }
      final Result<List<CropVariety>> varietiesResult =
          await lifecycleRepository.getVarieties(cropName);
      final Result<List<String>> seasonsResult = await lifecycleRepository
          .getAvailableSeasons(event.variety);

      if (varietiesResult.isSuccess && seasonsResult.isSuccess) {
        final varieties = varietiesResult.data!;
        final seasons = seasonsResult.data!;

        String? currentSeason =
            event.season ?? (seasons.isNotEmpty ? seasons.first : null);

        if (currentSeason == null) {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: 'No seasons available',
            ),
          );
          return;
        }

        final Result<List<CropLifecycleStage>> stagesResult =
            await lifecycleRepository.getCropLifecycle(
              variety: event.variety,
              season: currentSeason,
            );

        if (stagesResult.isSuccess) {
          emit(
            state.copyWith(
              varieties: varieties,
              availableSeasons: seasons,
              selectedVariety: event.variety,
              selectedSeason: currentSeason,
              lifecycleStages: stagesResult.data,
              isLoading: false,
            ),
          );
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: stagesResult.failure?.message,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage:
                varietiesResult.failure?.message ??
                seasonsResult.failure?.message,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onSelectionChanged(
    OnSelectionChanged event,
    Emitter<LifecycleManagementState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, selectedVariety: event.variety));
    try {
      final Result<List<String>> seasonsResult = await lifecycleRepository
          .getAvailableSeasons(event.variety);

      if (seasonsResult.isSuccess) {
        final seasons = seasonsResult.data!;
        String? newSeason = seasons.contains(state.selectedSeason)
            ? state.selectedSeason
            : (seasons.isNotEmpty ? seasons.first : null);

        if (newSeason == null) {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: 'No seasons available',
            ),
          );
          return;
        }

        final Result<List<CropLifecycleStage>> stagesResult =
            await lifecycleRepository.getCropLifecycle(
              variety: event.variety,
              season: newSeason,
            );

        if (stagesResult.isSuccess) {
          emit(
            state.copyWith(
              availableSeasons: seasons,
              selectedSeason: newSeason,
              lifecycleStages: stagesResult.data,
              isLoading: false,
            ),
          );
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: stagesResult.failure?.message,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: seasonsResult.failure?.message,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onSeasonChanged(
    OnSeasonChanged event,
    Emitter<LifecycleManagementState> emit,
  ) async {
    if (event.season == state.selectedSeason) return;

    emit(state.copyWith(isLoading: true, selectedSeason: event.season));
    try {
      final Result<List<CropLifecycleStage>> result = await lifecycleRepository
          .getCropLifecycle(
            variety: state.selectedVariety!,
            season: event.season,
          );

      if (result.isSuccess) {
        emit(state.copyWith(lifecycleStages: result.data, isLoading: false));
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.failure?.message,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
