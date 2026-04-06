import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:krishiastra/app/features/diagnostics/domain/entities/diagnostic_category_model.dart';
import 'package:krishiastra/app/features/diagnostics/domain/entities/disease.dart';
import 'package:krishiastra/app/features/diagnostics/domain/entities/nutrient.dart';
import 'package:krishiastra/app/features/diagnostics/domain/repositories/i_diagnostic_repository.dart';
import 'package:krishiastra/app/core/utils/result.dart';

part 'diagnostic_event.dart';
part 'diagnostic_state.dart';

class DiagnosticBloc extends Bloc<DiagnosticEvent, DiagnosticState> {
  final IDiagnosticRepository diagnosticRepository;

  DiagnosticBloc({required this.diagnosticRepository})
    : super(const DiagnosticState()) {
    on<FetchDiagnostics>((event, emit) async {
      emit(state.copyWith(status: DiagnosticStatus.loading));
      final Result<List<DiagnosticCategory>> result = await diagnosticRepository
          .getDiagnostics();
      if (result.isSuccess) {
        emit(
          state.copyWith(
            status: DiagnosticStatus.loaded,
            diagnostics: result.data,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: DiagnosticStatus.error,
            error: result.failure?.message ?? 'l10n:unknownError',
          ),
        );
      }
    });

    on<FetchDiseases>((event, emit) async {
      emit(state.copyWith(status: DiagnosticStatus.loading));
      final Result<List<Disease>> result = await diagnosticRepository
          .getDiseases();
      if (result.isSuccess) {
        emit(
          state.copyWith(
            status: DiagnosticStatus.loaded,
            diseases: result.data,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: DiagnosticStatus.error,
            error: result.failure?.message ?? 'l10n:unknownError',
          ),
        );
      }
    });

    on<FetchDiseaseList>((event, emit) async {
      emit(state.copyWith(status: DiagnosticStatus.loading));
      final varietyId = event.varietyId;
      if (varietyId == null) {
        emit(
          state.copyWith(
            status: DiagnosticStatus.error,
            error: 'l10n:varietyIdRequired',
          ),
        );
        return;
      }
      final Result<List<Disease>> result = await diagnosticRepository
          .getDiseaseList(varietyId);
      if (result.isSuccess) {
        emit(
          state.copyWith(
            status: DiagnosticStatus.loaded,
            diseases: result.data,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: DiagnosticStatus.error,
            error: result.failure?.message ?? 'l10n:unknownError',
          ),
        );
      }
    });

    on<FetchDiseaseDetails>((event, emit) async {
      emit(state.copyWith(status: DiagnosticStatus.loading));
      final varietyId = event.varietyId;
      if (varietyId == null) {
        emit(
          state.copyWith(
            status: DiagnosticStatus.error,
            error: 'l10n:varietyIdRequired',
          ),
        );
        return;
      }
      final Result<Disease?> result = await diagnosticRepository
          .getDiseaseDetails(event.diseaseName, varietyId);
      if (result.isSuccess) {
        final disease = result.data;
        if (disease != null) {
          emit(
            state.copyWith(
              status: DiagnosticStatus.loaded,
              selectedDisease: disease,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: DiagnosticStatus.error,
              error: "l10n:diseaseDetailsNotFound",
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            status: DiagnosticStatus.error,
            error: result.failure?.message ?? 'l10n:unknownError',
          ),
        );
      }
    });

    on<FetchNutrients>((event, emit) async {
      emit(state.copyWith(status: DiagnosticStatus.loading));
      final varietyId = event.varietyId;
      if (varietyId == null) {
        emit(
          state.copyWith(
            status: DiagnosticStatus.error,
            error: 'l10n:varietyIdRequired',
          ),
        );
        return;
      }
      final Result<List<Nutrient>> result = await diagnosticRepository
          .getNutrientDeficiencyList(varietyId);
      if (result.isSuccess) {
        emit(
          state.copyWith(
            status: DiagnosticStatus.loaded,
            nutrients: result.data,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: DiagnosticStatus.error,
            error: result.failure?.message ?? 'l10n:unknownError',
          ),
        );
      }
    });

    on<FetchNutrientDetails>((event, emit) async {
      emit(state.copyWith(status: DiagnosticStatus.loading));
      final varietyId = event.varietyId;
      if (varietyId == null) {
        emit(
          state.copyWith(
            status: DiagnosticStatus.error,
            error: 'l10n:varietyIdRequired',
          ),
        );
        return;
      }
      final Result<Nutrient?> result = await diagnosticRepository
          .getNutrientDetails(event.nutrientName, varietyId);
      if (result.isSuccess) {
        final nutrient = result.data;
        if (nutrient != null) {
          emit(
            state.copyWith(
              status: DiagnosticStatus.loaded,
              selectedNutrient: nutrient,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: DiagnosticStatus.error,
              error: "l10n:nutrientDetailsNotFound",
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            status: DiagnosticStatus.error,
            error: result.failure?.message ?? 'l10n:unknownError',
          ),
        );
      }
    });
  }
}
