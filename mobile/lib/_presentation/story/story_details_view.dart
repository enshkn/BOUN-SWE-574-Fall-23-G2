import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:swe/_application/session/session_cubit.dart';
import 'package:swe/_application/session/session_state.dart';
import 'package:swe/_application/story/story_cubit.dart';
import 'package:swe/_application/story/story_state.dart';
import 'package:swe/_common/style/text_styles.dart';
import 'package:swe/_core/extensions/context_extensions.dart';
import 'package:swe/_core/extensions/string_extensions.dart';
import 'package:swe/_core/widgets/base_scroll_view.dart';
import 'package:swe/_core/widgets/base_widgets.dart';
import 'package:swe/_domain/auth/model/user.dart';
import 'package:swe/_domain/story/model/story_model.dart';
import 'package:swe/_presentation/_core/base_consumer.dart';
import 'package:swe/_presentation/_core/base_view.dart';
import 'package:swe/_presentation/_route/router.dart';
import 'package:swe/_presentation/widgets/appBar/customAppBar.dart';
import 'package:swe/_presentation/widgets/base/base_list_view.dart';
import 'package:swe/_presentation/widgets/card/button_card.dart';
import 'package:swe/_presentation/widgets/icon_with_label.dart';
import 'package:swe/_presentation/widgets/wrapper/favorite_wrapper.dart';

@RoutePage()
class StoryDetailsView extends StatefulWidget {
  final StoryModel model;
  final bool leadBackHome;
  const StoryDetailsView({
    required this.model,
    super.key,
    this.leadBackHome = false,
  });

  @override
  State<StoryDetailsView> createState() => _StoryDetailsViewState();
}

class _StoryDetailsViewState extends State<StoryDetailsView> {
  late final ExpansionTileController controller;
  late final ExpansionTileController controller2;
  late final StoryCubit cubit;
  bool addFavoriteTriggered = false;
  @override
  void initState() {
    controller = ExpansionTileController();
    controller2 = ExpansionTileController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.model.text;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        title: Text(
          widget.model.title,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (widget.leadBackHome) {
              context.router.push(const HomeRoute());
            } else {
              Navigator.pop(context);
            }
          },
          icon: Icon(
            Icons.arrow_back,
            color: context.appBarColor,
          ),
        ),
      ),
      body: BaseConsumer<SessionCubit, SessionState>(
        context,
        builder: (context, sessionCubit, sessionState) {
          final user = sessionState.authUser;
          return BaseView<StoryCubit, StoryState>(
            onCubitReady: (cubit) async {
              this.cubit = cubit;
            },
            builder: (context, cubit, state) {
              return SafeArea(
                child: BaseScrollView(
                  children: [
                    buildContent(
                      context,
                      text,
                      user!,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildContent(
    BuildContext context,
    String text,
    User user,
  ) {
    return FavoriteWrapper(
      initialState: widget.model.likes!.contains(user.id),
      builder: (
        context,
        addFavorite,
        isfavorite,
        isLoading,
      ) {
        var newlikes = widget.model.likes!.length;
        final initialState = widget.model.likes!.contains(user.id);

        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.model.likes != null)
                      SizedBox(
                        width: 50,
                        height: 30,
                        child: Center(
                          child: Row(
                            children: [
                              ButtonCard(
                                minScale: 0.8,
                                onPressed: () async {
                                  setState(() {
                                    addFavorite(storyId: widget.model.id);
                                    addFavoriteTriggered = true;
                                    newlikes = widget.model.likes!.length;
                                  });
                                },
                                child: Icon(
                                  Icons.favorite,
                                  color: isfavorite ? Colors.red : Colors.grey,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              if (addFavoriteTriggered)
                                Text(
                                  isfavorite & initialState
                                      ? (newlikes).toString()
                                      : isfavorite & !initialState
                                          ? (newlikes + 1).toString()
                                          : !isfavorite & initialState
                                              ? (newlikes - 1).toString()
                                              : (newlikes).toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              if (!addFavoriteTriggered)
                                Text(
                                  newlikes.toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                            ],
                          ),
                        ),
                      ),
                    IconWithLabel(
                      spacing: 8,
                      icon: const Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      label: widget.model.user!.username!,
                    ),
                  ],
                ),
              ),
              BaseWidgets.normalGap,
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  controller: controller,
                  title: const Text(
                    'Time Variants',
                  ),
                  children: <Widget>[
                    if (widget.model.startTimeStamp != null)
                      Text(
                        'Start Time: ${widget.model.startTimeStamp}',
                        style: const TextStyles.body().copyWith(
                          letterSpacing: 0.016,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                    BaseWidgets.lowerGap,
                    if (widget.model.endTimeStamp != null)
                      Text(
                        'End Time: ${widget.model.endTimeStamp}',
                        style: const TextStyles.body().copyWith(
                          letterSpacing: 0.016,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                    BaseWidgets.lowerGap,
                    if (widget.model.decade != null)
                      Text(
                        'Decade: ${widget.model.decade!}',
                        style: const TextStyles.body().copyWith(
                          letterSpacing: 0.016,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                    BaseWidgets.lowerGap,
                    if (widget.model.season != null)
                      Text(
                        'Season: ${widget.model.season!}',
                        style: const TextStyles.body().copyWith(
                          letterSpacing: 0.016,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                    BaseWidgets.lowerGap,
                  ],
                ),
              ),
              BaseWidgets.lowerGap,
              if (widget.model.locations != null)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    controller: controller2,
                    title: const Text('Locations'),
                    initiallyExpanded: true,
                    children: <Widget>[
                      BaseWidgets.lowerGap,
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: SizedBox(
                          height: widget.model.locations!.length * 60,
                          child: BaseListView(
                            physics: const NeverScrollableScrollPhysics(),
                            items: widget.model.locations!,
                            itemBuilder: (item) {
                              return Text(
                                item.locationName!.toLocation(),
                                style: const TextStyles.body().copyWith(
                                  letterSpacing: 0.016,
                                ),
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              BaseWidgets.lowerGap,
              if (widget.model.labels != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 60,
                    child: BaseListView(
                      scrollDirection: Axis.horizontal,
                      items: widget.model.labels!,
                      itemBuilder: (item) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Wrap(
                              children: [
                                _buildChip(item),
                                const SizedBox(
                                  width: 8,
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              const Divider(
                color: Colors.black,
              ),
              BaseWidgets.lowerGap,
              Text(
                widget.model.title,
                style: const TextStyles.title().copyWith(
                  letterSpacing: 0.016,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              BaseWidgets.lowerGap,
              SingleChildScrollView(
                child: Html(data: text),
              ),
              BaseWidgets.highGap,
            ],
          ),
        );
      },
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      labelPadding: const EdgeInsets.all(2),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.blue,
      elevation: 4,
      padding: const EdgeInsets.all(8),
    );
  }
}
