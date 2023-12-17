import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:swe/_application/session/session_cubit.dart';
import 'package:swe/_application/session/session_state.dart';
import 'package:swe/_application/story/story_cubit.dart';
import 'package:swe/_application/story/story_state.dart';
import 'package:swe/_core/widgets/base_scroll_view.dart';
import 'package:swe/_domain/story/model/story_model.dart';
import 'package:swe/_presentation/_core/base_consumer.dart';
import 'package:swe/_presentation/_core/base_view.dart';
import 'package:swe/_presentation/_route/router.dart';
import 'package:swe/_presentation/widgets/base/base_header_title.dart';
import 'package:swe/_presentation/widgets/base/base_list_view.dart';
import 'package:swe/_presentation/widgets/card/story_card.dart';
import 'package:swe/_presentation/widgets/wrapper/favorite_wrapper.dart';

@RoutePage()
class RecommendedView extends StatefulWidget {
  const RecommendedView({super.key});

  @override
  State<RecommendedView> createState() => _RecommendedViewState();
}

class _RecommendedViewState extends State<RecommendedView> {
  final FocusNode _focusNode = FocusNode();

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
            await cubit.getRecommendedStories();
          },
          builder: (context, cubit, state) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Image.asset(
                    'assets/images/2dutlukfinal.png',
                    fit: BoxFit.contain,
                  ),
                ),
                backgroundColor: Colors.white,
                elevation: 0,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: IconButton.outlined(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _focusNode.unfocus();
                          context.router.push(AddStoryRoute());
                        },
                      ),
                    ),
                  ),
                ],
              ),
              body: BaseScrollView(
                children: [
                  if (state.recommendedStories.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: BaseHeaderTitle(
                        title: 'Recommended Stories',
                        onShowAllButtonPressed: () {},
                      ),
                    ),
                  if (user != null)
                    SizedBox(
                      child: BaseListView<StoryModel>(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        items: state.recommendedStories,
                        itemBuilder: (item) {
                          return FavoriteWrapper(
                            userId: user.id!,
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
                ],
              ),
            );
          },
        );
      },
    );
  }
}
