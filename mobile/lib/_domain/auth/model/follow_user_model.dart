import 'package:busenet/busenet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'follow_user_model.freezed.dart';
part 'follow_user_model.g.dart';

@freezed
class FollowUserModel extends BaseEntity<FollowUserModel>
    with _$FollowUserModel {
  const factory FollowUserModel({
    String? userId,
  }) = _FollowUserModel;
  const FollowUserModel._();
  factory FollowUserModel.initial() => const FollowUserModel();
  factory FollowUserModel.fromJson(Map<String, dynamic> data) =>
      _$FollowUserModelFromJson(data);

  @override
  FollowUserModel fromJson(dynamic data) =>
      FollowUserModel.fromJson(data as Map<String, dynamic>);
}
