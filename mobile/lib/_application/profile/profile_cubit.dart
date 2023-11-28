import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:swe/_application/app/app_cubit.dart';
import 'package:swe/_application/core/base_cubit.dart';
import 'package:swe/_application/profile/profile_state.dart';
import 'package:swe/_application/session/session_cubit.dart';
import 'package:swe/_common/enums/bottom_tabs.dart';
import 'package:swe/_core/utility/record_utils.dart';
import 'package:swe/_domain/auth/i_auth_repository.dart';
import 'package:swe/_domain/auth/model/follow_user_model.dart';
import 'package:swe/_domain/auth/model/profile_update_model.dart';
import 'package:swe/_domain/profile/i_profile_repository.dart';
import 'package:swe/_presentation/_route/router.dart';

@injectable
final class ProfileCubit extends BaseCubit<ProfileState> {
  final IProfileRepository _profileRepository;
  final IAuthRepository _authRepository;

  ProfileCubit(this._profileRepository, this._authRepository)
      : super(ProfileState.initial());

  void init() {}

  @override
  void setLoading(bool loading) {
    safeEmit(state.copyWith(isLoading: loading));
  }

  Future<void> getProfileInfo() async {
    setLoading(true);
    final result = await _profileRepository.getUserInfo();
    setLoading(false);
    result.fold(
      (failure) => showNotification(failure?.message ?? '', isError: true),
      (data) {
        safeEmit(state.copyWith(user: data));
      },
    );
  }

  Future<bool> updateProfile(ProfileUpdateModel model) async {
    setLoading(true);
    final result = await _profileRepository.updateUserInfo(model);

    setLoading(false);
    return result.fold(
      (failure) {
        showNotification(failure?.message ?? '', isError: true);
        return false;
      },
      (data) {
        showNotification('Profile Updated.');
        final sessionCubit = context.read<SessionCubit>();
        sessionCubit.updateUser(data);
        //safeEmit(state.copyWith(user: data));
        return true;
      },
    );
  }

  Future<bool> updateProfileImage(File model) async {
    setLoading(true);
    final result = await _profileRepository.profileImageUpdate(model);

    setLoading(false);
    return result.fold(
      (failure) {
        showNotification(failure?.message ?? '', isError: true);
        return false;
      },
      (data) {
        final sessionCubit = context.read<SessionCubit>();
        sessionCubit.updateUser(data);
        return true;
      },
    );
  }

  Future<bool> followUser(FollowUserModel model) async {
    setLoading(true);
    final result = await _profileRepository.followUser(model);

    setLoading(false);
    return result.fold(
      (failure) {
        showNotification(failure?.message ?? '', isError: true);
        return false;
      },
      (data) {
        showNotification('User follow success');
        final sessionCubit = context.read<SessionCubit>();
        sessionCubit.updateUser(data);
        return true;
      },
    );
  }

  Future<void> getOtherUser(int id) async {
    setLoading(true);
    final result = await _profileRepository.otherProfile(id);
    setLoading(false);
    result.fold(
      (failure) => showNotification(failure?.message ?? '', isError: true),
      (data) {
        safeEmit(state.copyWith(otherProfile: data));
      },
    );
  }

  Future<void> logout() async {
    setLoading(true);
    await _authRepository.logout();
    setLoading(false);
    final appCubit = context.read<AppCubit>();
    await appCubit.changeBottomTab(BottomTabs.home);

    final sessionCubit = context.read<SessionCubit>();
    sessionCubit.updateUser(null);
    sessionCubit.setFirstLogin(true);
    await context.router.replaceAll([const LoginRoute()]);
  }
}
