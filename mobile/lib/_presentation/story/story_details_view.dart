import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:swe/_application/story/story_cubit.dart';
import 'package:swe/_application/story/story_state.dart';
import 'package:swe/_common/style/text_styles.dart';
import 'package:swe/_core/extensions/string_extensions.dart';
import 'package:swe/_core/widgets/base_scroll_view.dart';
import 'package:swe/_core/widgets/base_widgets.dart';
import 'package:swe/_domain/story/model/story_model.dart';
import 'package:swe/_presentation/_core/base_view.dart';
import 'package:swe/_presentation/widgets/appBar/customAppBar.dart';
import 'package:swe/_presentation/widgets/base/base_list_view.dart';
import 'package:swe/_presentation/widgets/card/button_card.dart';
import 'package:swe/_presentation/widgets/icon_with_label.dart';

@RoutePage()
class StoryDetailsView extends StatefulWidget {
  final StoryModel model;
  const StoryDetailsView({required this.model, super.key});

  @override
  State<StoryDetailsView> createState() => _StoryDetailsViewState();
}

class _StoryDetailsViewState extends State<StoryDetailsView> {
  String startTimeStamp = '';
  String endTimeStamp = '';
  late final ExpansionTileController controller;
  late final ExpansionTileController controller2;

  @override
  void initState() {
    startTimeStamp =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.model.startTimeStamp!);
    endTimeStamp =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.model.endTimeStamp!);
    controller = ExpansionTileController();
    controller2 = ExpansionTileController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.model.text;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        context,
        title: widget.model.title,
      ),
      body: BaseView<StoryCubit, StoryState>(
        builder: (context, cubit, state) {
          return SafeArea(
            child: BaseScrollView(
              children: [
                buildContent(
                  context,
                  text,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildContent(
    BuildContext context,
    String text,
  ) {
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
                  buildFavourite(false, widget.model.likes!.length.toString()),
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
                    'Start Time: $startTimeStamp',
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
                    'End Time: $endTimeStamp',
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

  Widget buildFavourite(
    bool isFavorite,
    String likeCount,
  ) {
    return SizedBox(
      width: 50,
      height: 30,
      child: Center(
        child: Row(
          children: [
            ButtonCard(
              minScale: 0.8,
              onPressed: () {},
              child: Icon(
                Icons.favorite,
                color: isFavorite ? Colors.red : Colors.grey,
                size: 28,
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              likeCount ?? '0',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
