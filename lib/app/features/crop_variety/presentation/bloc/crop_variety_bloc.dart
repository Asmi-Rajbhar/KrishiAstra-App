import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:krishiastra/app/features/crop_variety/domain/entities/crop_variety.dart';
import 'package:krishiastra/app/features/crop_variety/domain/repositories/i_crop_repository.dart';
import 'package:krishiastra/app/core/utils/result.dart';

part 'crop_variety_event.dart';
part 'crop_variety_state.dart';

class CropVarietyBloc extends Bloc<CropVarietyEvent, CropVarietyState> {
  final ICropRepository cropVarietyRepository;

  CropVarietyBloc({required this.cropVarietyRepository})
    : super(CropVarietyInitial()) {
    on<FetchCropVarieties>((event, emit) async {
      emit(CropVarietyLoading());

      final cropName = event.cropName;
      if (cropName == null) {
        emit(const CropVarietyError('Crop name is required'));
        return;
      }

      final results = await Future.wait([
        cropVarietyRepository.getVarieties(cropName),
        cropVarietyRepository.getAvailableCropSeasons(cropName),
      ]);

      final varietyResult = results[0] as Result<List<CropVariety>>;
      final seasonResult = results[1] as Result<List<String>>;

      if (varietyResult.isSuccess) {
        final cropVarieties = varietyResult.data!;
        final availableSeasons = seasonResult.data ?? [];

        if (event.season != null) {
          final filtered = cropVarieties
              .where(
                (v) =>
                    v.season?.toLowerCase().trim() ==
                    event.season!.toLowerCase().trim(),
              )
              .toList();
          emit(CropVarietyLoaded(filtered, availableSeasons: availableSeasons));
        } else {
          emit(
            CropVarietyLoaded(
              cropVarieties,
              availableSeasons: availableSeasons,
            ),
          );
        }
      } else {
        emit(
          CropVarietyError(varietyResult.failure?.message ?? 'Unknown error'),
        );
      }
    });
  }
}
