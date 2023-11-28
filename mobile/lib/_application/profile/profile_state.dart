import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:swe/_application/core/base_state.dart';
import 'package:swe/_domain/auth/model/user.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState extends BaseState with _$ProfileState {
  const factory ProfileState({
    @Default(false) bool isLoading,
    User? user,
    User? otherProfile,
  }) = _ProfileState;
  factory ProfileState.initial() => const ProfileState();
}
