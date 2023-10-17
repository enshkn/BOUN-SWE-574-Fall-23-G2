import 'package:freezed_annotation/freezed_annotation.dart';

import '../core/base_state.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState extends BaseState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isLoading,
  }) = _AuthState;
  factory AuthState.initial() => const AuthState();
}
