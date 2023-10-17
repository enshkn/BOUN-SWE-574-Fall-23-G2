// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:swe/_presentation/widgets/base/custom_scroll_behaviour.dart';

enum BaseListViewType { list, grid, separated }

class BaseListView<T> extends StatelessWidget {
  final double? height;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final List<T> items;
  final Widget Function(T) itemBuilder;
  final Widget Function(T)? separatorBuilder;
  final bool shrinkWrap;
  final Axis scrollDirection;
  final bool isGrid;
  final int crossAxisCount;
  final double childAspectRatio;
  final BaseListViewType type;
  const BaseListView({
    required this.items,
    required this.itemBuilder,
    super.key,
    this.scrollDirection = Axis.vertical,
    this.controller,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.height,
    this.type = BaseListViewType.list,
    this.separatorBuilder,
  })  : assert(
          type != BaseListViewType.grid,
          '[BaseListView.grid] must be used for grid view',
        ),
        isGrid = false,
        crossAxisCount = 1,
        childAspectRatio = 1;

  const BaseListView.grid({
    required this.items,
    required this.itemBuilder,
    super.key,
    this.scrollDirection = Axis.vertical,
    this.controller,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.height,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.85,
  })  : isGrid = true,
        type = BaseListViewType.grid,
        separatorBuilder = null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: switch (type) {
          BaseListViewType.list => ListView.builder(
              scrollDirection: scrollDirection,
              physics: physics,
              controller: controller,
              padding: padding,
              shrinkWrap: shrinkWrap,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items.elementAt(index);
                return itemBuilder(item);
              },
            ),
          BaseListViewType.grid => GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              scrollDirection: scrollDirection,
              physics: physics,
              controller: controller,
              padding: padding,
              shrinkWrap: shrinkWrap,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items.elementAt(index);
                return itemBuilder(item);
              },
            ),
          BaseListViewType.separated => ListView.separated(
              scrollDirection: scrollDirection,
              physics: physics,
              controller: controller,
              padding: padding,
              shrinkWrap: shrinkWrap,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items.elementAt(index);
                return itemBuilder(item);
              },
              separatorBuilder: (context, index) {
                final item = items.elementAt(index);
                return separatorBuilder!(item);
              },
            ),
        },
      ),
    );
  }
}
