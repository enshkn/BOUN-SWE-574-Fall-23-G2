import 'dart:async';
import 'package:injectable/injectable.dart';
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
    safeEmit(state.copyWith(bottomTab: tab));
    changeTab!(tab.value);
  }

  @override
  void setLoading(bool loading) {
    safeEmit(state.copyWith(isLoading: loading));
  }
}
