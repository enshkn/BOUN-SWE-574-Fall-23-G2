import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swe/_core/utility/record_utils.dart';
import 'package:injectable/injectable.dart';

import '../../_domain/auth/i_auth_repository.dart';
import '../../_domain/auth/model/user.dart';
import '../../_presentation/_route/router.dart';
import '../core/base_cubit.dart';
import '../session/session_cubit.dart';
import 'auth_state.dart';

@injectable
final class AuthCubit extends BaseCubit<AuthState> {
  final IAuthRepository _authRepository;
  AuthCubit(this._authRepository) : super(AuthState.initial());

  Future<void> login({required String email, required String password}) async {
    setLoading(true);
    final result = await _authRepository.login(email, password);
    setLoading(false);
    result.fold(
      (failure) => showNotification(failure?.message ?? '-', isError: true),
      (user) {
        updateSessionUser(user);
        context.router.replaceAll([const AppRoute()]);
      },
    );
  }

  void updateSessionUser(User? user) {
    final sessionCubit = context.read<SessionCubit>();
    sessionCubit.updateUser(user);
  }

  @override
  void setLoading(bool loading) {
    safeEmit(state.copyWith(isLoading: loading));
  }
}
