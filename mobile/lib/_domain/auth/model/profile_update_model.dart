import 'package:busenet/busenet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_update_model.freezed.dart';
part 'profile_update_model.g.dart';

@freezed
class ProfileUpdateModel extends BaseEntity<ProfileUpdateModel>
    with _$ProfileUpdateModel {
  const factory ProfileUpdateModel({
    String? biography,
  }) = _ProfileUpdateModel;
  const ProfileUpdateModel._();
  factory ProfileUpdateModel.initial() => const ProfileUpdateModel();
  factory ProfileUpdateModel.fromJson(Map<String, dynamic> data) =>
      _$ProfileUpdateModelFromJson(data);

  @override
  ProfileUpdateModel fromJson(dynamic data) =>
      ProfileUpdateModel.fromJson(data as Map<String, dynamic>);
}
