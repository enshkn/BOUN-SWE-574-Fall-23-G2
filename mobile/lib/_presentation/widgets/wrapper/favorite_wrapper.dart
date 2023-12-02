import 'package:flutter/material.dart';
import 'package:swe/_application/favorite/favorite_cubit.dart';
import 'package:swe/_application/favorite/favorite_state.dart';
import 'package:swe/_application/story/story_cubit.dart';
import 'package:swe/_presentation/widgets/wrapper/favorite_type.dart';

import '../../../_presentation/_core/base_view.dart';

class FavoriteWrapper extends StatefulWidget {
  final bool initialState;
  final bool initialStateSave;
  final String initialLikeCount;
  final int storyId;
  final int userId;
  final Widget Function(
    BuildContext context,
    Future<(bool, bool?, String?)> Function({
      required int storyId,
    }) addFavorite,
    Future<
            (
              bool,
              bool?,
            )>
        Function({
      required int storyId,
    }) addSave,
    bool isFavorite,
    bool isSaved,
    bool isLoading,
    String likeCount,
  ) builder;
  const FavoriteWrapper({
    required this.builder,
    required this.storyId,
    required this.userId,
    this.initialStateSave = false,
    super.key,
    this.initialState = false,
    this.initialLikeCount = '0',
  });

  @override
  State<FavoriteWrapper> createState() => _FavoriteWrapperState();
}

class _FavoriteWrapperState extends State<FavoriteWrapper> {
  @override
  Widget build(BuildContext context) {
    return BaseView<FavoriteCubit, FavoriteState>(
      onCubitReady: (cubit) {
        cubit.setContext(context);

        cubit.getStoryDetail(widget.storyId, widget.userId);
      },
      builder: (context, FavoriteCubit cubit, FavoriteState state) =>
          widget.builder(
        context,
        cubit.addFavorite,
        cubit.addSave,
        state.isFavorite,
        state.isSaved,
        state.isLoading,
        state.likeCount,
      ),
    );
  }
}
