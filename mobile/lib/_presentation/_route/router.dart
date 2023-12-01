import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:swe/_domain/auth/model/user.dart';
import 'package:swe/_domain/story/model/story_model.dart';
import 'package:swe/_presentation/app/view/nearby/view/nearby.dart';
import 'package:swe/_presentation/app/view/profile/view/other_profile_view.dart';
import 'package:swe/_presentation/app/view/profile/view/profile_detail_view.dart';
import 'package:swe/_presentation/app/view/recommended/view/recommended_view.dart';
import 'package:swe/_presentation/app/view/search/search_view.dart';
import 'package:swe/_presentation/app/view/timeline/view/timeline_view.dart';
import 'package:swe/_presentation/story/add_story_view.dart';
import 'package:swe/_presentation/story/liked_stories_view.dart';
import 'package:swe/_presentation/story/my_stories_view.dart';
import 'package:swe/_presentation/story/story_details_view.dart';
import 'package:swe/_presentation/story/tag_search_view.dart';
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
    AutoRoute(path: RoutePaths.ADDSTORY, page: AddStoryRoute.page),
    AutoRoute(path: RoutePaths.TAGSEARCH, page: TagSearchRoute.page),
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
            AutoRoute(
              path: RoutePaths.OTHERPROFILE,
              page: OtherProfileRoute.page,
            ),
          ],
        ),
        AutoRoute(
          path: RoutePaths.RECOMMENDED,
          page: RecommendedTabRoute.page,
          children: [
            AutoRoute(path: '', page: RecommendedRoute.page),
            AutoRoute(
              path: RoutePaths.STORYDETAILS,
              page: StoryDetailsRoute.page,
            ),
            AutoRoute(
              path: RoutePaths.OTHERPROFILE,
              page: OtherProfileRoute.page,
            ),
          ],
        ),
        AutoRoute(
          path: RoutePaths.NEARBY,
          page: NearbyTabRoute.page,
          children: [
            AutoRoute(path: '', page: NearbyRoute.page),
            AutoRoute(
              path: RoutePaths.STORYDETAILS,
              page: StoryDetailsRoute.page,
            ),
            AutoRoute(
              path: RoutePaths.OTHERPROFILE,
              page: OtherProfileRoute.page,
            ),
          ],
        ),
        AutoRoute(
          path: RoutePaths.TIMELINE,
          page: TimelineTabRoute.page,
          children: [
            AutoRoute(path: '', page: TimelineRoute.page),
            AutoRoute(
              path: RoutePaths.STORYDETAILS,
              page: StoryDetailsRoute.page,
            ),
            AutoRoute(
              path: RoutePaths.OTHERPROFILE,
              page: OtherProfileRoute.page,
            ),
          ],
        ),
        AutoRoute(
          path: RoutePaths.SEARCH,
          page: SearchTabRoute.page,
          children: [
            AutoRoute(path: '', page: SearchRoute.page),
            AutoRoute(
              path: RoutePaths.STORYDETAILS,
              page: StoryDetailsRoute.page,
            ),
            AutoRoute(
              path: RoutePaths.OTHERPROFILE,
              page: OtherProfileRoute.page,
            ),
          ],
        ),
        AutoRoute(
          path: RoutePaths.PROFILE,
          page: ProfileTabRoute.page,
          children: [
            AutoRoute(path: '', page: ProfileRoute.page),
            AutoRoute(
              path: RoutePaths.PROFILEDETAIL,
              page: ProfileDetailsRoute.page,
            ),
            AutoRoute(
              path: RoutePaths.MYSTORIES,
              page: MyStoriesRoute.page,
            ),
            AutoRoute(
              path: RoutePaths.LIKEDSTORIES,
              page: LikedStoiresRoute.page,
            ),
            AutoRoute(
              path: RoutePaths.STORYDETAILS,
              page: StoryDetailsRoute.page,
            ),
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

@RoutePage()
class RecommendedTabView extends StatelessWidget {
  const RecommendedTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}

@RoutePage()
class NearbyTabView extends StatelessWidget {
  const NearbyTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}

@RoutePage()
class TimelineTabView extends StatelessWidget {
  const TimelineTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}

@RoutePage()
class SearchTabView extends StatelessWidget {
  const SearchTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
