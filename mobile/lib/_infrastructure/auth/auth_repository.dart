import 'dart:math';

import 'package:busenet/busenet.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swe/_application/session/session_cubit.dart';
import 'package:swe/_core/extensions/string_extensions.dart';
import 'package:swe/_domain/auth/model/register_model.dart';
import 'package:swe/_domain/network/app_network_manager.dart';
import 'package:swe/_domain/network/model/app_failure.dart';
import 'package:swe/_infrastructure/cache/token_cache_service.dart';

import '../../_core/classes/typedefs.dart';
import '../../_core/storage/hive/i_cache_service.dart';
import '../../_core/utility/record_utils.dart';
import '../../_domain/auth/i_auth_repository.dart';
import '../../_domain/auth/model/user.dart';
import '../../_domain/cache/model/token_model.dart';
import '../../_domain/network/network_paths.dart';

@LazySingleton(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  final AppNetworkManager manager;
  final ICacheManager<TokenModel> _cacheManager;
  AuthRepository(
    this.manager,
    @Named.from(TokenCacheService) this._cacheManager,
  );

  @override
  EitherFuture<User> login(
    String username,
    String password,
  ) async {
    final response = await manager.fetch<User, User>(
      NetworkPaths.login,
      parserModel: const User(),
      type: HttpTypes.post,
      data: {
        'identifier': username,
        'password': password,
      },
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);

    switch (response.statusCode) {
      case 1:
        final status = response.success ?? false;
        if (!status) return left(AppFailure(message: response.message));

        final user = response.entity as User;

        if (user.token!.isEmpty || user.token == null) {
          return left(AppFailure(message: 'no token'));
        }

        final tokenModel = _cacheManager.getData();
        await _cacheManager.setData(
          tokenModel?.copyWith(accessToken: user.token) ??
              TokenModel(accessToken: user.token),
        );
        manager.addAuthorizationHeader(user.token!);
        manager.addCookieTokenHeader(user.token!);

        return right(user);
      default:
        return left(response.errorType);
    }
  }

  @override
  EitherFuture<bool> register(RegisterModel model) async {
    final response = await manager.fetch<NoResultResponse, NoResultResponse>(
      NetworkPaths.register,
      parserModel: NoResultResponse(),
      type: HttpTypes.post,
      data: model.toJson(),
    );

    switch (response.statusCode) {
      case 1:
        final status = response.success ?? false;
        if (!status) return left(AppFailure(message: response.message));

        return right(true);
      default:
        return left(response.errorType);
    }
  }

  @override
  EitherFuture<User> autoLogin() async {
    final tokenModel = _cacheManager.getData();
    if (tokenModel == null || tokenModel.accessToken.isNullOrEmpty) {
      return left(AppFailure(message: 'Token bulunamadı'));
    }

    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final password = prefs.getString('password');

    final response = await manager.fetch<User, User>(
      NetworkPaths.login,
      type: HttpTypes.post,
      parserModel: const User(),
      data: {
        'identifier': username,
        'password': password,
      },
    );

    switch (response.statusCode) {
      case 1:
        final status = response.success ?? false;
        if (!status) return left(AppFailure(message: response.message));

        final user =
            (response.entity as User).copyWith(token: tokenModel.accessToken);
        manager.addCookieTokenHeader(tokenModel.accessToken!);
        await _cacheManager.setData(
          tokenModel.copyWith(accessToken: user.token),
        );
        manager.addAuthorizationHeader(user.token!);
        return right(user);
      default:
        return left(response.errorType);
    }
  }

  @override
  EitherFuture<bool> logout() async {
    final response = await manager.fetch<NoResultResponse, NoResultResponse>(
      NetworkPaths.logout,
      type: HttpTypes.get,
      parserModel: NoResultResponse(),
    );

    switch (response.statusCode) {
      case 1:
        await _cacheManager.clearAll();
        manager.removeCookieTokenHeader();
        return right(true);
      default:
        return left(response.errorType);
    }
  }

  @override
  EitherFuture<bool> checkToken() async {
    final tokenModel = _cacheManager.getData();
    if (tokenModel != null) {
      if (tokenModel.accessToken != null) {
        manager.addAuthorizationHeader(tokenModel.accessToken!);
        manager.addCookieTokenHeader(tokenModel.accessToken!);
      }
    }
    final response = await manager.fetchPrimitive<bool, bool>(
      NetworkPaths.checkToken,
      type: HttpTypes.get,
    );
    switch (response.statusCode) {
      case 1:
        final status = response.entity as bool;
        if (status == true) {
          return right(true);
        } else {
          return right(false);
        }

      default:
        return left(response.errorType);
    }
  }
}
