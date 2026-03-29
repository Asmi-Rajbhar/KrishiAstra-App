import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:krishiastra/app/features/diagnostics/domain/repositories/i_diagnostic_repository.dart';
import 'package:krishiastra/app/features/diagnostics/domain/entities/disease.dart';

part 'scanner_event.dart';
part 'scanner_state.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  final IDiagnosticRepository diagnosticRepository;

  ScannerBloc({required this.diagnosticRepository}) : super(ScannerInitial()) {
    on<InitializeCamera>((event, emit) {
      emit(CameraReady());
    });

    on<CaptureAndAnalyze>((event, emit) async {
      emit(ScannerLoading());
      try {
        final result = await diagnosticRepository.detectDisease(
          event.imagePath,
        );
        if (result.isSuccess) {
          emit(ScannerSuccess(result.data));
        } else {
          emit(ScannerFailure(result.failure?.message ?? 'l10n:detectionFailed'));
        }
      } catch (e) {
        emit(ScannerFailure(e.toString()));
      }
    });

    on<ResetScanner>((event, emit) {
      emit(ScannerInitial());
    });
  }
}
