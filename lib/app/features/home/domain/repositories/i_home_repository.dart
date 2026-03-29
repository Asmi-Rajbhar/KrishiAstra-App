import 'package:krishiastra/app/features/home/domain/entities/crop_card_entity.dart';

/// Repository interface for home screen data.
abstract class IHomeRepository {
  /// Fetches a list of featured crops for the home screen dashboard.
  Future<List<CropCardEntity>> getHomeCrops();
}
