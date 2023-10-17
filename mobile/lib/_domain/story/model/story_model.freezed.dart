// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

StoryModel _$StoryModelFromJson(Map<String, dynamic> json) {
  return _StoryModel.fromJson(json);
}

/// @nodoc
mixin _$StoryModel {
  int get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;
  List<String>? get labels => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get season => throw _privateConstructorUsedError;
  String? get decade => throw _privateConstructorUsedError;
  String? get startTimeStamp => throw _privateConstructorUsedError;
  String? get endTimeStamp => throw _privateConstructorUsedError;
  List<CommentModel>? get comments => throw _privateConstructorUsedError;
  List<LocationModel>? get locations => throw _privateConstructorUsedError;
  List<int>? get likes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StoryModelCopyWith<StoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryModelCopyWith<$Res> {
  factory $StoryModelCopyWith(
          StoryModel value, $Res Function(StoryModel) then) =
      _$StoryModelCopyWithImpl<$Res, StoryModel>;
  @useResult
  $Res call(
      {int id,
      String text,
      String title,
      User? user,
      List<String>? labels,
      String? createdAt,
      String? season,
      String? decade,
      String? startTimeStamp,
      String? endTimeStamp,
      List<CommentModel>? comments,
      List<LocationModel>? locations,
      List<int>? likes});

  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class _$StoryModelCopyWithImpl<$Res, $Val extends StoryModel>
    implements $StoryModelCopyWith<$Res> {
  _$StoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? title = null,
    Object? user = freezed,
    Object? labels = freezed,
    Object? createdAt = freezed,
    Object? season = freezed,
    Object? decade = freezed,
    Object? startTimeStamp = freezed,
    Object? endTimeStamp = freezed,
    Object? comments = freezed,
    Object? locations = freezed,
    Object? likes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      labels: freezed == labels
          ? _value.labels
          : labels // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      season: freezed == season
          ? _value.season
          : season // ignore: cast_nullable_to_non_nullable
              as String?,
      decade: freezed == decade
          ? _value.decade
          : decade // ignore: cast_nullable_to_non_nullable
              as String?,
      startTimeStamp: freezed == startTimeStamp
          ? _value.startTimeStamp
          : startTimeStamp // ignore: cast_nullable_to_non_nullable
              as String?,
      endTimeStamp: freezed == endTimeStamp
          ? _value.endTimeStamp
          : endTimeStamp // ignore: cast_nullable_to_non_nullable
              as String?,
      comments: freezed == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<CommentModel>?,
      locations: freezed == locations
          ? _value.locations
          : locations // ignore: cast_nullable_to_non_nullable
              as List<LocationModel>?,
      likes: freezed == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<int>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_StoryModelCopyWith<$Res>
    implements $StoryModelCopyWith<$Res> {
  factory _$$_StoryModelCopyWith(
          _$_StoryModel value, $Res Function(_$_StoryModel) then) =
      __$$_StoryModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String text,
      String title,
      User? user,
      List<String>? labels,
      String? createdAt,
      String? season,
      String? decade,
      String? startTimeStamp,
      String? endTimeStamp,
      List<CommentModel>? comments,
      List<LocationModel>? locations,
      List<int>? likes});

  @override
  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class __$$_StoryModelCopyWithImpl<$Res>
    extends _$StoryModelCopyWithImpl<$Res, _$_StoryModel>
    implements _$$_StoryModelCopyWith<$Res> {
  __$$_StoryModelCopyWithImpl(
      _$_StoryModel _value, $Res Function(_$_StoryModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? title = null,
    Object? user = freezed,
    Object? labels = freezed,
    Object? createdAt = freezed,
    Object? season = freezed,
    Object? decade = freezed,
    Object? startTimeStamp = freezed,
    Object? endTimeStamp = freezed,
    Object? comments = freezed,
    Object? locations = freezed,
    Object? likes = freezed,
  }) {
    return _then(_$_StoryModel(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      labels: freezed == labels
          ? _value._labels
          : labels // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      season: freezed == season
          ? _value.season
          : season // ignore: cast_nullable_to_non_nullable
              as String?,
      decade: freezed == decade
          ? _value.decade
          : decade // ignore: cast_nullable_to_non_nullable
              as String?,
      startTimeStamp: freezed == startTimeStamp
          ? _value.startTimeStamp
          : startTimeStamp // ignore: cast_nullable_to_non_nullable
              as String?,
      endTimeStamp: freezed == endTimeStamp
          ? _value.endTimeStamp
          : endTimeStamp // ignore: cast_nullable_to_non_nullable
              as String?,
      comments: freezed == comments
          ? _value._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<CommentModel>?,
      locations: freezed == locations
          ? _value._locations
          : locations // ignore: cast_nullable_to_non_nullable
              as List<LocationModel>?,
      likes: freezed == likes
          ? _value._likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<int>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_StoryModel extends _StoryModel {
  _$_StoryModel(
      {this.id = 0,
      this.text = '',
      this.title = '',
      this.user,
      final List<String>? labels,
      this.createdAt,
      this.season,
      this.decade,
      this.startTimeStamp,
      this.endTimeStamp,
      final List<CommentModel>? comments,
      final List<LocationModel>? locations,
      final List<int>? likes})
      : _labels = labels,
        _comments = comments,
        _locations = locations,
        _likes = likes,
        super._();

  factory _$_StoryModel.fromJson(Map<String, dynamic> json) =>
      _$$_StoryModelFromJson(json);

  @override
  @JsonKey()
  final int id;
  @override
  @JsonKey()
  final String text;
  @override
  @JsonKey()
  final String title;
  @override
  final User? user;
  final List<String>? _labels;
  @override
  List<String>? get labels {
    final value = _labels;
    if (value == null) return null;
    if (_labels is EqualUnmodifiableListView) return _labels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? createdAt;
  @override
  final String? season;
  @override
  final String? decade;
  @override
  final String? startTimeStamp;
  @override
  final String? endTimeStamp;
  final List<CommentModel>? _comments;
  @override
  List<CommentModel>? get comments {
    final value = _comments;
    if (value == null) return null;
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<LocationModel>? _locations;
  @override
  List<LocationModel>? get locations {
    final value = _locations;
    if (value == null) return null;
    if (_locations is EqualUnmodifiableListView) return _locations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<int>? _likes;
  @override
  List<int>? get likes {
    final value = _likes;
    if (value == null) return null;
    if (_likes is EqualUnmodifiableListView) return _likes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'StoryModel(id: $id, text: $text, title: $title, user: $user, labels: $labels, createdAt: $createdAt, season: $season, decade: $decade, startTimeStamp: $startTimeStamp, endTimeStamp: $endTimeStamp, comments: $comments, locations: $locations, likes: $likes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_StoryModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.user, user) || other.user == user) &&
            const DeepCollectionEquality().equals(other._labels, _labels) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.season, season) || other.season == season) &&
            (identical(other.decade, decade) || other.decade == decade) &&
            (identical(other.startTimeStamp, startTimeStamp) ||
                other.startTimeStamp == startTimeStamp) &&
            (identical(other.endTimeStamp, endTimeStamp) ||
                other.endTimeStamp == endTimeStamp) &&
            const DeepCollectionEquality().equals(other._comments, _comments) &&
            const DeepCollectionEquality()
                .equals(other._locations, _locations) &&
            const DeepCollectionEquality().equals(other._likes, _likes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      text,
      title,
      user,
      const DeepCollectionEquality().hash(_labels),
      createdAt,
      season,
      decade,
      startTimeStamp,
      endTimeStamp,
      const DeepCollectionEquality().hash(_comments),
      const DeepCollectionEquality().hash(_locations),
      const DeepCollectionEquality().hash(_likes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_StoryModelCopyWith<_$_StoryModel> get copyWith =>
      __$$_StoryModelCopyWithImpl<_$_StoryModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_StoryModelToJson(
      this,
    );
  }
}

abstract class _StoryModel extends StoryModel {
  factory _StoryModel(
      {final int id,
      final String text,
      final String title,
      final User? user,
      final List<String>? labels,
      final String? createdAt,
      final String? season,
      final String? decade,
      final String? startTimeStamp,
      final String? endTimeStamp,
      final List<CommentModel>? comments,
      final List<LocationModel>? locations,
      final List<int>? likes}) = _$_StoryModel;
  _StoryModel._() : super._();

  factory _StoryModel.fromJson(Map<String, dynamic> json) =
      _$_StoryModel.fromJson;

  @override
  int get id;
  @override
  String get text;
  @override
  String get title;
  @override
  User? get user;
  @override
  List<String>? get labels;
  @override
  String? get createdAt;
  @override
  String? get season;
  @override
  String? get decade;
  @override
  String? get startTimeStamp;
  @override
  String? get endTimeStamp;
  @override
  List<CommentModel>? get comments;
  @override
  List<LocationModel>? get locations;
  @override
  List<int>? get likes;
  @override
  @JsonKey(ignore: true)
  _$$_StoryModelCopyWith<_$_StoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}
