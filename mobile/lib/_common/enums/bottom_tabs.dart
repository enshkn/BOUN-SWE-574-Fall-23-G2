import 'package:swe/_presentation/_route/router.dart';

enum BottomTabs {
  home(0),
  recommended(1),
  nearby(2),
  timeline(3),
  profile(4);

  const BottomTabs(this.value);
  final int value;

  static BottomTabs fromValue(int value) {
    return BottomTabs.values.firstWhere((e) => e.value == value);
  }

  String get getTabRoute {
    switch (this) {
      case BottomTabs.home:
        return HomeTabRoute.name;
      case BottomTabs.recommended:
        return RecommendedTabRoute.name;
      case BottomTabs.nearby:
        return NearbyTabRoute.name;
      case BottomTabs.timeline:
        return TimelineTabRoute.name;
      case BottomTabs.profile:
        return ProfileTabRoute.name;
    }
  }
}
