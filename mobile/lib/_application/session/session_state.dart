import 'package:swe/_application/core/base_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../_domain/auth/model/user.dart';

part 'session_state.freezed.dart';

@freezed
class SessionState extends BaseState with _$SessionState {
  const factory SessionState({
    @Default(false) bool isLoading,
    User? authUser,
  }) = _SessionState;
  factory SessionState.initial() => const SessionState();
}
