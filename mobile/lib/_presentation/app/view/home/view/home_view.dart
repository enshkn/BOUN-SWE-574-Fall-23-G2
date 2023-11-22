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

  late TabController _tabController;
  int currnetIndex = 0;
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
                child: Column(
                  children: [
                    BaseWidgets.lowerGap,
                    buildTabs(context),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          RefreshIndicator(
                            onRefresh: () async {
                              await cubit.getFallowedStories();
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
                                        initialState:
                                            item.likes!.contains(user!.id),
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
                                          initialState:
                                              item.likes!.contains(user!.id),
                                          builder: (
                                            context,
                                            addFavorite,
                                            isfavorite,
                                            isLoading,
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
                                                      leadBackHome: true,
                                                    ),
                                                  );
                                                },
                                                child: StoryCard(
                                                  storyModel: item,
                                                  isFavorite: isfavorite,
                                                  isFavoriteLoading: isLoading,
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
