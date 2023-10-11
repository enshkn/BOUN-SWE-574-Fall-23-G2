import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../extensions/context_extensions.dart';

class BaseCachedNetworkImage extends CachedNetworkImage {
  BaseCachedNetworkImage({
    required super.imageUrl,
    super.key,
    super.width,
    super.height,
    BoxFit? fit,
    Widget Function(BuildContext, String)? placeholder,
    Widget Function(BuildContext, String, dynamic)? errorWidget,
  }) : super(
          fit: fit ?? BoxFit.cover,
          placeholder: placeholder ??
              (context, url) => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
          errorWidget: errorWidget ??
              (context, url, error) =>
                  Icon(Icons.error, color: context.theme.primaryColor),
          cacheKey: 'image_$imageUrl',
          cacheManager: CacheManager(
            Config(
              'image_$imageUrl',
              stalePeriod: const Duration(days: 30),
            ),
          ),
        );
}
