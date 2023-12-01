import 'package:busenet/busenet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_filter.freezed.dart';
part 'story_filter.g.dart';

@freezed
class StoryFilter extends BaseEntity<StoryFilter> with _$StoryFilter {
  const factory StoryFilter({
    String? query,
    int? radius,
    double? latitude,
    double? longitude,
    String? startTimeStamp,
    String? endTimeStamp,
    String? decade,
    String? season,
    String? label,
    String? title,
  }) = _StoryFilter;
  const StoryFilter._();
  factory StoryFilter.initial() => const StoryFilter();
  factory StoryFilter.fromJson(Map<String, dynamic> data) =>
      _$StoryFilterFromJson(data);

  @override
  StoryFilter fromJson(dynamic data) =>
      StoryFilter.fromJson(data as Map<String, dynamic>);

  bool get isEmpty =>
      query == null &&
      radius == null &&
      latitude == null &&
      longitude == null &&
      startTimeStamp == null &&
      endTimeStamp == null &&
      decade == null &&
      season == null &&
      label == null &&
      title == null;
}
