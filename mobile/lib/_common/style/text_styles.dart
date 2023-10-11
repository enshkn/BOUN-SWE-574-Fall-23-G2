import 'package:flutter/material.dart';

class TextStyles extends TextStyle {
  const TextStyles.hugeTitle() : super(fontSize: 26, fontWeight: FontWeight.w700);
  const TextStyles.bigTitle() : super(fontSize: 20, fontWeight: FontWeight.w700);
  const TextStyles.title() : super(fontSize: 16, fontWeight: FontWeight.w700);
  const TextStyles.subtitle() : super(fontSize: 14, fontWeight: FontWeight.w400);
  const TextStyles.body() : super(fontSize: 15, fontWeight: FontWeight.w400);
  const TextStyles.caption() : super(fontSize: 10, fontWeight: FontWeight.w400);
  const TextStyles.button() : super(fontSize: 13, fontWeight: FontWeight.w700);
}
