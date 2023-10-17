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

  void changeBottomTab(BottomTabs tab) {
    safeEmit(state.copyWith(bottomTab: tab));

    changeTab?.call(tab.value);
  }

  @override
  void setLoading(bool loading) {
    safeEmit(state.copyWith(isLoading: loading));
  }
}
