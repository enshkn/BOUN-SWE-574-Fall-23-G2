import '../../_core/classes/typedefs.dart';
import 'model/user.dart';

abstract interface class IAuthRepository {
  EitherFuture<User> login(String email, String password);
}
