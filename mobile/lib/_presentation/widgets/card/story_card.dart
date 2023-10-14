import 'package:flutter/material.dart';
import 'package:swe/_common/style/text_styles.dart';
import 'package:swe/_core/widgets/base_cached_network_image.dart';
import 'package:swe/_core/widgets/base_widgets.dart';
import 'package:swe/_domain/story/model/story_model.dart';
import 'package:swe/_presentation/widgets/base/base_list_view.dart';
import 'package:swe/_presentation/widgets/card/button_card.dart';

class StoryCard extends StatelessWidget {
  final StoryModel storyModel;
  final void Function(StoryModel)? onTap;
  final VoidCallback? onFavouriteTap;
  final bool isFavorite;
  final bool isFavoriteLoading;
  final bool showFavouriteButton;
  const StoryCard({
    required this.storyModel,
    super.key,
    this.onTap,
    this.onFavouriteTap,
    this.showFavouriteButton = true,
    this.isFavorite = false,
    this.isFavoriteLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final text = storyModel.text;

    final imgRegex = RegExp(r'<img>(.*?)<\/img>');
    final Iterable<Match> matches = imgRegex.allMatches(text);
    var imgContent = '';
    for (final match in matches) {
      imgContent = match.group(1)!;
    }

    final locationName = storyModel.locations?[0].locationName;
    final firstSpaceIndex = text.indexOf(' ');
    String? parsedLocationName = '';
    if (firstSpaceIndex != -1) {
      parsedLocationName = locationName?.substring(firstSpaceIndex + 1).trim();
    }

    return Material(
      borderRadius: BorderRadius.circular(12),
      elevation: 6,
      child: Container(
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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            buildContent(context, imgContent, parsedLocationName),
            if (showFavouriteButton) buildFavourite(),
            buildUser(),
          ],
        ),
      ),
    );
  }

  Card buildContent(BuildContext context, String? image, String? location) {
    return Card(
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            child: Center(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(24),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: BaseCachedNetworkImage(
                    width: MediaQuery.of(context).size.width,
                    imageUrl: image == '' || image == null
                        ? 'https://picsum.photos/1600/900'
                        : image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          BaseWidgets.lowerGap,
          Text(
            storyModel.title,
            style: const TextStyles.title().copyWith(
              letterSpacing: 0.016,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          BaseWidgets.lowerGap,
          if (storyModel.locations != null)
            Text(
              location ?? '',
              style: const TextStyles.body().copyWith(
                letterSpacing: 0.016,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          BaseWidgets.lowerGap,
          if (storyModel.labels != null)
            SizedBox(
              height: 60,
              child: BaseListView(
                scrollDirection: Axis.horizontal,
                items: storyModel.labels!,
                itemBuilder: (item) {
                  return Row(
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
        ],
      ),
    );
  }

  Widget buildFavourite() {
    if (onFavouriteTap == null) return const SizedBox();

    return Positioned(
      bottom: 8,
      left: 8,
      child: SizedBox(
        width: 50,
        height: 30,
        child: Center(
          child: Row(
            children: [
              if (isFavoriteLoading)
                const CircularProgressIndicator.adaptive()
              else
                ButtonCard(
                  minScale: 0.8,
                  onPressed: () => onFavouriteTap?.call(),
                  child: Icon(
                    Icons.favorite,
                    color: isFavorite ? Colors.red : Colors.grey,
                    size: 32,
                  ),
                ),
              const SizedBox(
                width: 4,
              ),
              Text(storyModel.likes?.length.toString() ?? '0'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUser() {
    return Positioned(
      bottom: 8,
      right: 10,
      child: SizedBox(
        width: 90,
        height: 30,
        child: Center(
          child: Row(
            children: [
              const Icon(
                Icons.star,
                color: Colors.yellow,
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
