import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:swe/_application/core/base_state.dart';

import '../../_domain/auth/model/user.dart';

part 'session_state.freezed.dart';

@freezed
class SessionState extends BaseState with _$SessionState {
  const factory SessionState({
    @Default(false) bool isLoading,
    User? authUser,
    @Default(true) bool isFirstLogin,
  }) = _SessionState;
  const SessionState._();

  factory SessionState.initial() => const SessionState();
  bool get isUserAuthenticated => authUser != null;
}
