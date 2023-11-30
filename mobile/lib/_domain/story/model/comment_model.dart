import 'package:busenet/busenet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:swe/_domain/auth/model/user.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

@freezed
class CommentModel extends BaseEntity<CommentModel> with _$CommentModel {
  const factory CommentModel({
    int? id,
    String? text,
    User? user,
    List<int>? likes,
    String? createdAt,
  }) = _CommentModel;
  const CommentModel._();
  factory CommentModel.initial() => const CommentModel();
  factory CommentModel.fromJson(Map<String, dynamic> data) =>
      _$CommentModelFromJson(data);

  @override
  CommentModel fromJson(dynamic data) =>
      CommentModel.fromJson(data as Map<String, dynamic>);
}
