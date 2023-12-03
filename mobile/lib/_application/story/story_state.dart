import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:swe/_application/core/base_state.dart';
import 'package:swe/_domain/story/model/story_filter.dart';
import 'package:swe/_domain/story/model/story_model.dart';

part 'story_state.freezed.dart';

@freezed
class StoryState extends BaseState with _$StoryState {
  const factory StoryState({
    @Default(false) bool isLoading,
    StoryModel? storyModel,
    @Default([]) List<StoryModel> allStories,
    @Default([]) List<StoryModel> searchResultStories,
    @Default([]) List<StoryModel> timelineResultStories,
    @Default([]) List<StoryModel> activityFeedStories,
    @Default([]) List<StoryModel> myStories,
    @Default([]) List<StoryModel> likedStories,
    @Default([]) List<StoryModel> savedStories,
    @Default([]) List<StoryModel> recentStories,
    @Default([]) List<StoryModel> nearbyStories,
    @Default([]) List<StoryModel> recommendedStories,
    @Default([]) List<StoryModel> tagSearchStories,
    String? search,
    StoryFilter? filter,
    List<StoryModel>? fallowedStories,
  }) = _StoryState;
  factory StoryState.initial() => const StoryState();
}
