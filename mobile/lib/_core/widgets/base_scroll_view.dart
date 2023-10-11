// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'custom_scroll_behaviour.dart';

class BaseScrollView extends StatelessWidget {
  final Widget child;
  const BaseScrollView({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: child,
      ),
    );
  }
}
