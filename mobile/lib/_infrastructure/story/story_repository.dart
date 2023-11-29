import 'package:busenet/busenet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:swe/_core/classes/typedefs.dart';
import 'package:swe/_core/utility/record_utils.dart';
import 'package:swe/_domain/network/app_network_manager.dart';
import 'package:swe/_domain/network/model/app_failure.dart';
import 'package:swe/_domain/network/network_paths.dart';
import 'package:swe/_domain/story/i_story_repository.dart';
import 'package:swe/_domain/story/model/addStory_model.dart';
import 'package:swe/_domain/story/model/comment_model.dart';
import 'package:swe/_domain/story/model/getNearbyStories_model.dart';
import 'package:swe/_domain/story/model/postComment_model.dart';
import 'package:swe/_domain/story/model/story_model.dart';
import 'package:swe/_presentation/widgets/wrapper/favorite_type.dart';

@LazySingleton(as: IStoryRepository)
@immutable
class StoryRepository implements IStoryRepository {
  final AppNetworkManager manager;
  const StoryRepository(
    this.manager,
  );

  @override
  EitherFuture<List<StoryModel>> getAllStory() async {
    final response = await manager.fetch<StoryModel, List<StoryModel>>(
      NetworkPaths.getAllStory,
      type: HttpTypes.get,
      parserModel: StoryModel(),
    );

    switch (response.statusCode) {
      case 1:
        return right(response.entity as List<StoryModel>);
      default:
        return left(response.errorType);
    }
  }

  @override
  EitherFuture<List<StoryModel>> getActivityFeed() async {
    final response = await manager.fetch<StoryModel, List<StoryModel>>(
      NetworkPaths.getActivityFeed,
      type: HttpTypes.get,
      parserModel: StoryModel(),
    );

    switch (response.statusCode) {
      case 1:
        return right(response.entity as List<StoryModel>);
      default:
        return left(response.errorType);
    }
  }

  @override
  EitherFuture<List<StoryModel>> getFallowedStories() async {
    final response = await manager.fetch<StoryModel, List<StoryModel>>(
      NetworkPaths.getFallowedStories,
      type: HttpTypes.get,
      parserModel: StoryModel(),
      cachePolicy: CachePolicy.noCache,
    );

    switch (response.statusCode) {
      case 1:
        return right(response.entity as List<StoryModel>);
      default:
        return left(response.errorType);
    }
  }

  @override
  EitherFuture<StoryModel> addStoryModel(AddStoryModel model) async {
    final response = await manager.fetch<StoryModel, StoryModel>(
      NetworkPaths.addStory,
      type: HttpTypes.post,
      parserModel: StoryModel(),
      data: model.toJson(),
    );

    switch (response.statusCode) {
      case 1:
        return right(response.entity as StoryModel);
      default:
        return left(response.errorType);
    }
  }

  @override
  EitherFuture<List<StoryModel>> myStories() async {
    final response = await manager.fetch<StoryModel, List<StoryModel>>(
      NetworkPaths.myStories,
      type: HttpTypes.get,
      parserModel: StoryModel(),
      cachePolicy: CachePolicy.noCache,
    );

    switch (response.statusCode) {
      case 1:
        return right(response.entity as List<StoryModel>);
      default:
        return left(response.errorType);
    }
  }

  @override
  EitherFuture<bool> deleteStory(int storyId) async {
    final response = await manager.fetch<NoResultResponse, NoResultResponse>(
      '/api/story/delete/$storyId',
      type: HttpTypes.get,
      parserModel: NoResultResponse(),
    );
    switch (response.statusCode) {
      case 1:
        final status = response.success ?? false;
        if (!status) return left(AppFailure(message: response.message));
        return right(true);
      default:
        return left(response.errorType);
    }
  }

  @override
  EitherFuture<StoryModel> addFavorite({
    required int itemId,
  }) async {
    final response = await manager.fetch<StoryModel, StoryModel>(
      NetworkPaths.likeStory,
      type: HttpTypes.post,
      cachePolicy: CachePolicy.noCache,
      parserModel: StoryModel(),
      data: {
        'likedEntityId': itemId,
      },
    );

    switch (response.statusCode) {
      case 1:
        return right(response.entity as StoryModel);
      default:
        return left(response.errorType);
    }
  }

  @override
  EitherFuture<List<StoryModel>> getLikedStories() async {
    final response = await manager.fetch<StoryModel, List<StoryModel>>(
      NetworkPaths.getLikedStories,
      type: HttpTypes.get,
      parserModel: StoryModel(),
      cachePolicy: CachePolicy.noCache,
    );

    switch (response.statusCode) {
      case 1:
        return right(response.entity as List<StoryModel>);
      default:
        return left(response.errorType);
    }
  }

  @override
  EitherFuture<List<StoryModel>> getRecentStories() async {
    final response = await manager.fetch<StoryModel, List<StoryModel>>(
      NetworkPaths.getRecent,
      type: HttpTypes.get,
      parserModel: StoryModel(),
      cachePolicy: CachePolicy.noCache,
    );

    switch (response.statusCode) {
      case 1:
        return right(response.entity as List<StoryModel>);
      default:
        return left(response.errorType);
    }
  }

  @override
  EitherFuture<CommentModel> postComment(PostCommentModel model) async {
    final response = await manager.fetch<CommentModel, CommentModel>(
      NetworkPaths.postComments,
      type: HttpTypes.post,
      parserModel: const CommentModel(),
      data: model.toJson(),
    );
    switch (response.statusCode) {
      case 1:
        return right(response.entity as CommentModel);
      default:
        return left(response.errorType);
    }
  }

  @override
  EitherFuture<StoryModel> getStoryDetail(int storyId) async {
    final response = await manager.fetch<StoryModel, StoryModel>(
      '/api/story/$storyId',
      type: HttpTypes.get,
      parserModel: StoryModel(),
      cachePolicy: CachePolicy.noCache,
    );
    switch (response.statusCode) {
      case 1:
        return right(response.entity as StoryModel);
      default:
        return left(response.errorType);
    }
  }

  @override
  EitherFuture<List<StoryModel>> getNearbyStories(
    GetNearbyStoriesModel model,
  ) async {
    final response = await manager.fetch<StoryModel, List<StoryModel>>(
      NetworkPaths.nearby,
      type: HttpTypes.get,
      parserModel: StoryModel(),
      queryParameters: {
        'radius': model.radius,
        'latitude': model.latitude,
        'longitude': model.longitude,
      },
    );

    switch (response.statusCode) {
      case 1:
        return right(response.entity as List<StoryModel>);
      default:
        return left(response.errorType);
    }
  }

  @override
  EitherFuture<List<StoryModel>> getRecommendedStories() async {
    final response = await manager.fetch<StoryModel, List<StoryModel>>(
      NetworkPaths.getActivityFeed,
      type: HttpTypes.get,
      parserModel: StoryModel(),
    );

    switch (response.statusCode) {
      case 1:
        return right(response.entity as List<StoryModel>);
      default:
        return left(response.errorType);
    }
  }
}
