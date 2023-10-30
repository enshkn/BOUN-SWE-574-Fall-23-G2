import 'package:injectable/injectable.dart';
import 'package:swe/_application/core/base_cubit.dart';
import 'package:swe/_application/story/story_state.dart';
import 'package:swe/_core/utility/record_utils.dart';
import 'package:swe/_domain/story/i_story_repository.dart';
import 'package:swe/_domain/story/model/addStory_model.dart';

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
}
