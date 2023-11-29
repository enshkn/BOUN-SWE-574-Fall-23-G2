import 'package:flutter/material.dart';
import 'package:swe/_application/favorite/favorite_cubit.dart';
import 'package:swe/_application/favorite/favorite_state.dart';
import 'package:swe/_application/story/story_cubit.dart';
import 'package:swe/_presentation/widgets/wrapper/favorite_type.dart';

import '../../../_presentation/_core/base_view.dart';

class FavoriteWrapper extends StatefulWidget {
  final bool initialState;
  final int storyId;
  final Widget Function(
    BuildContext context,
    Future<(bool, bool?, String?)> Function({
      required int storyId,
    }) addFavorite,
    bool isFavorite,
    bool isLoading,
    String likeCount,
  ) builder;
  const FavoriteWrapper({
    required this.builder,
    required this.storyId,
    super.key,
    this.initialState = false,
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
        //cubit.init(widget.initialState);
        cubit.getStoryLike(widget.storyId);
        cubit.getLikedStories(widget.storyId);
      },
      builder: (context, FavoriteCubit cubit, FavoriteState state) =>
          widget.builder(
        context,
        cubit.addFavorite,
        state.isFavorite,
        state.isLoading,
        state.likeCount,
      ),
    );
  }
}
