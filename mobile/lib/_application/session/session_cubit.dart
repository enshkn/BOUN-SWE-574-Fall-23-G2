import 'package:injectable/injectable.dart';

import '../../_domain/auth/model/user.dart';
import '../core/base_cubit.dart';
import 'session_state.dart';

@injectable
final class SessionCubit extends BaseCubit<SessionState> {
  SessionCubit() : super(SessionState.initial());

  void init() {}

  void updateUser(User? user) {
    safeEmit(state.copyWith(authUser: user));
  }

  @override
  void setLoading(bool loading) {
    safeEmit(state.copyWith(isLoading: loading));
  }
}
