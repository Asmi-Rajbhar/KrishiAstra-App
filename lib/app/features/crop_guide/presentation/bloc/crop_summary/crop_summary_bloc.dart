import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/bloc/crop_summary/crop_summary_event.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/bloc/crop_summary/crop_summary_state.dart';
import 'package:krishiastra/app/features/crop_variety/domain/repositories/i_crop_repository.dart';

class CropSummaryBloc extends Bloc<CropSummaryEvent, CropSummaryState> {
  final ICropRepository repository;

  CropSummaryBloc({required this.repository}) : super(CropSummaryInitial()) {
    on<FetchCropSummaryEvent>(_onFetchCropSummary);
  }

  Future<void> _onFetchCropSummary(
    FetchCropSummaryEvent event,
    Emitter<CropSummaryState> emit,
  ) async {
    emit(CropSummaryLoading());
    final result = await repository.getCropBasicDetails(event.cropName);

    if (result.isSuccess) {
      emit(CropSummaryLoaded(result.data!));
    } else {
      emit(CropSummaryError(result.failure?.message ?? 'Unknown error'));
    }
  }
}
