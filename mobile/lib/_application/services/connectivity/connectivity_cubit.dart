import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

import '../../core/base_cubit.dart';
import 'connectivity_state.dart';

enum InternetStatus { connected, disconnected }

@injectable
final class ConnectivityCubit extends BaseCubit<ConnectivityState> {
  final Connectivity _connectivity = Connectivity();
  ConnectivityCubit() : super(ConnectivityState.initial()) {
    init();
  }

  Future<void> init() async {
    _connectivity.onConnectivityChanged.listen(_onConnectivityChange);
    await _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      emit(state.copyWith(status: InternetStatus.disconnected));
    } else {
      emit(state.copyWith(status: InternetStatus.connected));
    }
  }

  void _onConnectivityChange(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      emit(state.copyWith(status: InternetStatus.disconnected));
    } else {
      emit(state.copyWith(status: InternetStatus.connected));
    }
  }
}
