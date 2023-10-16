// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SessionState {
  bool get isLoading => throw _privateConstructorUsedError;
  User? get authUser => throw _privateConstructorUsedError;
  bool get isFirstLogin => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SessionStateCopyWith<SessionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionStateCopyWith<$Res> {
  factory $SessionStateCopyWith(
          SessionState value, $Res Function(SessionState) then) =
      _$SessionStateCopyWithImpl<$Res, SessionState>;
  @useResult
  $Res call({bool isLoading, User? authUser, bool isFirstLogin});

  $UserCopyWith<$Res>? get authUser;
}

/// @nodoc
class _$SessionStateCopyWithImpl<$Res, $Val extends SessionState>
    implements $SessionStateCopyWith<$Res> {
  _$SessionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? authUser = freezed,
    Object? isFirstLogin = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      authUser: freezed == authUser
          ? _value.authUser
          : authUser // ignore: cast_nullable_to_non_nullable
              as User?,
      isFirstLogin: null == isFirstLogin
          ? _value.isFirstLogin
          : isFirstLogin // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get authUser {
    if (_value.authUser == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.authUser!, (value) {
      return _then(_value.copyWith(authUser: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_SessionStateCopyWith<$Res>
    implements $SessionStateCopyWith<$Res> {
  factory _$$_SessionStateCopyWith(
          _$_SessionState value, $Res Function(_$_SessionState) then) =
      __$$_SessionStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, User? authUser, bool isFirstLogin});

  @override
  $UserCopyWith<$Res>? get authUser;
}

/// @nodoc
class __$$_SessionStateCopyWithImpl<$Res>
    extends _$SessionStateCopyWithImpl<$Res, _$_SessionState>
    implements _$$_SessionStateCopyWith<$Res> {
  __$$_SessionStateCopyWithImpl(
      _$_SessionState _value, $Res Function(_$_SessionState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? authUser = freezed,
    Object? isFirstLogin = null,
  }) {
    return _then(_$_SessionState(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      authUser: freezed == authUser
          ? _value.authUser
          : authUser // ignore: cast_nullable_to_non_nullable
              as User?,
      isFirstLogin: null == isFirstLogin
          ? _value.isFirstLogin
          : isFirstLogin // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_SessionState extends _SessionState {
  const _$_SessionState(
      {this.isLoading = false, this.authUser, this.isFirstLogin = true})
      : super._();

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final User? authUser;
  @override
  @JsonKey()
  final bool isFirstLogin;

  @override
  String toString() {
    return 'SessionState(isLoading: $isLoading, authUser: $authUser, isFirstLogin: $isFirstLogin)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SessionState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.authUser, authUser) ||
                other.authUser == authUser) &&
            (identical(other.isFirstLogin, isFirstLogin) ||
                other.isFirstLogin == isFirstLogin));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLoading, authUser, isFirstLogin);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SessionStateCopyWith<_$_SessionState> get copyWith =>
      __$$_SessionStateCopyWithImpl<_$_SessionState>(this, _$identity);
}

abstract class _SessionState extends SessionState {
  const factory _SessionState(
      {final bool isLoading,
      final User? authUser,
      final bool isFirstLogin}) = _$_SessionState;
  const _SessionState._() : super._();

  @override
  bool get isLoading;
  @override
  User? get authUser;
  @override
  bool get isFirstLogin;
  @override
  @JsonKey(ignore: true)
  _$$_SessionStateCopyWith<_$_SessionState> get copyWith =>
      throw _privateConstructorUsedError;
}
