import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

mixin ScrollAnimMixin<T extends StatefulWidget> on State<T> {
  late ScrollController scrollController;

  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isVisible) return;
        setState(() {
          isVisible = false;
        });
      } else {
        if (isVisible) return;
        setState(() {
          isVisible = true;
        });
      }
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }
}
