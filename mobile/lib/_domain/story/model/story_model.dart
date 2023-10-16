import 'package:busenet/busenet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:swe/_domain/auth/model/user.dart';
import 'package:swe/_domain/story/model/comment_model.dart';
import 'package:swe/_domain/story/model/location_model.dart';

part 'story_model.freezed.dart';
part 'story_model.g.dart';

@freezed
class StoryModel extends BaseEntity<StoryModel> with _$StoryModel {
  factory StoryModel({
    @Default(0) int id,
    @Default('') String text,
    @Default('') String title,
    User? user,
    List<String>? labels,
    String? createdAt,
    String? season,
    String? decade,
    String? startTimeStamp,
    String? endTimeStamp,
    List<String>? comments,
    List<LocationModel>? locations,
    List<int>? likes,
  }) = _StoryModel;
  StoryModel._();
  factory StoryModel.initial() => StoryModel();
  factory StoryModel.sample() => StoryModel(
        id: 1,
        text: 'text',
        title: 'title',
      );
  factory StoryModel.fromJson(Map<String, dynamic> data) =>
      _$StoryModelFromJson(data);

  @override
  StoryModel fromJson(dynamic data) =>
      StoryModel.fromJson(data as Map<String, dynamic>);
}
