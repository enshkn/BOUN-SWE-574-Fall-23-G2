import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:swe/_application/story/story_cubit.dart';
import 'package:swe/_application/story/story_state.dart';
import 'package:swe/_core/extensions/context_extensions.dart';
import 'package:swe/_core/widgets/base_cached_network_image.dart';
import 'package:swe/_core/widgets/base_loader.dart';
import 'package:swe/_core/widgets/base_scroll_view.dart';
import 'package:swe/_core/widgets/base_widgets.dart';
import 'package:swe/_domain/story/model/story_model.dart';
import 'package:swe/_presentation/_core/base_view.dart';
import 'package:swe/_presentation/widgets/base/base_carousel_slider.dart';
import 'package:swe/_presentation/widgets/base/base_header_title.dart';
import 'package:swe/_presentation/widgets/base/base_list_view.dart';
import 'package:swe/_presentation/widgets/card/recommended_card.dart';
import 'package:swe/_presentation/widgets/card/story_card.dart';

@RoutePage()
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<StoryCubit, StoryState>(
      onCubitReady: (cubit) async {
        cubit.setContext(context);
        cubit.init();
        await cubit.getActivityFeeed();
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
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: BaseLoader(
                  isLoading: state.isLoading,
                  child: BaseScrollView(
                    children: [
                      if (state.activityFeedStories.isNotEmpty) ...[
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
                                onTap: () {},
                                child: RecommendedCard(
                                  storyModel: model,
                                  onFavouriteTap: () {},
                                ),
                              ),
                            );
                          },
                        ),
                        BaseWidgets.lowerGap,
                      ],
                      ...[
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: BaseHeaderTitle(
                            title: 'Activity Feed',
                            onShowAllButtonPressed: () {},
                          ),
                        ),
                        SizedBox(
                          height: 450 * 10,
                          child: BaseListView<StoryModel>(
                            physics: const NeverScrollableScrollPhysics(),
                            items: List.generate(
                              10,
                              (index) => StoryModel.sample(),
                            ),
                            itemBuilder: (item) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                height: 450,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: StoryCard(
                                    storyModel: item,
                                    onFavouriteTap: () {},
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        BaseWidgets.normalGap,
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
