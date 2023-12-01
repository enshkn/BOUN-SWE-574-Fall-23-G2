import 'package:busenet/busenet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:swe/_application/core/base_state.dart';
part 'favorite_state.freezed.dart';

@freezed
class FavoriteState extends BaseState with _$FavoriteState {
  const factory FavoriteState({
    @Default(false) bool isLoading,
    @Default(false) bool isFavorite,
    @Default('O') String likeCount,
    Failure? failure,
  }) = _FavoriteState;
  factory FavoriteState.initial() => const FavoriteState();
}
