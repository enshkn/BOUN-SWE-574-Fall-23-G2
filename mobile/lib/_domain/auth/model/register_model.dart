import 'package:busenet/busenet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_model.freezed.dart';
part 'register_model.g.dart';

@freezed
class RegisterModel extends BaseEntity<RegisterModel> with _$RegisterModel {
  const factory RegisterModel({
    required String username,
    required String email,
    required String password,
  }) = _RegisterModel;
  const RegisterModel._();
  factory RegisterModel.initial() => const RegisterModel(
        username: '',
        email: '',
        password: '',
      );
  factory RegisterModel.fromJson(Map<String, dynamic> data) =>
      _$RegisterModelFromJson(data);

  @override
  RegisterModel fromJson(dynamic data) =>
      RegisterModel.fromJson(data as Map<String, dynamic>);
}
