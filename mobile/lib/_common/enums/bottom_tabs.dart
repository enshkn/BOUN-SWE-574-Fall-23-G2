import 'package:swe/_presentation/_route/router.dart';

enum BottomTabs {
  home(0),
  sample(1),
  profile(2),
  other(3);

  const BottomTabs(this.value);
  final int value;

  static BottomTabs fromValue(int value) {
    return BottomTabs.values.firstWhere((e) => e.value == value);
  }

  /* String get getTabRoute {
    switch (this) {
      case BottomTabs.home:
        return HomeTabRoute.name;
      case BottomTabs.sample:
        return ProfileTabRoute.name;
    }
  } */
}
