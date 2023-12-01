import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swe/_core/extensions/context_extensions.dart';
import 'package:swe/_core/extensions/string_extensions.dart';
import 'package:swe/core/localization/locale_keys.g.dart';

import '../../../_application/app/app_cubit.dart';
import '../../../_application/app/app_state.dart';
import '../../../_application/session/session_cubit.dart';
import '../../../_application/session/session_state.dart';
import '../../../_common/enums/bottom_tabs.dart';
import '../../_core/base_consumer.dart';
import '../../_route/router.dart';

@RoutePage()
class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late AppCubit appCubit;

  TabsRouter? tabsRouter;

  void _changeIndex(int index) {
    tabsRouter?.setActiveIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return BaseConsumer<AppCubit, AppState>(
      context,
      onCubitReady: (cubit) {
        appCubit = cubit;
        cubit.setContext(context);
        cubit.setFunction(_changeIndex);
      },
      builder: (context, appCubit, appState) {
        return AutoTabsRouter(
          lazyLoad: false,
          routes: const [
            HomeTabRoute(),
            RecommendedTabRoute(),
            NearbyTabRoute(),
            TimelineTabRoute(),
            SearchTabRoute(),
            ProfileTabRoute(),
          ],
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (context, child, animation) => FadeTransition(
            opacity: animation,
            // the passed child is technically our animated selected-tab page
            child: child,
          ),
          builder: (context, child) {
            tabsRouter = context.tabsRouter;
            return Scaffold(
              backgroundColor: Colors.white,
              body: child,
              bottomNavigationBar: buildBottomNavigationBar(
                tabsRouter!,
                appCubit,
                appState,
              ),
            );
          },
        );
      },
    );
  }

  Widget buildBottomNavigationBar(
    TabsRouter tabsRouter,
    AppCubit cubit,
    AppState state,
  ) {
    return BaseConsumer<SessionCubit, SessionState>(
      context,
      builder: (context, sessonCubit, sessionState) {
        final user = sessionState.authUser;
        final userLoggedIn = user != null;
        return DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.grey.shade100,
              selectedFontSize: 10.5,
              unselectedFontSize: 10.5,
              onTap: (index) {
                cubit.changeBottomTab(BottomTabs.fromValue(index));
              },
              currentIndex: tabsRouter.activeIndex,
              items: [
                _buidNavigationItem(
                  state,
                  context,
                  bottomTab: BottomTabs.home,
                  label: 'Home',
                  icon: Icon(
                    FontAwesomeIcons.houseChimney,
                    size: 20,
                    color: state.bottomTab == BottomTabs.home
                        ? context.appBarColor
                        : const Color(0xFF071F05).withOpacity(0.5),
                  ),
                  size: 30,
                ),
                _buidNavigationItem(
                  state,
                  context,
                  bottomTab: BottomTabs.recommended,
                  label: 'Recommended',
                  icon: Icon(
                    FontAwesomeIcons.inbox,
                    size: 20,
                    color: state.bottomTab == BottomTabs.recommended
                        ? context.appBarColor
                        : const Color(0xFF071F05).withOpacity(0.5),
                  ),
                ),
                _buidNavigationItem(
                  state,
                  context,
                  bottomTab: BottomTabs.nearby,
                  label: 'Nearby',
                  icon: Icon(
                    FontAwesomeIcons.locationPin,
                    size: 20,
                    color: state.bottomTab == BottomTabs.nearby
                        ? context.appBarColor
                        : const Color(0xFF071F05).withOpacity(0.5),
                  ),
                ),
                _buidNavigationItem(
                  state,
                  context,
                  bottomTab: BottomTabs.timeline,
                  label: 'Timeline',
                  icon: Icon(
                    FontAwesomeIcons.timeline,
                    size: 20,
                    color: state.bottomTab == BottomTabs.timeline
                        ? context.appBarColor
                        : const Color(0xFF071F05).withOpacity(0.5),
                  ),
                ),
                _buidNavigationItem(
                  state,
                  context,
                  bottomTab: BottomTabs.search,
                  label: 'Search',
                  icon: Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    size: 20,
                    color: state.bottomTab == BottomTabs.search
                        ? context.appBarColor
                        : const Color(0xFF071F05).withOpacity(0.5),
                  ),
                ),
                _buidNavigationItem(
                  state,
                  context,
                  bottomTab: BottomTabs.profile,
                  label: 'Profile',
                  icon: Icon(
                    FontAwesomeIcons.person,
                    size: 20,
                    color: state.bottomTab == BottomTabs.profile
                        ? context.appBarColor
                        : const Color(0xFF071F05).withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _buidNavigationItem(
    AppState state,
    BuildContext context, {
    required String label,
    required BottomTabs bottomTab,
    String? svgName,
    Icon? icon,
    double? size,
  }) {
    return BottomNavigationBarItem(
      icon: SizedBox(
        height: 25,
        child: svgName == null
            ? icon
            : SvgPicture.asset(
                svgName.toSvg,
                width: size ?? 20,
                color: state.bottomTab == bottomTab
                    ? context.appBarColor
                    : const Color(0xFF071F05).withOpacity(0.5),
              ),
      ),
      label: label.tr(),
    );
  }
}
