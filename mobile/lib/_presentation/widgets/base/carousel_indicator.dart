// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:swe/_core/extensions/context_extensions.dart';

class CarouselIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final Widget Function(int index)? indicatorBuilder;

  const CarouselIndicator({
    required this.itemCount,
    required this.currentIndex,
    this.indicatorBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) {
          if (indicatorBuilder != null) {
            return indicatorBuilder!(index);
          }
          return CarouselIndicatorItem(
            isActive: index == currentIndex,
          );
        },
      ),
    );
  }
}

class CarouselIndicatorItem extends StatelessWidget {
  final bool isActive;

  const CarouselIndicatorItem({
    required this.isActive,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      height: 3,
      width: isActive ? 21 : 15,
      decoration: BoxDecoration(
        color: isActive
            ? context.colors.secondary
            : context.colors.secondaryContainer,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}
