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

  Future<(bool, bool?)> addFavorite({required int storyId}) async {
    setLoading(true);
    final result = await _repository.addFavorite(itemId: storyId);
    setLoading(false);
    return result.fold(
      (failure) {
        safeEmit(state.copyWith(isFavorite: !state.isFavorite));
        return (false, null);
      },
      (success) {
        safeEmit(state.copyWith(isFavorite: !state.isFavorite));
        return (true, state.isFavorite);
      },
    );
  }
}
