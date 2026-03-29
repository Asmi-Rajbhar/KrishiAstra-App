import 'package:krishiastra/app/core/utils/result.dart';
import 'package:krishiastra/app/features/video_gallery/domain/entities/video.dart';

/// Repository interface for video gallery operations.
abstract class IVideoRepository {
  /// Fetches a paginated list of videos.
  Future<Result<List<Video>>> getVideos({int limit = 100, int offset = 0});
}
