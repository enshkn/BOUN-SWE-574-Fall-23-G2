import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:swe/_application/core/base_state.dart';
import 'package:swe/_domain/story/model/story_model.dart';

part 'story_state.freezed.dart';

@freezed
class StoryState extends BaseState with _$StoryState {
  const factory StoryState({
    @Default(false) bool isLoading,
    StoryModel? storyModel,
    @Default([]) List<StoryModel> allStories,
    @Default([]) List<StoryModel> activityFeedStories,
    @Default([]) List<StoryModel> myStories,
    List<StoryModel>? fallowedStories,
  }) = _StoryState;
  factory StoryState.initial() => const StoryState();
}
