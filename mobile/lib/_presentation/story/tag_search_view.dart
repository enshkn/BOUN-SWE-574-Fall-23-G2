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
class TagSearchView extends StatefulWidget {
  final String tag;
  const TagSearchView({required this.tag, super.key});

  @override
  State<TagSearchView> createState() => _TagSearchViewState();
}

class _TagSearchViewState extends State<TagSearchView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<StoryCubit, StoryState>(
      onCubitReady: (cubit) async {
        cubit.init();
        cubit.setContext(context);
        await cubit.getTagSearchStories(widget.tag);
      },
      builder: (context, cubit, state) {
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
                if (state.tagSearchStories.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: BaseHeaderTitle(
                      title: 'Label Search Result',
                      onShowAllButtonPressed: () {},
                    ),
                  ),
                SizedBox(
                  child: BaseListView<StoryModel>(
                    shrinkWrap: true,
                    items: state.tagSearchStories,
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
                            storyModel: item,
                            showFavouriteButton: false,
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
