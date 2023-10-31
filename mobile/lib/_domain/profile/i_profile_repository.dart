import 'package:swe/_core/classes/typedefs.dart';
import 'package:swe/_domain/auth/model/user.dart';

abstract interface class IProfileRepository {
  EitherFuture<User> getUserInfo();
}
