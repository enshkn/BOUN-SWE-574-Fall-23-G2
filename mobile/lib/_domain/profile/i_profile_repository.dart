import 'package:swe/_core/classes/typedefs.dart';
import 'package:swe/_core/classes/typedefs.dart';
import 'package:swe/_domain/auth/model/user.dart';
import 'package:swe/_domain/story/model/story_model.dart';

abstract interface class IProfileRepository {
  EitherFuture<User> getUserInfo();
}
