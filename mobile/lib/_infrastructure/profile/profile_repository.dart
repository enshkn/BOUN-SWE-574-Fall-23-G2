import 'package:busenet/busenet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:swe/_core/classes/typedefs.dart';
import 'package:swe/_core/utility/record_utils.dart';
import 'package:swe/_domain/auth/model/user.dart';
import 'package:swe/_domain/network/app_network_manager.dart';
import 'package:swe/_domain/network/network_paths.dart';
import 'package:swe/_domain/profile/i_profile_repository.dart';

@LazySingleton(as: IProfileRepository)
@immutable
class ProfileRepository implements IProfileRepository {
  final AppNetworkManager manager;
  const ProfileRepository(this.manager);

  @override
  EitherFuture<User> getUserInfo() async {
    final response = await manager.fetch<User, User>(
      NetworkPaths.profile,
      type: HttpTypes.get,
      parserModel: const User(),
    );

    switch (response.statusCode) {
      case 1:
        return right(response.entity as User);
      default:
        return left(response.errorType);
    }
  }
}
