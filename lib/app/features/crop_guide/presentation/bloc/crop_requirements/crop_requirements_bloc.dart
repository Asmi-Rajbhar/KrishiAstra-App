import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/bloc/crop_requirements/crop_requirements_event.dart';
import 'package:krishiastra/app/features/crop_guide/presentation/bloc/crop_requirements/crop_requirements_state.dart';
import 'package:krishiastra/app/features/crop_variety/domain/repositories/i_crop_repository.dart';

class CropRequirementsBloc
    extends Bloc<CropRequirementsEvent, CropRequirementsState> {
  final ICropRepository repository;

  CropRequirementsBloc({required this.repository})
    : super(CropRequirementsInitial()) {
    on<FetchCropRequirementsEvent>(_onFetchCropRequirements);
  }

  Future<void> _onFetchCropRequirements(
    FetchCropRequirementsEvent event,
    Emitter<CropRequirementsState> emit,
  ) async {
    emit(CropRequirementsLoading());
    final result = await repository.getCropRequirements(event.cropName);

    if (result.isSuccess) {
      emit(CropRequirementsLoaded(result.data!));
    } else {
      emit(CropRequirementsError(result.failure?.message ?? 'Unknown error'));
    }
  }
}
