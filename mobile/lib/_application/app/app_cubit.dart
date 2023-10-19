import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:swe/_application/profile/profile_cubit.dart';
import 'package:swe/_application/profile/profile_cubit.dart';
import 'package:swe/_application/session/session_cubit.dart';
import 'package:swe/_presentation/_route/router.dart';

import '../../_common/enums/bottom_tabs.dart';
import '../core/base_cubit.dart';
import 'app_state.dart';

@lazySingleton
final class AppCubit extends BaseCubit<AppState> {
  AppCubit() : super(AppState.initial());

  List<int> histories = [];
  void Function(int index)? changeTab;

  void setFunction(
    void Function(int index) changeIndex,
  ) {
    changeTab = changeIndex;
  }

  Future<void> changeBottomTab(BottomTabs tab) async {
    /*   if (tab == state.bottomTab) {
      final canBack = context.router.canNavigateBack;
      final tabRouteName = tab.getTabRoute;
      if (canBack && tabRouteName.isNotEmpty) {
        final router = context.router
            .innerRouterOf(AppRoute.name)
            ?.innerRouterOf(tabRouteName);
        await router?.pop();
      }
    }
    if (tab == state.bottomTab) return; */

    safeEmit(state.copyWith(bottomTab: tab));
    changeTab!(tab.value);
  }

  @override
  void setLoading(bool loading) {
    safeEmit(state.copyWith(isLoading: loading));
  }
}
