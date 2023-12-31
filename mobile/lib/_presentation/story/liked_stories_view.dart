import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:swe/_application/session/session_cubit.dart';
import 'package:swe/_application/session/session_state.dart';
import 'package:swe/_application/story/story_cubit.dart';
import 'package:swe/_application/story/story_state.dart';
import 'package:swe/_core/widgets/base_loader.dart';
import 'package:swe/_core/widgets/base_scroll_view.dart';
import 'package:swe/_core/widgets/base_widgets.dart';
import 'package:swe/_domain/story/model/story_model.dart';
import 'package:swe/_presentation/_core/base_consumer.dart';
import 'package:swe/_presentation/_core/base_view.dart';
import 'package:swe/_presentation/_route/router.dart';
import 'package:swe/_presentation/widgets/base/base_header_title.dart';
import 'package:swe/_presentation/widgets/base/base_list_view.dart';
import 'package:swe/_presentation/widgets/card/story_card.dart';
import 'package:swe/_presentation/widgets/wrapper/favorite_wrapper.dart';

@RoutePage()
class LikedStoiresView extends StatefulWidget {
  const LikedStoiresView({super.key});

  @override
  State<LikedStoiresView> createState() => _LikedStoiresViewState();
}

class _LikedStoiresViewState extends State<LikedStoiresView> {
  @override
  List<StoryModel> likedStories = [];
  @override
  Widget build(BuildContext context) {
    return BaseConsumer<SessionCubit, SessionState>(
      context,
      builder: (context, sessionCubit, sessionState) {
        final user = sessionState.authUser;
        return BaseView<StoryCubit, StoryState>(
          onCubitReady: (cubit) async {
            cubit.setContext(context);
            cubit.init();
            await cubit.getLikedStories();
          },
          builder: (context, StoryCubit cubit, StoryState state) {
            likedStories = state.likedStories;
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                backgroundColor: Colors.grey.shade200,
                elevation: 0,
              ),
              body: BaseLoader(
                isLoading: state.isLoading,
                child: BaseScrollView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: BaseHeaderTitle(
                        title: 'Liked Stories',
                        onShowAllButtonPressed: () {},
                      ),
                    ),
                    if (state.likedStories.isNotEmpty)
                      SizedBox(
                        child: BaseListView<StoryModel>(
                          shrinkWrap: true,
                          items: state.likedStories,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (item) {
                            return FavoriteWrapper(
                              userId: user!.id!,
                              initialStateSave: item.savedBy != null
                                  ? item.savedBy!.contains(user.id)
                                  : false,
                              storyId: item.id,
                              builder: (
                                context,
                                addFavorite,
                                addSave,
                                isfavorite,
                                isSaved,
                                isLoading,
                                likeCount,
                              ) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  height: 450,
                                  child: GestureDetector(
                                    onTap: () {
                                      context.router.push(
                                        StoryDetailsRoute(
                                          model: item,
                                        ),
                                      );
                                    },
                                    child: StoryCard(
                                      storyModel: item,
                                      showFavouriteButton: false,
                                      onTagSearch: (label) async {
                                        await context.router.push(
                                          TagSearchRoute(
                                            tag: label,
                                          ),
                                        );
                                      },
                                      isSaved: isSaved,
                                      isSavedLoading: isLoading,
                                      onSavedTap: () async {
                                        await addSave(
                                          storyId: item.id,
                                        );
                                      },
                                      /*  likeCount: likeCount,
                                                                isFavorite: isfavorite,
                                                                isFavoriteLoading:
                                                                    isLoading,
                                                                onFavouriteTap: () async {
                                                                  await addFavorite(
                                                                    storyId: item.id,
                                                                  );
                                                                }, */
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    BaseWidgets.highGap,
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
