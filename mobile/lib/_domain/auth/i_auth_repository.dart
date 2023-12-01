import 'package:swe/_domain/auth/model/register_model.dart';

import '../../_core/classes/typedefs.dart';
import 'model/user.dart';

abstract interface class IAuthRepository {
  EitherFuture<User> login(String username, String password);
  EitherFuture<bool> logout();
  EitherFuture<bool> register(RegisterModel model);
  EitherFuture<User> autoLogin();
  EitherFuture<bool> checkToken();
}
