import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:swe/_common/style/text_styles.dart';
import 'package:swe/_core/extensions/context_extensions.dart';

import '../../../_application/splash/splash_cubit.dart';
import '../../../_application/splash/splash_state.dart';
import '../../_core/base_view.dart';

@RoutePage()
class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<SplashCubit, SplashState>(
      onCubitReady: (cubit) {
        cubit.setContext(context);
        cubit.init();
      },
      builder: (context, SplashCubit cubit, SplashState state) {
        return Scaffold(
          body: Center(
            child: Text(
              'StoryTeller',
              style: const TextStyles.hugeTitle()
                  .copyWith(letterSpacing: 0.4, color: context.appBarColor),
            ),
          ),
        );
      },
    );
  }
}
