import 'package:swe/_core/classes/typedefs.dart';
import 'package:swe/_domain/story/model/addStory_model.dart';
import 'package:swe/_domain/story/model/story_model.dart';

abstract interface class IStoryRepository {
  EitherFuture<List<StoryModel>> getAllStory();
  EitherFuture<List<StoryModel>> getActivityFeed();
  EitherFuture<List<StoryModel>> getFallowedStories();
  EitherFuture<List<StoryModel>> myStories();
  EitherFuture<bool> deleteStory(int storyId);
  EitherFuture<StoryModel> addStoryModel(AddStoryModel model);
  EitherFuture<bool> addFavorite({
    required int itemId,
  });
  EitherFuture<List<StoryModel>> getLikedStories();
}
