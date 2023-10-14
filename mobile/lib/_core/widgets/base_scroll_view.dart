// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'custom_scroll_behaviour.dart';

class BaseScrollView extends StatelessWidget {
  final ScrollController? controller;
  final CrossAxisAlignment crossAxisAlignment;
  final List<Widget> children;
  const BaseScrollView({
    required this.children,
    super.key,
    this.controller,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: SingleChildScrollView(
        controller: controller,
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          children: children,
        ),
      ),
    );
  }
}
