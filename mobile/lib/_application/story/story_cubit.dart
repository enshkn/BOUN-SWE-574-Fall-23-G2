import 'package:injectable/injectable.dart';
import 'package:swe/_application/core/base_cubit.dart';
import 'package:swe/_application/story/story_state.dart';
import 'package:swe/_core/utility/record_utils.dart';
import 'package:swe/_domain/story/i_story_repository.dart';
import 'package:swe/_domain/story/model/addStory_model.dart';
import 'package:swe/_domain/story/model/comment_model.dart';
import 'package:swe/_domain/story/model/getNearbyStories_model.dart';
import 'package:swe/_domain/story/model/postComment_model.dart';

@injectable
final class StoryCubit extends BaseCubit<StoryState> {
  final IStoryRepository _storyRepository;
  StoryCubit(this._storyRepository) : super(StoryState.initial());

  void init() {}

  @override
  void setLoading(bool loading) {
    safeEmit(state.copyWith(isLoading: loading));
  }

  Future<void> getStoryAll() async {
    setLoading(true);
    final result = await _storyRepository.getAllStory();
    setLoading(false);
    result.fold(
      (failure) => showNotification(failure?.message ?? '', isError: true),
      (allStories) {
        safeEmit(state.copyWith(allStories: allStories));
      },
    );
  }

  Future<void> getRecentStory() async {
    setLoading(true);
    final result = await _storyRepository.getRecentStories();
    setLoading(false);
    result.fold(
      (failure) => showNotification(failure?.message ?? '', isError: true),
      (recentStories) {
        safeEmit(state.copyWith(recentStories: recentStories));
      },
    );
  }

  Future<void> getActivityFeeed() async {
    setLoading(true);
    final result = await _storyRepository.getActivityFeed();
    setLoading(false);
    result.fold(
      (failure) => showNotification(failure?.message ?? '', isError: true),
      (activityFeedStories) {
        safeEmit(state.copyWith(activityFeedStories: activityFeedStories));
      },
    );
  }

  Future<void> getFallowedStories() async {
    setLoading(true);
    final result = await _storyRepository.getFallowedStories();
    setLoading(false);
    result.fold(
      (failure) => showNotification(failure?.message ?? '', isError: true),
      (fallowedStories) {
        safeEmit(state.copyWith(fallowedStories: fallowedStories));
      },
    );
  }

  Future<void> getMyStories() async {
    setLoading(true);
    final result = await _storyRepository.myStories();
    setLoading(false);
    result.fold(
      (failure) => showNotification(failure?.message ?? '', isError: true),
      (myStories) {
        safeEmit(state.copyWith(myStories: myStories));
      },
    );
  }

  Future<void> getNearbyStories(GetNearbyStoriesModel model) async {
    setLoading(true);
    final result = await _storyRepository.getNearbyStories(model);
    setLoading(false);
    result.fold(
      (failure) => showNotification(failure?.message ?? '', isError: true),
      (nearbyStories) {
        safeEmit(state.copyWith(nearbyStories: nearbyStories));
      },
    );
  }

  Future<bool> addStory(AddStoryModel model) async {
    setLoading(true);
    final result = await _storyRepository.addStoryModel(model);
    setLoading(false);
    return result.fold(
      (failure) {
        showNotification(failure?.message ?? '', isError: true);
        return false;
      },
      (data) {
        showNotification('Your Story is added.');
        return true;
      },
    );
  }

  Future<bool> addComment(PostCommentModel model) async {
    setLoading(true);
    final result = await _storyRepository.postComment(model);
    setLoading(false);
    return result.fold(
      (failure) {
        showNotification(failure?.message ?? '', isError: true);
        return false;
      },
      (data) {
        showNotification('Your comment is added.');
        return true;
      },
    );
  }

  Future<bool> deleteStory(int storyId) async {
    setLoading(true);
    final result = await _storyRepository.deleteStory(storyId);
    setLoading(false);
    return result.fold(
      (failure) {
        showNotification(failure?.message ?? '', isError: true);
        return false;
      },
      (data) {
        showNotification('Your Story is deleted.');

        return true;
      },
    );
  }

  Future<void> getStoryDetail(int storyId) async {
    setLoading(true);
    final result = await _storyRepository.getStoryDetail(storyId);
    setLoading(false);
    result.fold(
      (failure) => showNotification(failure?.message ?? '', isError: true),
      (data) {
        safeEmit(state.copyWith(storyModel: data));
      },
    );
  }

  Future<void> getLikedStories() async {
    setLoading(true);
    final result = await _storyRepository.getLikedStories();
    setLoading(false);
    result.fold(
      (failure) => showNotification(failure?.message ?? '', isError: true),
      (likedStories) {
        safeEmit(state.copyWith(likedStories: likedStories));
      },
    );
  }
}
