import 'package:busenet/busenet.dart';
import 'package:flutter/material.dart';
import 'package:swe/_domain/network/app_network_manager.dart';
import 'package:injectable/injectable.dart';

import '../../_common/constants/hive_constants.dart';
import '../../_core/classes/typedefs.dart';
import '../../_core/storage/hive/i_cache_service.dart';
import '../../_core/utility/record_utils.dart';
import '../../_domain/auth/i_auth_repository.dart';
import '../../_domain/auth/model/user.dart';
import '../../_domain/cache/model/token_model.dart';
import '../../_domain/network/network_paths.dart';

@LazySingleton(as: IAuthRepository)
@immutable
class AuthRepository implements IAuthRepository {
  final AppNetworkManager manager;
  final ICacheManager<TokenModel> _cacheManager;
  const AuthRepository(
    this.manager,
    @Named(HiveConstants.configServiceKey) this._cacheManager,
  );

  @override
  EitherFuture<User> login(String email, String password) async {
    final response = await manager.fetch<User, User>(
      NetworkPaths.login,
      parserModel: const User(),
      type: HttpTypes.post,
      data: {
        'email': email,
        'password': password,
      },
    );

    switch (response.statusCode) {
      case 1:
        // - For SampleResponseModel
        // final status = response.status ?? false;
        // if (!status) return left(Failure(message: response.errorMessage));

        final user = response.data as User;

        final tokenModel = _cacheManager.getData();
        await _cacheManager.setData(
          tokenModel?.copyWith(accessToken: user.token) ??
              TokenModel(accessToken: user.token),
        );

        return right(user);
      default:
        return left(response.errorType);
    }
  }
}
