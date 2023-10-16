// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_StoryModel _$$_StoryModelFromJson(Map<String, dynamic> json) =>
    _$_StoryModel(
      id: json['id'] as int? ?? 0,
      text: json['text'] as String? ?? '',
      title: json['title'] as String? ?? '',
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      labels:
          (json['labels'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: json['createdAt'] as String?,
      season: json['season'] as String?,
      decade: json['decade'] as String?,
      startTimeStamp: json['startTimeStamp'] as String?,
      endTimeStamp: json['endTimeStamp'] as String?,
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      locations: (json['locations'] as List<dynamic>?)
          ?.map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      likes: (json['likes'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$$_StoryModelToJson(_$_StoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'title': instance.title,
      'user': instance.user,
      'labels': instance.labels,
      'createdAt': instance.createdAt,
      'season': instance.season,
      'decade': instance.decade,
      'startTimeStamp': instance.startTimeStamp,
      'endTimeStamp': instance.endTimeStamp,
      'comments': instance.comments,
      'locations': instance.locations,
      'likes': instance.likes,
    };
