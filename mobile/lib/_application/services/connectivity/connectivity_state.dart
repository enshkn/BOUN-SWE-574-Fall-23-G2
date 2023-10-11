import 'package:swe/_application/core/base_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'connectivity_cubit.dart';

part 'connectivity_state.freezed.dart';

@freezed
class ConnectivityState extends BaseState with _$ConnectivityState {
  const factory ConnectivityState({
    @Default(false) bool isLoading,
    @Default(InternetStatus.disconnected) InternetStatus status,
  }) = _ConnectivityState;
  factory ConnectivityState.initial() => const ConnectivityState();
}
