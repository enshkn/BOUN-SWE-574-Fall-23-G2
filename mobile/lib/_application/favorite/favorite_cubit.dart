import 'package:injectable/injectable.dart';
import 'package:swe/_application/core/base_cubit.dart';
import 'package:swe/_application/favorite/favorite_state.dart';
import 'package:swe/_core/utility/record_utils.dart';
import 'package:swe/_domain/story/i_story_repository.dart';

@injectable
final class FavoriteCubit extends BaseCubit<FavoriteState> {
  final IStoryRepository _repository;
  FavoriteCubit(this._repository) : super(FavoriteState.initial());

  void init(bool isFavorite) {
    safeEmit(state.copyWith(isFavorite: isFavorite));
  }

  @override
  void setLoading(bool loading) {
    safeEmit(state.copyWith(isLoading: loading));
  }

  Future<void> getStoryLike(int storyId) async {
    setLoading(true);
    final result = await _repository.getStoryDetail(storyId);
    setLoading(false);
    result.fold(
      (failure) => showNotification(failure?.message ?? '', isError: true),
      (story) {
        safeEmit(
          state.copyWith(
            likeCount:
                story.likes!.isNotEmpty ? story.likes!.length.toString() : '0',
          ),
        );
      },
    );
  }

  Future<void> getLikedStories(int storyId) async {
    setLoading(true);
    final result = await _repository.getLikedStories();
    setLoading(false);
    result.fold(
      (failure) => showNotification(failure?.message ?? '', isError: true),
      (likedStories) {
        final status = likedStories.where((element) => element.id == storyId);
        final favorite = status.isNotEmpty ? true : false;
        safeEmit(
          state.copyWith(isFavorite: favorite),
        );
      },
    );
  }

  Future<(bool, bool?, String?)> addFavorite({required int storyId}) async {
    setLoading(true);
    final result = await _repository.addFavorite(itemId: storyId);
    setLoading(false);
    return result.fold(
      (failure) {
        safeEmit(state.copyWith(isFavorite: !state.isFavorite));
        return (false, null, '0');
      },
      (story) {
        safeEmit(
          state.copyWith(
            isFavorite: !state.isFavorite,
            likeCount:
                story.likes!.isNotEmpty ? story.likes!.length.toString() : '0',
          ),
        );
        return (true, state.isFavorite, state.likeCount);
      },
    );
  }
}
