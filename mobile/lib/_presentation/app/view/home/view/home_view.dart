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
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
            await cubit.getFallowedStories();
          },
          builder: (context, StoryCubit cubit, StoryState state) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: SizedBox(
                  child: Center(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(24),
                      ),
                      child: Image.asset(
                        'assets/images/dutlukfinal_1.jpg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  'DutlukApp',
                  style: const TextStyle().copyWith(color: Colors.black),
                ),
                backgroundColor: Colors.white,
                elevation: 0,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: IconButton.outlined(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _focusNode.unfocus();
                          context.router.push(const AddStoryRoute());
                        },
                      ),
                    ),
                  ),
                ],
              ),
              body: BaseLoader(
                isLoading: state.isLoading,
                child: BaseScrollView(
                  children: [
                    /*  if (state.activityFeedStories.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: BaseHeaderTitle(
                          title: 'Recommended Feed',
                          showAllButton: true,
                          onShowAllButtonPressed: () {},
                        ),
                      ),
                      BaseCarouselSlider<StoryModel>.withIndicator(
                        autoPlayInterval: const Duration(seconds: 6),
                        height: 250,
                        viewportFraction: 1,
                        sliders: state.activityFeedStories,
                        itemBuilder: (model) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 4,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                context.router.push(
                                  StoryDetailsRoute(model: model),
                                );
                              },
                              child: RecommendedCard(
                                storyModel: model,
                                onFavouriteTap: () {},
                              ),
                            ),
                          );
                        },
                      ),
                      BaseWidgets.lowerGap,
                    ], */

                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: BaseHeaderTitle(
                        title: 'Activity Feed',
                        onShowAllButtonPressed: () {},
                      ),
                    ),
                    if (state.fallowedStories != null &&
                        state.fallowedStories!.isNotEmpty)
                      SizedBox(
                        child: BaseListView<StoryModel>(
                          physics: const NeverScrollableScrollPhysics(),
                          items: state.fallowedStories!,
                          shrinkWrap: true,
                          itemBuilder: (item) {
                            final likeCount = item.likes!.length;
                            return FavoriteWrapper(
                              initialState: item.likes!.contains(user!.id),
                              builder: (
                                context,
                                addFavorite,
                                isfavorite,
                                isLoading,
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
                                          leadBackHome: true,
                                        ),
                                      );
                                    },
                                    child: StoryCard(
                                      storyModel: item,
                                      isFavorite: isfavorite,
                                      isFavoriteLoading: isLoading,
                                      /*  onFavouriteTap: () {
                                        setState(() {
                                          addFavorite(storyId: item.id);
                                        });
                                      },  */
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    BaseWidgets.normalGap,
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
