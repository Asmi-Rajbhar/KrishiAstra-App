import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/bloc/crop_overview/crop_overview_event.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/bloc/crop_overview/crop_overview_state.dart';
import 'package:krishiastra/app/features/crop_variety/domain/repositories/i_crop_repository.dart';

class CropOverviewBloc extends Bloc<CropOverviewEvent, CropOverviewState> {
  final ICropRepository repository;

  CropOverviewBloc({required this.repository}) : super(CropOverviewInitial()) {
    on<FetchCropOverviewEvent>(_onFetchCropOverview);
  }

  Future<void> _onFetchCropOverview(
    FetchCropOverviewEvent event,
    Emitter<CropOverviewState> emit,
  ) async {
    emit(CropOverviewLoading());
    final result = await repository.getCropBasicDetails(event.cropName);

    if (result.isSuccess) {
      emit(CropOverviewLoaded(result.data!));
    } else {
      emit(CropOverviewError(result.failure?.message ?? 'Unknown error'));
    }
  }
}
