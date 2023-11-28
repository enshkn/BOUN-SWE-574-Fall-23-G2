import 'package:busenet/busenet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'getNearbyStories_model.freezed.dart';
part 'getNearbyStories_model.g.dart';

@freezed
class GetNearbyStoriesModel extends BaseEntity<GetNearbyStoriesModel>
    with _$GetNearbyStoriesModel {
  const factory GetNearbyStoriesModel({
    int? radius,
    double? longitude,
    double? latitude,
  }) = _GetNearbyStoriesModel;
  const GetNearbyStoriesModel._();
  factory GetNearbyStoriesModel.initial() => const GetNearbyStoriesModel();
  factory GetNearbyStoriesModel.fromJson(Map<String, dynamic> data) =>
      _$GetNearbyStoriesModelFromJson(data);

  @override
  GetNearbyStoriesModel fromJson(dynamic data) =>
      GetNearbyStoriesModel.fromJson(data as Map<String, dynamic>);
}
