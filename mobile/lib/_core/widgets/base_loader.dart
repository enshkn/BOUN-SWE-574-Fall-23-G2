import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../extensions/context_extensions.dart';

class BaseLoader extends StatelessWidget {
  const BaseLoader({super.key, required this.isLoading, required this.child});
  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          ColoredBox(
            color: Colors.black.withOpacity(0.4),
            child: Center(
              child: Lottie.asset(
                'assets/lottie/loading_circle.json',
                width: context.customWidthValue(0.35),
                height: context.customWidthValue(0.35),
              ),
            ),
          ),
      ],
    );
  }
}
