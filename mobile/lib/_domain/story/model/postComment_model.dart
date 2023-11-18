import 'package:busenet/busenet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'postComment_model.freezed.dart';
part 'postComment_model.g.dart';

@freezed
class PostCommentModel extends BaseEntity<PostCommentModel>
    with _$PostCommentModel {
  const factory PostCommentModel({
    int? storyId,
    String? commentText,
  }) = _PostCommentModel;
  const PostCommentModel._();
  factory PostCommentModel.initial() => const PostCommentModel();
  factory PostCommentModel.fromJson(Map<String, dynamic> data) =>
      _$PostCommentModelFromJson(data);

  @override
  PostCommentModel fromJson(dynamic data) =>
      PostCommentModel.fromJson(data as Map<String, dynamic>);
}
