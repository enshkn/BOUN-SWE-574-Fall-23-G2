// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AddStoryRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AddStoryView(),
      );
    },
    AppRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AppView(),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ForgotPasswordView(),
      );
    },
    HomeTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeTabView(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeView(),
      );
    },
    LikedStoiresRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LikedStoiresView(),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginView(),
      );
    },
    MyStoriesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MyStoriesView(),
      );
    },
    NearbyTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NearbyTabView(),
      );
    },
    NearbyRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NearbyView(),
      );
    },
    OnboardingRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OnboardingView(),
      );
    },
    ProfileTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileTabView(),
      );
    },
    ProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileView(),
      );
    },
    RecommendedTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RecommendedTabView(),
      );
    },
    RecommendedRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RecommendedView(),
      );
    },
    RegisterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterView(),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashView(),
      );
    },
    StoryDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<StoryDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: StoryDetailsView(
          model: args.model,
          key: args.key,
          leadBackHome: args.leadBackHome,
        ),
      );
    },
    TimelineTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TimelineTabView(),
      );
    },
    TimelineRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TimelineView(),
      );
    },
  };
}

/// generated route for
/// [AddStoryView]
class AddStoryRoute extends PageRouteInfo<void> {
  const AddStoryRoute({List<PageRouteInfo>? children})
      : super(
          AddStoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'AddStoryRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AppView]
class AppRoute extends PageRouteInfo<void> {
  const AppRoute({List<PageRouteInfo>? children})
      : super(
          AppRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ForgotPasswordView]
class ForgotPasswordRoute extends PageRouteInfo<void> {
  const ForgotPasswordRoute({List<PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomeTabView]
class HomeTabRoute extends PageRouteInfo<void> {
  const HomeTabRoute({List<PageRouteInfo>? children})
      : super(
          HomeTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeTabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomeView]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LikedStoiresView]
class LikedStoiresRoute extends PageRouteInfo<void> {
  const LikedStoiresRoute({List<PageRouteInfo>? children})
      : super(
          LikedStoiresRoute.name,
          initialChildren: children,
        );

  static const String name = 'LikedStoiresRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginView]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MyStoriesView]
class MyStoriesRoute extends PageRouteInfo<void> {
  const MyStoriesRoute({List<PageRouteInfo>? children})
      : super(
          MyStoriesRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyStoriesRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NearbyTabView]
class NearbyTabRoute extends PageRouteInfo<void> {
  const NearbyTabRoute({List<PageRouteInfo>? children})
      : super(
          NearbyTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'NearbyTabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NearbyView]
class NearbyRoute extends PageRouteInfo<void> {
  const NearbyRoute({List<PageRouteInfo>? children})
      : super(
          NearbyRoute.name,
          initialChildren: children,
        );

  static const String name = 'NearbyRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OnboardingView]
class OnboardingRoute extends PageRouteInfo<void> {
  const OnboardingRoute({List<PageRouteInfo>? children})
      : super(
          OnboardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileTabView]
class ProfileTabRoute extends PageRouteInfo<void> {
  const ProfileTabRoute({List<PageRouteInfo>? children})
      : super(
          ProfileTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileTabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfileView]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RecommendedTabView]
class RecommendedTabRoute extends PageRouteInfo<void> {
  const RecommendedTabRoute({List<PageRouteInfo>? children})
      : super(
          RecommendedTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'RecommendedTabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RecommendedView]
class RecommendedRoute extends PageRouteInfo<void> {
  const RecommendedRoute({List<PageRouteInfo>? children})
      : super(
          RecommendedRoute.name,
          initialChildren: children,
        );

  static const String name = 'RecommendedRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegisterView]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashView]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [StoryDetailsView]
class StoryDetailsRoute extends PageRouteInfo<StoryDetailsRouteArgs> {
  StoryDetailsRoute({
    required StoryModel model,
    Key? key,
    bool leadBackHome = false,
    List<PageRouteInfo>? children,
  }) : super(
          StoryDetailsRoute.name,
          args: StoryDetailsRouteArgs(
            model: model,
            key: key,
            leadBackHome: leadBackHome,
          ),
          initialChildren: children,
        );

  static const String name = 'StoryDetailsRoute';

  static const PageInfo<StoryDetailsRouteArgs> page =
      PageInfo<StoryDetailsRouteArgs>(name);
}

class StoryDetailsRouteArgs {
  const StoryDetailsRouteArgs({
    required this.model,
    this.key,
    this.leadBackHome = false,
  });

  final StoryModel model;

  final Key? key;

  final bool leadBackHome;

  @override
  String toString() {
    return 'StoryDetailsRouteArgs{model: $model, key: $key, leadBackHome: $leadBackHome}';
  }
}

/// generated route for
/// [TimelineTabView]
class TimelineTabRoute extends PageRouteInfo<void> {
  const TimelineTabRoute({List<PageRouteInfo>? children})
      : super(
          TimelineTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'TimelineTabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TimelineView]
class TimelineRoute extends PageRouteInfo<void> {
  const TimelineRoute({List<PageRouteInfo>? children})
      : super(
          TimelineRoute.name,
          initialChildren: children,
        );

  static const String name = 'TimelineRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
