import 'package:busenet/busenet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_model.freezed.dart';
part 'location_model.g.dart';

@freezed
class LocationModel extends BaseEntity<LocationModel> with _$LocationModel {
  const factory LocationModel({
    String? locationName,
    double? latitude,
    double? longitude,
    int? isCircle,
    int? isPolyline,
    int? isPolygon,
    int? isPoint,
    int? circleRadius,
    String? createdAt,
  }) = _LocationModel;
  const LocationModel._();
  factory LocationModel.initial() => const LocationModel();
  factory LocationModel.fromJson(Map<String, dynamic> data) =>
      _$LocationModelFromJson(data);

  @override
  LocationModel fromJson(dynamic data) =>
      LocationModel.fromJson(data as Map<String, dynamic>);
}
