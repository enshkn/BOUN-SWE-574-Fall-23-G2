import 'package:swe/_core/classes/typedefs.dart';
import 'package:swe/_domain/story/model/story_model.dart';

abstract interface class IStoryRepository {
  EitherFuture<List<StoryModel>> getAllStory();
  EitherFuture<List<StoryModel>> getActivityFeed();
  EitherFuture<List<StoryModel>> getFallowedStories();
}
