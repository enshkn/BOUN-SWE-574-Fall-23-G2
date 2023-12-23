import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:swe/_application/auth/auth_cubit.dart';
import 'package:swe/_application/auth/auth_state.dart';
import 'package:swe/_application/session/session_cubit.dart';
import 'package:swe/_core/utility/record_utils.dart';
import 'package:swe/_domain/auth/i_auth_repository.dart';
import 'package:swe/_domain/auth/model/register_model.dart';
import 'package:swe/_domain/auth/model/user.dart';
import 'package:swe/_domain/profile/i_profile_repository.dart';

import '../profile/profile_cubit_test.mocks.dart';

const dependecies = [
  IProfileRepository,
  User,
  IAuthRepository,
  BuildContext,
];
@GenerateMocks(dependecies)
void main() {
  late IProfileRepository mockProfileRepository;
  late IAuthRepository mockAuthRepository;
  late AuthCubit authCubit;
  late SessionCubit sessionCubit;
  late BuildContext buildContext;

  setUp(() {
    mockAuthRepository = MockIAuthRepository();
    authCubit = AuthCubit(mockAuthRepository);
    sessionCubit = SessionCubit();
    buildContext = MockBuildContext();
  });

  group(AuthCubit, () {
    test('initial state should be correct', () {
      expect(authCubit.state, AuthState.initial());
    });

    test('Login scenerio', () async {
      const username = 'testuser';
      const password = 'testpassword';

      final widget = MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            authCubit.setContext(context);
            when(mockAuthRepository.login(username, password)).thenAnswer(
              (_) async => right(const User(id: 1, username: username)),
            );

            authCubit.login(username: username, password: password);
            verify(mockAuthRepository.login(username, password));

            return const Text('true');
          },
        ),
      );
    });

    test('register scenerio ', () async {
      const username = 'testuser';
      const email = 'testuser@example.com';
      const password = 'testpassword';

      final widget = MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            when(
              mockAuthRepository.register(
                const RegisterModel(
                  username: username,
                  email: email,
                  password: password,
                ),
              ),
            ).thenAnswer((_) async => right(true));

            authCubit.register(
              username: username,
              email: email,
              password: password,
            );

            verify(
              mockAuthRepository.register(
                const RegisterModel(
                  username: username,
                  email: email,
                  password: password,
                ),
              ),
            );
            return const Text('true');
          },
        ),
      );
    });
  });
}
