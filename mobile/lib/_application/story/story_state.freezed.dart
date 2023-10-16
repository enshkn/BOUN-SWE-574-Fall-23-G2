// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$StoryState {
  bool get isLoading => throw _privateConstructorUsedError;
  StoryModel? get storyModel => throw _privateConstructorUsedError;
  List<StoryModel> get allStories => throw _privateConstructorUsedError;
  List<StoryModel> get activityFeedStories =>
      throw _privateConstructorUsedError;
  List<StoryModel>? get fallowedStories => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $StoryStateCopyWith<StoryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryStateCopyWith<$Res> {
  factory $StoryStateCopyWith(
          StoryState value, $Res Function(StoryState) then) =
      _$StoryStateCopyWithImpl<$Res, StoryState>;
  @useResult
  $Res call(
      {bool isLoading,
      StoryModel? storyModel,
      List<StoryModel> allStories,
      List<StoryModel> activityFeedStories,
      List<StoryModel>? fallowedStories});

  $StoryModelCopyWith<$Res>? get storyModel;
}

/// @nodoc
class _$StoryStateCopyWithImpl<$Res, $Val extends StoryState>
    implements $StoryStateCopyWith<$Res> {
  _$StoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? storyModel = freezed,
    Object? allStories = null,
    Object? activityFeedStories = null,
    Object? fallowedStories = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      storyModel: freezed == storyModel
          ? _value.storyModel
          : storyModel // ignore: cast_nullable_to_non_nullable
              as StoryModel?,
      allStories: null == allStories
          ? _value.allStories
          : allStories // ignore: cast_nullable_to_non_nullable
              as List<StoryModel>,
      activityFeedStories: null == activityFeedStories
          ? _value.activityFeedStories
          : activityFeedStories // ignore: cast_nullable_to_non_nullable
              as List<StoryModel>,
      fallowedStories: freezed == fallowedStories
          ? _value.fallowedStories
          : fallowedStories // ignore: cast_nullable_to_non_nullable
              as List<StoryModel>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $StoryModelCopyWith<$Res>? get storyModel {
    if (_value.storyModel == null) {
      return null;
    }

    return $StoryModelCopyWith<$Res>(_value.storyModel!, (value) {
      return _then(_value.copyWith(storyModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_StoryStateCopyWith<$Res>
    implements $StoryStateCopyWith<$Res> {
  factory _$$_StoryStateCopyWith(
          _$_StoryState value, $Res Function(_$_StoryState) then) =
      __$$_StoryStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      StoryModel? storyModel,
      List<StoryModel> allStories,
      List<StoryModel> activityFeedStories,
      List<StoryModel>? fallowedStories});

  @override
  $StoryModelCopyWith<$Res>? get storyModel;
}

/// @nodoc
class __$$_StoryStateCopyWithImpl<$Res>
    extends _$StoryStateCopyWithImpl<$Res, _$_StoryState>
    implements _$$_StoryStateCopyWith<$Res> {
  __$$_StoryStateCopyWithImpl(
      _$_StoryState _value, $Res Function(_$_StoryState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? storyModel = freezed,
    Object? allStories = null,
    Object? activityFeedStories = null,
    Object? fallowedStories = freezed,
  }) {
    return _then(_$_StoryState(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      storyModel: freezed == storyModel
          ? _value.storyModel
          : storyModel // ignore: cast_nullable_to_non_nullable
              as StoryModel?,
      allStories: null == allStories
          ? _value._allStories
          : allStories // ignore: cast_nullable_to_non_nullable
              as List<StoryModel>,
      activityFeedStories: null == activityFeedStories
          ? _value._activityFeedStories
          : activityFeedStories // ignore: cast_nullable_to_non_nullable
              as List<StoryModel>,
      fallowedStories: freezed == fallowedStories
          ? _value._fallowedStories
          : fallowedStories // ignore: cast_nullable_to_non_nullable
              as List<StoryModel>?,
    ));
  }
}

/// @nodoc

class _$_StoryState implements _StoryState {
  const _$_StoryState(
      {this.isLoading = false,
      this.storyModel,
      final List<StoryModel> allStories = const [],
      final List<StoryModel> activityFeedStories = const [],
      final List<StoryModel>? fallowedStories})
      : _allStories = allStories,
        _activityFeedStories = activityFeedStories,
        _fallowedStories = fallowedStories;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final StoryModel? storyModel;
  final List<StoryModel> _allStories;
  @override
  @JsonKey()
  List<StoryModel> get allStories {
    if (_allStories is EqualUnmodifiableListView) return _allStories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allStories);
  }

  final List<StoryModel> _activityFeedStories;
  @override
  @JsonKey()
  List<StoryModel> get activityFeedStories {
    if (_activityFeedStories is EqualUnmodifiableListView)
      return _activityFeedStories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activityFeedStories);
  }

  final List<StoryModel>? _fallowedStories;
  @override
  List<StoryModel>? get fallowedStories {
    final value = _fallowedStories;
    if (value == null) return null;
    if (_fallowedStories is EqualUnmodifiableListView) return _fallowedStories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'StoryState(isLoading: $isLoading, storyModel: $storyModel, allStories: $allStories, activityFeedStories: $activityFeedStories, fallowedStories: $fallowedStories)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_StoryState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.storyModel, storyModel) ||
                other.storyModel == storyModel) &&
            const DeepCollectionEquality()
                .equals(other._allStories, _allStories) &&
            const DeepCollectionEquality()
                .equals(other._activityFeedStories, _activityFeedStories) &&
            const DeepCollectionEquality()
                .equals(other._fallowedStories, _fallowedStories));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      storyModel,
      const DeepCollectionEquality().hash(_allStories),
      const DeepCollectionEquality().hash(_activityFeedStories),
      const DeepCollectionEquality().hash(_fallowedStories));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_StoryStateCopyWith<_$_StoryState> get copyWith =>
      __$$_StoryStateCopyWithImpl<_$_StoryState>(this, _$identity);
}

abstract class _StoryState implements StoryState {
  const factory _StoryState(
      {final bool isLoading,
      final StoryModel? storyModel,
      final List<StoryModel> allStories,
      final List<StoryModel> activityFeedStories,
      final List<StoryModel>? fallowedStories}) = _$_StoryState;

  @override
  bool get isLoading;
  @override
  StoryModel? get storyModel;
  @override
  List<StoryModel> get allStories;
  @override
  List<StoryModel> get activityFeedStories;
  @override
  List<StoryModel>? get fallowedStories;
  @override
  @JsonKey(ignore: true)
  _$$_StoryStateCopyWith<_$_StoryState> get copyWith =>
      throw _privateConstructorUsedError;
}
