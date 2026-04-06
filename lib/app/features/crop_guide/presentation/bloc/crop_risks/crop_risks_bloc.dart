import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/bloc/crop_risks/crop_risks_event.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/bloc/crop_risks/crop_risks_state.dart';
import 'package:krishiastra/app/features/crop_variety/domain/repositories/i_crop_repository.dart';

class CropRisksBloc extends Bloc<CropRisksEvent, CropRisksState> {
  final ICropRepository repository;

  CropRisksBloc({required this.repository}) : super(CropRisksInitial()) {
    on<FetchCropRisksEvent>(_onFetchCropRisks);
  }

  Future<void> _onFetchCropRisks(
    FetchCropRisksEvent event,
    Emitter<CropRisksState> emit,
  ) async {
    emit(CropRisksLoading());
    final result = await repository.getRiskAndCare(event.cropName);

    if (result.isSuccess) {
      emit(CropRisksLoaded(result.data!));
    } else {
      emit(CropRisksError(result.failure?.message ?? 'Unknown error'));
    }
  }
}
