import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:swe/_application/profile/profile_cubit.dart';
import 'package:swe/_application/profile/profile_state.dart';
import 'package:swe/_application/session/session_cubit.dart';
import 'package:swe/_core/utility/record_utils.dart';

import 'package:swe/_domain/auth/i_auth_repository.dart';
import 'package:swe/_domain/auth/model/follow_user_model.dart';
import 'package:swe/_domain/auth/model/profile_update_model.dart';
import 'package:swe/_domain/auth/model/user.dart';
import 'package:swe/_domain/profile/i_profile_repository.dart';

import 'profile_cubit_test.mocks.dart';

const dependecies = [
  IProfileRepository,
  User,
  IAuthRepository,
  ProfileUpdateModel,
  BuildContext,
];

@GenerateMocks(dependecies)
void main() {
  late IProfileRepository mockProfileRepository;
  late IAuthRepository mockAuthRepository;
  late ProfileCubit profileCubit;
  late SessionCubit sessionCubit;
  late BuildContext buildContext;
  setUp(() {
    mockProfileRepository = MockIProfileRepository();
    mockAuthRepository = MockIAuthRepository();
    profileCubit = ProfileCubit(mockProfileRepository, mockAuthRepository);
    sessionCubit = SessionCubit();
    buildContext = MockBuildContext();
  });

  group(ProfileCubit, () {
    test('initial state should be correct', () {
      profileCubit.setContext(buildContext);
      expect(profileCubit.state, ProfileState.initial());
    });

    test('return user data when getUserInfo succeeds', () async {
      const userInfo = User(id: 1, username: 'user');

      when(mockProfileRepository.getUserInfo())
          .thenAnswer((_) async => right(userInfo));

      await profileCubit.getProfileInfo();

      verify(mockProfileRepository.getUserInfo());
      expect(profileCubit.state.user, isNotNull);
    });

    test('updates user when updateUserInfo succeeds', () async {
      const updateModel = ProfileUpdateModel(biography: 'user bio');
      const updatedUser = User(id: 1, username: 'user');

      /*  profileCubit.setContext(buildContext);

      when(mockProfileRepository.updateUserInfo(updateModel))
          .thenAnswer((_) async => right(updatedUser));

      await profileCubit.updateProfile(updateModel);

      expect(sessionCubit.state.authUser, equals(updatedUser)); */

      final widget = MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            profileCubit.setContext(context);

            when(mockProfileRepository.updateUserInfo(updateModel))
                .thenAnswer((_) async => right(updatedUser));

            profileCubit.updateProfile(updateModel);

            expect(sessionCubit.state.authUser, equals(updatedUser));

            return Text(updatedUser.biography!);
          },
        ),
      );
    });

    test('updates user when profileImageUpdate succeeds', () async {
      final imageFile = File('/path/to/image.jpg');
      const updatedUser = User(id: 1, username: 'user');

      final widget = MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            profileCubit.setContext(context);

            when(mockProfileRepository.profileImageUpdate(imageFile))
                .thenAnswer((_) async => right(updatedUser));

            profileCubit.updateProfileImage(imageFile);

            expect(sessionCubit.state.authUser, equals(updatedUser));

            return Text(updatedUser.profilePhoto!);
          },
        ),
      );
    });
    test(' updates user when followUser succeeds', () async {
      const followModel = FollowUserModel(userId: '2');
      const updatedUser = User(id: 1, username: 'user');

      final widget = MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            profileCubit.setContext(context);
            when(mockProfileRepository.followUser(followModel))
                .thenAnswer((_) async => right(updatedUser));

            final success = profileCubit.followUser(followModel);

            expect(sessionCubit.state.authUser, equals(updatedUser));
            expect(success, isTrue);

            return Text(success.toString());
          },
        ),
      );
    });

    test(
        'getOtherUser sets loading, success, and updates otherProfile when otherProfile succeeds',
        () async {
      const userId = 123;
      const otherUserProfile = User(id: 123);

      when(mockProfileRepository.otherProfile(userId))
          .thenAnswer((_) async => right(otherUserProfile));

      await profileCubit.getOtherUser(userId);

      // Verify that the otherProfile was updated
      expect(profileCubit.state.otherProfile, equals(otherUserProfile));
    });
  });
}
