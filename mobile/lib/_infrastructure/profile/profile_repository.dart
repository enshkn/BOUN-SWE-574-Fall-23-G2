import 'dart:io';

import 'package:busenet/busenet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:swe/_core/classes/typedefs.dart';
import 'package:swe/_core/utility/record_utils.dart';
import 'package:swe/_domain/auth/model/follow_user_model.dart';
import 'package:swe/_domain/auth/model/profile_update_model.dart';
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
      cachePolicy: CachePolicy.noCache,
    );

    switch (response.statusCode) {
      case 1:
        return right(response.entity as User);
      default:
        return left(response.errorType);
    }
  }

  @override
  EitherFuture<User> updateUserInfo(ProfileUpdateModel model) async {
    final response = await manager.fetch<User, User>(
      NetworkPaths.profileUpdate,
      type: HttpTypes.post,
      parserModel: const User(),
      data: model.toJson(),
      cachePolicy: CachePolicy.noCache,
    );

    switch (response.statusCode) {
      case 1:
        return right(response.entity as User);
      default:
        return left(response.errorType);
    }
  }

  @override
  EitherFuture<User> followUser(FollowUserModel model) async {
    final response = await manager.fetch<User, User>(
      NetworkPaths.followUser,
      type: HttpTypes.post,
      parserModel: const User(),
      cachePolicy: CachePolicy.noCache,
      data: model.toJson(),
    );

    switch (response.statusCode) {
      case 1:
        return right(response.entity as User);
      default:
        return left(response.errorType);
    }
  }

  @override
  EitherFuture<User> otherProfile(int id) async {
    final response = await manager.fetch<User, User>(
      '/api/user/$id',
      type: HttpTypes.get,
      parserModel: const User(),
      queryParameters: {
        'id': id,
      },
    );

    switch (response.statusCode) {
      case 1:
        return right(response.entity as User);
      default:
        return left(response.errorType);
    }
  }

  @override
  EitherFuture<User> profileImageUpdate(File file) async {
    final formData = FormData();

    formData.files.addAll([
      MapEntry('photo', await MultipartFile.fromFile(file.path)),
    ]);

    final response = await manager.fetch<User, User>(
      NetworkPaths.profileUpdateImage,
      type: HttpTypes.post,
      contentType: Headers.multipartFormDataContentType,
      parserModel: const User(),
      data: formData,
    );

    switch (response.statusCode) {
      case 1:
        return right(response.entity as User);
      default:
        return left(response.errorType);
    }
  }
}
