import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:swe/_core/extensions/context_extensions.dart';

import '../../../_common/style/text_styles.dart';
import '../../../_core/widgets/base_widgets.dart';

class BaseHeaderTitle extends StatelessWidget {
  final String title;
  final bool showAllButton;
  final VoidCallback? onShowAllButtonPressed;
  const BaseHeaderTitle({
    required this.title,
    super.key,
    this.showAllButton = false,
    this.onShowAllButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyles.bigTitle().copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (showAllButton)
          GestureDetector(
            onTap: onShowAllButtonPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'See More',
                  style: const TextStyles.subtitle().copyWith(
                    fontWeight: FontWeight.w900,
                    color: context.appBarColor,
                  ),
                ),
                BaseWidgets.dynamicDistance(5),
                Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: context.theme.primaryColor,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
