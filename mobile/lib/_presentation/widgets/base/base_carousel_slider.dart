import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:swe/_core/widgets/base_widgets.dart';
import 'package:swe/_presentation/widgets/base/carousel_indicator.dart';

class BaseCarouselSlider<T> extends StatefulWidget {
  final List<T> sliders;
  final double height;
  final Widget Function(T model) itemBuilder;
  final double viewportFraction;
  final bool showIndicator;
  final Duration autoPlayInterval;
  //final Widget Function()? indicatorBuilder;

  const BaseCarouselSlider({
    required this.sliders,
    required this.itemBuilder,
    super.key,
    this.height = 400,
    this.viewportFraction = 0.8,
    this.autoPlayInterval = const Duration(seconds: 4),
  }) : showIndicator = false;

  const BaseCarouselSlider.withIndicator({
    required this.sliders,
    required this.itemBuilder,
    this.showIndicator = true,
    //required this.indicatorBuilder,
    super.key,
    this.height = 400,
    this.viewportFraction = 0.8,
    this.autoPlayInterval = const Duration(seconds: 4),
  });

  @override
  State<BaseCarouselSlider<T>> createState() => _BaseCarouselSliderState();
}

class _BaseCarouselSliderState<T> extends State<BaseCarouselSlider<T>> {
  late CarouselController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = CarouselController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider.builder(
          carouselController: _controller,
          options: CarouselOptions(
            autoPlayInterval: widget.autoPlayInterval,
            height: widget.height,
            autoPlay: true,
            onPageChanged: (index, _) {
              setState(() {
                _currentPage = index;
              });
            },
            viewportFraction: widget.viewportFraction,
          ),
          itemCount: widget.sliders.length,
          itemBuilder: (context, itemIndex, pageViewIndex) {
            final model = widget.sliders[itemIndex];
            return widget.itemBuilder(model);
          },
        ),
        BaseWidgets.lowerGap,
        if (widget.showIndicator)
          CarouselIndicator(
            itemCount: widget.sliders.length,
            currentIndex: _currentPage,
          ),
      ],
    );
  }
}
