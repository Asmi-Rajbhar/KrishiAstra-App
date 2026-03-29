import 'package:krishiastra/app/core/utils/result.dart';
import 'package:krishiastra/app/features/success_stories/domain/entities/story_detail.dart';

/// Repository interface for success stories.
abstract class ISuccessStoryRepository {
  /// Fetches a list of all success stories.
  Future<Result<List<StoryDetail>>> getSuccessStories();

  /// Fetches detailed information for a specific success story by its title.
  Future<Result<StoryDetail>> getStoryDetail(String title);
}
