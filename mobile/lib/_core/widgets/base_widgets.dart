
import 'package:flutter/material.dart';
import '../extensions/context_extensions.dart';

class BaseWidgets {
  static Widget dynamicGap(double val) => SizedBox(height: val);
  static Widget get lowerGap => const SizedBox(height: 16);
  static Widget get normalGap => const SizedBox(height: 32);
  static Widget get highGap => const SizedBox(height: 64);

  static Widget dynamicDistance(double val) => SizedBox(width: val);
  static Widget get lowerDistance => const SizedBox(width: 16);
  static Widget get normalDistance => const SizedBox(width: 32);
  static Widget get highDistance => const SizedBox(width: 64);

  static Widget baseDivider(BuildContext context) => Divider(
    color: context.theme.colorScheme.secondary,
    thickness: 2,
  );
}