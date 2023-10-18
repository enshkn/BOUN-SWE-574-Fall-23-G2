import 'package:flutter/material.dart';

import '../../_common/style/text_styles.dart';
import '../../_core/widgets/base_widgets.dart';

class IconWithLabel extends StatelessWidget {
  final Widget icon;
  final String label;
  final double spacing;
  final TextStyle? labelStyle;
  final bool specialIcon;
  final bool withExpanded;

  const IconWithLabel({
    required this.icon,
    required this.label,
    super.key,
    this.spacing = 16,
    this.labelStyle,
    this.specialIcon = false,
    this.withExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return withExpanded
        ? Row(
            children: [
              SizedBox(
                width: specialIcon ? 40 : 20,
                height: specialIcon ? 40 : 20,
                child: icon,
              ),
              BaseWidgets.dynamicDistance(spacing),
              Expanded(
                child: Text(
                  label,
                  style: labelStyle ?? const TextStyles.subtitle(),
                ),
              ),
            ],
          )
        : Row(
            children: [
              SizedBox(
                width: specialIcon ? 40 : 20,
                height: specialIcon ? 40 : 20,
                child: icon,
              ),
              BaseWidgets.dynamicDistance(spacing),
              Text(
                label,
                style: labelStyle ?? const TextStyles.subtitle(),
              ),
            ],
          );
  }
}
