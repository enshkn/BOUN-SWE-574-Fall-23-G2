// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      id: json['id'] as int?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      biography: json['biography'] as String?,
      token: json['token'] as String?,
      followers: (json['followers'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      following: (json['following'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      profilePhoto: (json['profilePhoto'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'biography': instance.biography,
      'token': instance.token,
      'followers': instance.followers,
      'following': instance.following,
      'profilePhoto': instance.profilePhoto,
    };
