import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:swe/_domain/story/model/story_model.dart';
import 'package:swe/_presentation/story/story_details_view.dart';
import '../app/view/app_view.dart';
import '../app/view/home/view/home_view.dart';
import '../app/view/profile/view/profile_view.dart';
import '../auth/view/forgot_password/forgot_password_view.dart';
import '../auth/view/login/login_view.dart';
import '../auth/view/register/view/register_view.dart';
import '../onboarding/view/onboarding_view.dart';
import '../splash/view/splash_view.dart';
import 'route_paths.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends _$AppRouter {
  @override
  final List<AutoRoute> routes = [
    AutoRoute(path: RoutePaths.SPLASH, page: SplashRoute.page),
    AutoRoute(path: RoutePaths.ONBOARDING, page: OnboardingRoute.page),
    AutoRoute(path: RoutePaths.LOGIN, page: LoginRoute.page),
    AutoRoute(path: RoutePaths.REGISTER, page: RegisterRoute.page),
    AutoRoute(path: RoutePaths.FORGOT_PASSWORD, page: ForgotPasswordRoute.page),
    AutoRoute(
      path: RoutePaths.APP,
      page: AppRoute.page,
      children: [
        RedirectRoute(path: '', redirectTo: 'home'),
        AutoRoute(
          path: RoutePaths.HOME,
          page: HomeTabRoute.page,
          children: [
            AutoRoute(path: '', page: HomeRoute.page),
            AutoRoute(
              path: RoutePaths.STORYDETAILS,
              page: StoryDetailsRoute.page,
            ),
          ],
        ),
        AutoRoute(
          path: RoutePaths.PROFILE,
          page: ProfileTabRoute.page,
          children: [
            AutoRoute(path: '', page: ProfileRoute.page),
          ],
        ),
      ],
    ),
  ];
}

@RoutePage()
class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}

@RoutePage()
class ProfileTabView extends StatelessWidget {
  const ProfileTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
