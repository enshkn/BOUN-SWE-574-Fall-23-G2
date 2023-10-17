import 'package:busenet/busenet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:swe/_common/constants/hive_constants.dart';
import 'package:swe/_core/classes/typedefs.dart';
import 'package:swe/_core/storage/hive/i_cache_service.dart';
import 'package:swe/_core/utility/record_utils.dart';
import 'package:swe/_domain/cache/model/token_model.dart';
import 'package:swe/_domain/network/app_network_manager.dart';
import 'package:swe/_domain/network/model/app_failure.dart';
import 'package:swe/_domain/network/network_paths.dart';
import 'package:swe/_domain/story/i_story_repository.dart';
import 'package:swe/_domain/story/model/story_model.dart';

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
    );

    switch (response.statusCode) {
      case 1:
        return right(response.entity as List<StoryModel>);
      default:
        return left(response.errorType);
    }
  }
}
