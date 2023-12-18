import 'dart:convert';
import 'dart:ffi';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:swe/_common/constants/default_image.dart';
import 'package:swe/_common/style/text_styles.dart';
import 'package:swe/_core/extensions/string_extensions.dart';
import 'package:swe/_core/widgets/base_widgets.dart';
import 'package:swe/_domain/story/model/story_model.dart';
import 'package:swe/_presentation/_route/router.dart';
import 'package:swe/_presentation/widgets/base/base_list_view.dart';
import 'package:swe/_presentation/widgets/card/button_card.dart';

class StoryCard extends StatelessWidget {
  final StoryModel storyModel;
  final void Function(StoryModel)? onTap;
  final void Function(String)? onTagSearch;
  final void Function()? onFavouriteTap;
  final void Function()? onSavedTap;
  final VoidCallback? onDeleteTap;
  final VoidCallback? onEditTap;

  final bool isFavorite;
  final bool isSaved;
  final bool isSavedLoading;
  final String likeCount;
  final bool isFavoriteLoading;
  final bool showFavouriteButton;
  final bool myStories;
  final bool isRecommended;
  const StoryCard({
    required this.storyModel,
    this.likeCount = '0',
    this.myStories = false,
    super.key,
    this.onTap,
    this.onFavouriteTap,
    this.showFavouriteButton = true,
    this.isFavorite = false,
    this.isFavoriteLoading = false,
    this.onDeleteTap,
    this.onTagSearch,
    this.onSavedTap,
    this.isSaved = false,
    this.isSavedLoading = false,
    this.onEditTap,
    this.isRecommended = false,
  });

  @override
  Widget build(BuildContext context) {
    String? imgurl;
    var noImage = true;
    if (myStories) {
      final text = storyModel.text;

      final document = parse(text);

      if (document.outerHtml.contains('<img>')) {
        final parsedImage = text.split('<img>');
        final secondParse = parsedImage[1].split('/>');
        final finalParse = secondParse[0];
        imgurl = finalParse;
        noImage = false;
      }
      if (document.outerHtml.contains('<img src=')) {
        final parsedImage = text.split('img src="');
        final secondParse = parsedImage[1].split('">');
        final finalParse = secondParse[0];
        imgurl = finalParse;
        noImage = false;
      }
    } else {
      imgurl = storyModel.picture;
      if (imgurl != null) {
        noImage = false;
      }
    }

    return Material(
      borderRadius: BorderRadius.circular(12),
      elevation: 6,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              children: [
                if (storyModel.createdAt != null)
                  Text(
                    storyModel.createdAt!,
                  ),
                if (storyModel.percentage != null)
                  Text(
                    storyModel.percentage!,
                  ),
              ],
            ),
            BaseWidgets.lowestGap,
            buildContent(context, imgurl, noImage),
            if (showFavouriteButton) buildFavourite(),
            if (myStories == false) buildSaved(),
            buildUser(context),
            if (myStories) buildDelete(),
            if (myStories) buildEdit(),
          ],
        ),
      ),
    );
  }

  Card buildContent(
    BuildContext context,
    String? imgUrl,
    bool noImage,
  ) {
    return Card(
      margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
      ),
      child: !noImage
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          imgUrl!,
                        ),
                      ),
                    ),
                  ),
                ),
                BaseWidgets.lowestGap,
                Text(
                  storyModel.title,
                  style: const TextStyles.title().copyWith(
                    letterSpacing: 0.016,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                //],
                BaseWidgets.lowestGap,
                if (storyModel.locations != null &&
                    storyModel.locations!.isNotEmpty)
                  Text(
                    storyModel.locations![0].locationName!.toLocation() ?? '',
                    style: const TextStyles.body().copyWith(
                      letterSpacing: 0.016,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                BaseWidgets.lowestGap,
                if (storyModel.labels != null)
                  SizedBox(
                    height: 60,
                    child: BaseListView(
                      scrollDirection: Axis.horizontal,
                      items: storyModel.labels!,
                      itemBuilder: (item) {
                        return GestureDetector(
                          onTap: () {
                            onTagSearch?.call(item);
                          },
                          child: Row(
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
                          ),
                        );
                      },
                    ),
                  ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BaseWidgets.lowestGap,
                Text(
                  storyModel.title,
                  style: const TextStyles.title().copyWith(
                    letterSpacing: 0.016,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                if (!myStories)
                  Text(
                    storyModel.text,
                    style: const TextStyles.body().copyWith(
                      letterSpacing: 0.016,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                BaseWidgets.lowestGap,
                if (storyModel.locations != null &&
                    storyModel.locations!.isNotEmpty)
                  Text(
                    storyModel.locations![0].locationName!.toLocation() ?? '',
                    style: const TextStyles.body().copyWith(
                      letterSpacing: 0.016,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                BaseWidgets.lowestGap,
                if (storyModel.labels != null)
                  SizedBox(
                    height: 60,
                    child: BaseListView(
                      scrollDirection: Axis.horizontal,
                      items: storyModel.labels!,
                      itemBuilder: (item) {
                        return GestureDetector(
                          onTap: () {
                            onTagSearch?.call(item);
                          },
                          child: Row(
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
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
    );
  }

  Widget buildFavourite() {
    return Positioned(
      bottom: 8,
      right: 6,
      child: SizedBox(
        width: 70,
        height: 30,
        child: Center(
          child: Row(
            children: [
              if (isFavoriteLoading)
                const CircularProgressIndicator.adaptive()
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 24,
                      ),
                      onPressed: () {
                        onFavouriteTap?.call();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        likeCount ?? '',
                        style: const TextStyles.body(),
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSaved() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: SizedBox(
        width: 50,
        height: 40,
        child: Center(
          child: Row(
            children: [
              if (isSavedLoading)
                const CircularProgressIndicator.adaptive()
              else
                IconButton(
                  icon: Icon(
                    Icons.collections_bookmark,
                    color: isSaved ? Colors.orange : Colors.grey,
                    size: 36,
                  ),
                  onPressed: () {
                    onSavedTap?.call();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUser(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 4,
      child: GestureDetector(
        onTap: () {
          context.router.push(OtherProfileRoute(profile: storyModel.user!));
        },
        child: SizedBox(
          width: 150,
          height: 30,
          child: Center(
            child: Row(
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.grey,
                  size: 32,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(storyModel.user?.username ?? ''),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDelete() {
    return Positioned(
      top: 8,
      right: 0,
      child: SizedBox(
        width: 52,
        height: 30,
        child: Center(
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  onDeleteTap?.call();
                },
                icon: const Icon(
                  Icons.delete,
                  size: 32,
                  color: Colors.red,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEdit() {
    return Positioned(
      top: 8,
      left: 0,
      child: SizedBox(
        width: 52,
        height: 30,
        child: Center(
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  onEditTap?.call();
                },
                icon: const Icon(
                  Icons.edit,
                  size: 32,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return GestureDetector(
      onTap: () {
        onTagSearch?.call(label);
      },
      child: Chip(
        labelPadding: const EdgeInsets.all(2),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
        elevation: 4,
        padding: const EdgeInsets.all(8),
      ),
    );
  }
}
