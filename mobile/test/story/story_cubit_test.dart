import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:swe/_application/story/story_cubit.dart';
import 'package:swe/_application/story/story_state.dart';
import 'package:swe/_core/utility/record_utils.dart';
import 'package:swe/_domain/auth/model/user.dart';
import 'package:swe/_domain/profile/i_profile_repository.dart';
import 'package:swe/_domain/story/i_story_repository.dart';
import 'package:swe/_domain/story/model/addStory_model.dart';
import 'package:swe/_domain/story/model/getNearbyStories_model.dart';
import 'package:swe/_domain/story/model/story_model.dart';
import 'package:swe/_infrastructure/profile/profile_repository.dart';
import 'package:swe/_infrastructure/story/story_repository.dart';

import 'story_cubit_test.mocks.dart';

const dependecies = [
  IStoryRepository,
  IProfileRepository,
  StoryModel,
  User,
  GetNearbyStoriesModel,
  BuildContext,
];

@GenerateMocks(dependecies)
void main() {
  late IStoryRepository mockStoryRepository;
  late StoryCubit storyCubit;
  late BuildContext context;

  setUp(() {
    context = MockBuildContext();

    mockStoryRepository = MockIStoryRepository();
    storyCubit = StoryCubit(
      mockStoryRepository,
    );
  });

  //tearDown(storyCubit.close);

  group(StoryCubit, () {
    test('initial state should be correct', () {
      expect(storyCubit.state, StoryState.initial());
    });
    test('recentStories returns a list of StoryModel on successful response',
        () async {
      final storyListModel = List.generate(3, (index) => StoryModel());
      when(mockStoryRepository.getRecentStories()).thenAnswer(
        (_) async => right(
          storyListModel,
        ),
      );
      // Act
      await storyCubit.getRecentStory();

      // Assert
      verify(mockStoryRepository.getRecentStories());
      expect(storyCubit.state.recentStories, isNotEmpty);
    });
  });

  test('activityFeed returns a list of StoryModel on successful response',
      () async {
    final storyListModel = List.generate(3, (index) => StoryModel());
    when(mockStoryRepository.getActivityFeed()).thenAnswer(
      (_) async => right(
        storyListModel,
      ),
    );
    // Act
    await storyCubit.getActivityFeeed();

    // Assert
    verify(mockStoryRepository.getActivityFeed());
    expect(storyCubit.state.activityFeedStories, isNotEmpty);
  });

  test('getFallowedStories returns a list of StoryModel on successful response',
      () async {
    final storyListModel = List.generate(3, (index) => StoryModel());
    when(mockStoryRepository.getFallowedStories()).thenAnswer(
      (_) async => right(
        storyListModel,
      ),
    );
    // Act
    await storyCubit.getFallowedStories();

    // Assert
    verify(mockStoryRepository.getFallowedStories());
    expect(storyCubit.state.fallowedStories, isNotEmpty);
  });

  test('myStories returns a list of StoryModel on successful response',
      () async {
    final storyListModel = List.generate(3, (index) => StoryModel());
    when(mockStoryRepository.myStories()).thenAnswer(
      (_) async => right(
        storyListModel,
      ),
    );
    // Act
    await storyCubit.getMyStories();

    // Assert
    verify(mockStoryRepository.myStories());
    expect(storyCubit.state.myStories, isNotEmpty);
  });

  test('getNearbyStories returns a list of StoryModel on successful response',
      () async {
    final storyListModel = List.generate(3, (index) => StoryModel());
    final nearbyStories =
        List.generate(1, (index) => const GetNearbyStoriesModel());
    when(mockStoryRepository.getNearbyStories(nearbyStories[0])).thenAnswer(
      (_) async => right(
        storyListModel,
      ),
    );
    // Act
    await storyCubit.getNearbyStories(nearbyStories[0]);

    // Assert
    verify(mockStoryRepository.getNearbyStories(nearbyStories[0]));
    expect(storyCubit.state.nearbyStories, isNotEmpty);
  });

  test('recommended returns a list of StoryModel on successful response',
      () async {
    final storyListModel = List.generate(3, (index) => StoryModel());
    when(mockStoryRepository.getRecommendedStories()).thenAnswer(
      (_) async => right(
        storyListModel,
      ),
    );
    // Act
    await storyCubit.getRecommendedStories();

    // Assert
    verify(mockStoryRepository.getRecommendedStories());
    expect(storyCubit.state.recommendedStories, isNotEmpty);
  });

  test('set Context', () async {
    // final context = MockBuildContext();

    final mockBuildContext = MockBuildContext();

    // Act
    final result = storyCubit.setContext(mockBuildContext);

    // Assert
    expect(result, mockBuildContext);
    expect(storyCubit.context, mockBuildContext);
  });

  test('addStory returns true on successful response', () async {
    // Arrange
    const addStoryModel = AddStoryModel(
      text: '',
      title: '',
    );

    final storyModel = StoryModel();

    when(mockStoryRepository.addStoryModel(addStoryModel)).thenAnswer(
      (_) async => right(storyModel),
    );
    // Act
    final result = await storyCubit.addStory(addStoryModel);

    // Assert
    verify(
      mockStoryRepository.addStoryModel(
        addStoryModel,
      ),
    );
    expect(result, true);
  });

  test('storyDetail returns a story on successful response', () async {
    // Arrange

    final storyModel = StoryModel();

    when(mockStoryRepository.getStoryDetail(0)).thenAnswer(
      (_) async => right(storyModel),
    );
    // Act
    await storyCubit.getStoryDetail(0);

    // Assert
    verify(
      mockStoryRepository.getStoryDetail(
        0,
      ),
    );
    expect(storyCubit.state.storyModel, StoryModel());
  });

  test('getliked returns a list of StoryModel on successful response',
      () async {
    final storyListModel = List.generate(3, (index) => StoryModel());
    when(mockStoryRepository.getLikedStories()).thenAnswer(
      (_) async => right(
        storyListModel,
      ),
    );
    // Act
    await storyCubit.getLikedStories();

    // Assert
    verify(mockStoryRepository.getLikedStories());
    expect(storyCubit.state.likedStories, isNotEmpty);
  });

  test('recommended returns a list of StoryModel on successful response',
      () async {
    final storyListModel = List.generate(3, (index) => StoryModel());
    when(mockStoryRepository.getRecommendedStories()).thenAnswer(
      (_) async => right(
        storyListModel,
      ),
    );
    // Act
    await storyCubit.getRecommendedStories();

    // Assert
    verify(mockStoryRepository.getRecommendedStories());
    expect(storyCubit.state.recommendedStories, isNotEmpty);
  });
}
