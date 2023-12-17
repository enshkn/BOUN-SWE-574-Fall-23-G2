import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:swe/_application/session/session_cubit.dart';
import 'package:swe/_application/session/session_state.dart';
import 'package:swe/_application/story/story_cubit.dart';
import 'package:swe/_application/story/story_state.dart';
import 'package:swe/_common/style/text_styles.dart';
import 'package:swe/_core/extensions/context_extensions.dart';
import 'package:swe/_core/widgets/base_loader.dart';
import 'package:swe/_core/widgets/base_scroll_view.dart';
import 'package:swe/_core/widgets/base_widgets.dart';
import 'package:swe/_domain/story/model/story_model.dart';
import 'package:swe/_presentation/_core/base_consumer.dart';
import 'package:swe/_presentation/_core/base_view.dart';
import 'package:swe/_presentation/_route/router.dart';
import 'package:swe/_presentation/story/story_details_view.dart';
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

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  bool savePressedRecent = false;
  bool savePressedActivity = false;
  late TabController _tabController;
  int currnetIndex = 0;
  StoryModel? _dataFromSecondPage;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(tabListener);
  }

  void tabListener() {
    _tabController.addListener(() {
      if (currnetIndex != _tabController.index) {
        setState(() {
          currnetIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(tabListener);
    _tabController.dispose();
  }

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
            await cubit.getRecentStory();
          },
          builder: (context, StoryCubit cubit, StoryState state) {
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
              body: BaseLoader(
                isLoading: state.isLoading,
                child: Column(
                  children: [
                    BaseWidgets.lowerGap,
                    buildTabs(context),
                    if (user != null)
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            RefreshIndicator(
                              onRefresh: () async {
                                await cubit.getRecentStory();

                                savePressedRecent = false;
                              },
                              child: BaseScrollView(
                                children: [
                                  BaseWidgets.lowerGap,
                                  SizedBox(
                                    child: BaseListView<StoryModel>(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      items: state.recentStories,
                                      shrinkWrap: true,
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
                                              padding:
                                                  const EdgeInsets.symmetric(
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

                                                  /* likeCount: likeCount,
                                                        isFavorite: isfavorite,
                                                        isFavoriteLoading:
                                                            isLoading,
                                                        onFavouriteTap: () async {
                                                          await addFavorite(
                                                            storyId: item.id,
                                                          );
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
                            RefreshIndicator(
                              onRefresh: () async {
                                await cubit.getFallowedStories();
                                savePressedActivity = false;
                              },
                              child: BaseScrollView(
                                children: [
                                  BaseWidgets.lowerGap,
                                  if (state.fallowedStories != null &&
                                      state.fallowedStories!.isNotEmpty)
                                    SizedBox(
                                      child: BaseListView<StoryModel>(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        items: state.fallowedStories!,
                                        shrinkWrap: true,
                                        itemBuilder: (item) {
                                          return FavoriteWrapper(
                                            userId: user.id!,
                                            initialStateSave:
                                                item.savedBy != null
                                                    ? item.savedBy!
                                                        .contains(user.id)
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
                                                padding:
                                                    const EdgeInsets.symmetric(
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

                                                    /* likeCount: likeCount,
                                                        isFavorite: isfavorite,
                                                        isFavoriteLoading:
                                                            isLoading,
                                                        onFavouriteTap: () async {
                                                          await addFavorite(
                                                            storyId: item.id,
                                                          );
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
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildTabs(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: context.appBarColor,
        tabs: [
          Tab(
            child: Text(
              'Recent Stories',
              style: const TextStyles.title().copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(currnetIndex == 0 ? 1 : 0.4),
              ),
            ),
          ),
          Tab(
            child: Text(
              'Activity Feed',
              style: const TextStyles.title().copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(currnetIndex == 1 ? 1 : 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
