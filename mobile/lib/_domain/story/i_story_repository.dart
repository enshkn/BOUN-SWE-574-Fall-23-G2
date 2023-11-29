import 'package:swe/_core/classes/typedefs.dart';
import 'package:swe/_domain/story/model/addStory_model.dart';
import 'package:swe/_domain/story/model/comment_model.dart';
import 'package:swe/_domain/story/model/getNearbyStories_model.dart';
import 'package:swe/_domain/story/model/postComment_model.dart';
import 'package:swe/_domain/story/model/story_model.dart';

abstract interface class IStoryRepository {
  EitherFuture<List<StoryModel>> getAllStory();
  EitherFuture<List<StoryModel>> getActivityFeed();
  EitherFuture<List<StoryModel>> getFallowedStories();
  EitherFuture<List<StoryModel>> getNearbyStories(GetNearbyStoriesModel model);
  EitherFuture<List<StoryModel>> getRecommendedStories();

  EitherFuture<List<StoryModel>> myStories();
  EitherFuture<bool> deleteStory(int storyId);
  EitherFuture<StoryModel> getStoryDetail(int storyId);
  EitherFuture<StoryModel> addStoryModel(AddStoryModel model);
  EitherFuture<StoryModel> addFavorite({
    required int itemId,
  });
  EitherFuture<List<StoryModel>> getLikedStories();
  EitherFuture<List<StoryModel>> getRecentStories();
  EitherFuture<CommentModel> postComment(PostCommentModel model);
}
