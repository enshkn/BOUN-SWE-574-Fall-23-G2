import 'package:busenet/busenet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:swe/_domain/story/model/story_model.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User extends BaseEntity<User> with _$User {
  const factory User({
    int? id,
    String? username,
    String? email,
    String? password,
    String? biography,
    String? token,
    List<User>? followers,
    List<User>? following,
    String? profilePhoto,
    List<int>? likedStories,
    List<StoryModel>? stories,
    String? createdAt,
  }) = _User;
  const User._();
  factory User.initial() => const User();
  factory User.fromJson(Map<String, dynamic> data) => _$UserFromJson(data);

  @override
  User fromJson(dynamic data) {
    return User.fromJson(data as Map<String, dynamic>);
  }
}
