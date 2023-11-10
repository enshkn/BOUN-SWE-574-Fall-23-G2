import 'package:flutter/material.dart';
import 'package:swe/_application/favorite/favorite_cubit.dart';
import 'package:swe/_application/favorite/favorite_state.dart';
import 'package:swe/_application/story/story_cubit.dart';
import 'package:swe/_presentation/widgets/wrapper/favorite_type.dart';

import '../../../_presentation/_core/base_view.dart';

class FavoriteWrapper extends StatefulWidget {
  final bool initialState;
  final Widget Function(
    BuildContext context,
    Future<(bool, bool?)> Function({
      required int storyId,
    }) addFavorite,
    bool isFavorite,
    bool isLoading,
  ) builder;
  const FavoriteWrapper({
    required this.builder,
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
        cubit.init(widget.initialState);
      },
      builder: (context, FavoriteCubit cubit, FavoriteState state) =>
          widget.builder(
        context,
        cubit.addFavorite,
        state.isFavorite,
        state.isLoading,
      ),
    );
  }
}
