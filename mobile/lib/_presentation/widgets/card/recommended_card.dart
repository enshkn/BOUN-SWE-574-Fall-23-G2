import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:swe/_common/constants/default_image.dart';
import 'package:swe/_common/style/text_styles.dart';
import 'package:swe/_core/extensions/string_extensions.dart';
import 'package:swe/_core/widgets/base_cached_network_image.dart';
import 'package:swe/_core/widgets/base_widgets.dart';
import 'package:swe/_domain/story/model/story_model.dart';
import 'package:swe/_presentation/widgets/base/base_list_view.dart';
import 'package:swe/_presentation/widgets/card/button_card.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'dart:convert';

class RecommendedCard extends StatelessWidget {
  final StoryModel storyModel;
  final void Function(StoryModel)? onTap;
  final VoidCallback? onFavouriteTap;
  final bool isFavorite;
  final bool isFavoriteLoading;
  final bool showFavouriteButton;
  const RecommendedCard({
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
    final document = parse(text);
    final link = document.querySelector('img');
    final noImage = link == null ? true : false;
    var uint8list =
        Uint8List.fromList(base64.decode(DefaultImage.defaultImage));
    if (!noImage) {
      final imageLink = link != null ? link.attributes['src'] : '';
      final imageBeforeParse = imageLink?.split('base64,');
      imageBeforeParse?[1].replaceAll(r'\', 'END.');
      final imageBeforeSecondParse = imageBeforeParse?[1].split(' END.');
      final imgUrl = imageBeforeSecondParse?[0];
      uint8list = Uint8List.fromList(base64.decode(imgUrl!));
    }

    return Material(
      borderRadius: BorderRadius.circular(12),
      elevation: 6,
      child: Container(
        width: 220,
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
            buildContent(context, uint8list, noImage),
          ],
        ),
      ),
    );
  }

  Card buildContent(
    BuildContext context,
    Uint8List? imageBytes,
    bool noImage,
  ) {
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
            width: MediaQuery.of(context).size.width * 0.4,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.memory(
                    imageBytes!,
                    fit: BoxFit.cover,
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
              storyModel.locations![0].locationName!.toLocation() ?? '',
              style: const TextStyles.body().copyWith(
                letterSpacing: 0.016,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
