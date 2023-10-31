import 'package:flutter/material.dart';

mixin FormPageViewMixin<T extends StatefulWidget> on State<T> {
  late PageController pageController;

  int currentPage = 0;
  int get maxPageCount => 4;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  void previousPage() {
    if (pageController.page == 0) return;

    pageController
        .previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    )
        .then((value) {
      updateCurrentPage(currentPage - 1);
    });
  }

  void updateCurrentPage(int page) {
    setState(() {
      currentPage = page;
      isLastPage = maxPageCount == currentPage - 1;
    });
  }

  void nextPage() {
    if (pageController.page == maxPageCount - 1) return;

    pageController
        .nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    )
        .then((value) {
      updateCurrentPage(currentPage + 1);
    });
  }

  void animateToPage(int page) {
    pageController
        .animateToPage(
      page,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
    )
        .then((value) {
      updateCurrentPage(page);
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
