import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:swe/_application/story/story_cubit.dart';
import 'package:swe/_application/story/story_state.dart';
import 'package:swe/_core/widgets/base_loader.dart';
import 'package:swe/_core/widgets/base_scroll_view.dart';
import 'package:swe/_core/widgets/base_widgets.dart';
import 'package:swe/_domain/story/model/story_model.dart';
import 'package:swe/_presentation/_core/base_view.dart';
import 'package:swe/_presentation/_route/router.dart';
import 'package:swe/_presentation/widgets/base/base_header_title.dart';
import 'package:swe/_presentation/widgets/base/base_list_view.dart';
import 'package:swe/_presentation/widgets/card/story_card.dart';

@RoutePage()
class MyStoriesView extends StatefulWidget {
  const MyStoriesView({super.key});

  @override
  State<MyStoriesView> createState() => _MyStoriesViewState();
}

class _MyStoriesViewState extends State<MyStoriesView> {
  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return BaseView<StoryCubit, StoryState>(
      onCubitReady: (cubit) async {
        cubit.setContext(context);
        cubit.init();
        await cubit.getMyStories();
      },
      builder: (context, StoryCubit cubit, StoryState state) {
        return Scaffold(
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
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        height: 450,
                        child: GestureDetector(
                          onTap: () {
                            context.router.push(
                              StoryDetailsRoute(model: item),
                            );
                          },
                          child: StoryCard(
                            myStories: true,
                            storyModel: item,
                            onFavouriteTap: () {},
                          ),
                        ),
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
  }
}
