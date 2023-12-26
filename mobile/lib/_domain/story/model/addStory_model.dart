import 'package:busenet/busenet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:swe/_domain/story/model/location_model.dart';

part 'addStory_model.freezed.dart';
part 'addStory_model.g.dart';

@freezed
class AddStoryModel extends BaseEntity<AddStoryModel> with _$AddStoryModel {
  const factory AddStoryModel({
    String? text,
    String? title,
    List<String>? labels,
    String? season,
    String? decade,
    String? startTimeStamp,
    String? endTimeStamp,
    List<LocationModel>? locations,
    int? startHourFlag,
    int? endHourFlag,
    String? endDecade,
    int? startDateFlag,
    int? endDateFlag,
    String? timeType, //takes the value "time_point" or "time_interval";
    String?
        timeExpression, // takes the value "moment","day","month+season","year","decade" or "decade+season"
  }) = _AddStoryModel;
  const AddStoryModel._();
  factory AddStoryModel.initial() => const AddStoryModel();
  factory AddStoryModel.fromJson(Map<String, dynamic> data) =>
      _$AddStoryModelFromJson(data);

  @override
  AddStoryModel fromJson(dynamic data) =>
      AddStoryModel.fromJson(data as Map<String, dynamic>);
}
