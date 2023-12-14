import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:swe/_application/session/session_cubit.dart';
import 'package:swe/_application/session/session_state.dart';
import 'package:swe/_application/story/story_cubit.dart';
import 'package:swe/_application/story/story_state.dart';
import 'package:swe/_common/style/text_styles.dart';
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
class MyStoriesView extends StatefulWidget {
  const MyStoriesView({super.key});

  @override
  State<MyStoriesView> createState() => _MyStoriesViewState();
}

class _MyStoriesViewState extends State<MyStoriesView> {
  final FocusNode _focusNode = FocusNode();
  List<StoryModel> myStories = [];
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
            await cubit.getMyStories();
          },
          builder: (context, StoryCubit cubit, StoryState state) {
            myStories = state.myStories;
            return RefreshIndicator(
              onRefresh: () async {
                await cubit.getMyStories();
              },
              child: Scaffold(
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
                      if (state.myStories.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: BaseHeaderTitle(
                            title: 'My Stories',
                            onShowAllButtonPressed: () {},
                          ),
                        ),
                      SizedBox(
                        child: BaseListView<StoryModel>(
                          shrinkWrap: true,
                          items: state.myStories,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (item) {
                            return FavoriteWrapper(
                              userId: user!.id!,
                              initialStateSave: item.savedBy!.contains(user.id),
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
                                      myStories: true,
                                      showFavouriteButton: false,
                                      onDeleteTap: () async {
                                        await cubit.deleteStory(item.id);
                                      },
                                      onTagSearch: (label) async {
                                        await context.router.push(
                                          TagSearchRoute(
                                            tag: label,
                                          ),
                                        );
                                      },
                                      onEditTap: () async {
                                        await context.router.push(
                                          AddStoryRoute(
                                            myStories: true,
                                            storyModel: item,
                                          ),
                                        );
                                      },
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
              ),
            );
          },
        );
      },
    );
  }
}
