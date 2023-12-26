// Mocks generated by Mockito 5.4.3 from annotations
// in swe/test/profile/profile_cubit_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;
import 'dart:io' as _i10;

import 'package:busenet/busenet.dart' as _i8;
import 'package:flutter/foundation.dart' as _i5;
import 'package:flutter/src/widgets/framework.dart' as _i4;
import 'package:flutter/src/widgets/notification_listener.dart' as _i13;
import 'package:mockito/mockito.dart' as _i1;
import 'package:swe/_domain/auth/i_auth_repository.dart' as _i11;
import 'package:swe/_domain/auth/model/follow_user_model.dart' as _i9;
import 'package:swe/_domain/auth/model/profile_update_model.dart' as _i3;
import 'package:swe/_domain/auth/model/register_model.dart' as _i12;
import 'package:swe/_domain/auth/model/user.dart' as _i2;
import 'package:swe/_domain/profile/i_profile_repository.dart' as _i6;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _Fake$UserCopyWith_0<$Res> extends _i1.SmartFake
    implements _i2.$UserCopyWith<$Res> {
  _Fake$UserCopyWith_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUser_1 extends _i1.SmartFake implements _i2.User {
  _FakeUser_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _Fake$ProfileUpdateModelCopyWith_2<$Res> extends _i1.SmartFake
    implements _i3.$ProfileUpdateModelCopyWith<$Res> {
  _Fake$ProfileUpdateModelCopyWith_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeProfileUpdateModel_3 extends _i1.SmartFake
    implements _i3.ProfileUpdateModel {
  _FakeProfileUpdateModel_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeWidget_4 extends _i1.SmartFake implements _i4.Widget {
  _FakeWidget_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );

  @override
  String toString({_i5.DiagnosticLevel? minLevel = _i5.DiagnosticLevel.info}) =>
      super.toString();
}

class _FakeInheritedWidget_5 extends _i1.SmartFake
    implements _i4.InheritedWidget {
  _FakeInheritedWidget_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );

  @override
  String toString({_i5.DiagnosticLevel? minLevel = _i5.DiagnosticLevel.info}) =>
      super.toString();
}

class _FakeDiagnosticsNode_6 extends _i1.SmartFake
    implements _i5.DiagnosticsNode {
  _FakeDiagnosticsNode_6(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );

  @override
  String toString({
    _i5.TextTreeConfiguration? parentConfiguration,
    _i5.DiagnosticLevel? minLevel = _i5.DiagnosticLevel.info,
  }) =>
      super.toString();
}

/// A class which mocks [IProfileRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockIProfileRepository extends _i1.Mock
    implements _i6.IProfileRepository {
  MockIProfileRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<(_i8.Failure?, _i2.User?)> getUserInfo() => (super.noSuchMethod(
        Invocation.method(
          #getUserInfo,
          [],
        ),
        returnValue: _i7.Future<(_i8.Failure?, _i2.User?)>.value((null, null)),
      ) as _i7.Future<(_i8.Failure?, _i2.User?)>);
  @override
  _i7.Future<(_i8.Failure?, _i2.User?)> updateUserInfo(
          _i3.ProfileUpdateModel? bio) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateUserInfo,
          [bio],
        ),
        returnValue: _i7.Future<(_i8.Failure?, _i2.User?)>.value((null, null)),
      ) as _i7.Future<(_i8.Failure?, _i2.User?)>);
  @override
  _i7.Future<(_i8.Failure?, _i2.User?)> followUser(
          _i9.FollowUserModel? model) =>
      (super.noSuchMethod(
        Invocation.method(
          #followUser,
          [model],
        ),
        returnValue: _i7.Future<(_i8.Failure?, _i2.User?)>.value((null, null)),
      ) as _i7.Future<(_i8.Failure?, _i2.User?)>);
  @override
  _i7.Future<(_i8.Failure?, _i2.User?)> otherProfile(int? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #otherProfile,
          [id],
        ),
        returnValue: _i7.Future<(_i8.Failure?, _i2.User?)>.value((null, null)),
      ) as _i7.Future<(_i8.Failure?, _i2.User?)>);
  @override
  _i7.Future<(_i8.Failure?, _i2.User?)> profileImageUpdate(_i10.File? file) =>
      (super.noSuchMethod(
        Invocation.method(
          #profileImageUpdate,
          [file],
        ),
        returnValue: _i7.Future<(_i8.Failure?, _i2.User?)>.value((null, null)),
      ) as _i7.Future<(_i8.Failure?, _i2.User?)>);
}

/// A class which mocks [User].
///
/// See the documentation for Mockito's code generation for more information.
class MockUser extends _i1.Mock implements _i2.User {
  MockUser() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.$UserCopyWith<_i2.User> get copyWith => (super.noSuchMethod(
        Invocation.getter(#copyWith),
        returnValue: _Fake$UserCopyWith_0<_i2.User>(
          this,
          Invocation.getter(#copyWith),
        ),
      ) as _i2.$UserCopyWith<_i2.User>);
  @override
  _i2.User fromJson(dynamic data) => (super.noSuchMethod(
        Invocation.method(
          #fromJson,
          [data],
        ),
        returnValue: _FakeUser_1(
          this,
          Invocation.method(
            #fromJson,
            [data],
          ),
        ),
      ) as _i2.User);
  @override
  Map<String, dynamic> toJson() => (super.noSuchMethod(
        Invocation.method(
          #toJson,
          [],
        ),
        returnValue: <String, dynamic>{},
      ) as Map<String, dynamic>);
}

/// A class which mocks [IAuthRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockIAuthRepository extends _i1.Mock implements _i11.IAuthRepository {
  MockIAuthRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<(_i8.Failure?, _i2.User?)> login(
    String? username,
    String? password,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #login,
          [
            username,
            password,
          ],
        ),
        returnValue: _i7.Future<(_i8.Failure?, _i2.User?)>.value((null, null)),
      ) as _i7.Future<(_i8.Failure?, _i2.User?)>);
  @override
  _i7.Future<(_i8.Failure?, bool?)> logout() => (super.noSuchMethod(
        Invocation.method(
          #logout,
          [],
        ),
        returnValue: _i7.Future<(_i8.Failure?, bool?)>.value((null, null)),
      ) as _i7.Future<(_i8.Failure?, bool?)>);
  @override
  _i7.Future<(_i8.Failure?, bool?)> register(_i12.RegisterModel? model) =>
      (super.noSuchMethod(
        Invocation.method(
          #register,
          [model],
        ),
        returnValue: _i7.Future<(_i8.Failure?, bool?)>.value((null, null)),
      ) as _i7.Future<(_i8.Failure?, bool?)>);
  @override
  _i7.Future<(_i8.Failure?, _i2.User?)> autoLogin() => (super.noSuchMethod(
        Invocation.method(
          #autoLogin,
          [],
        ),
        returnValue: _i7.Future<(_i8.Failure?, _i2.User?)>.value((null, null)),
      ) as _i7.Future<(_i8.Failure?, _i2.User?)>);
  @override
  _i7.Future<(_i8.Failure?, bool?)> checkToken() => (super.noSuchMethod(
        Invocation.method(
          #checkToken,
          [],
        ),
        returnValue: _i7.Future<(_i8.Failure?, bool?)>.value((null, null)),
      ) as _i7.Future<(_i8.Failure?, bool?)>);
}

/// A class which mocks [ProfileUpdateModel].
///
/// See the documentation for Mockito's code generation for more information.
class MockProfileUpdateModel extends _i1.Mock
    implements _i3.ProfileUpdateModel {
  MockProfileUpdateModel() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.$ProfileUpdateModelCopyWith<_i3.ProfileUpdateModel> get copyWith =>
      (super.noSuchMethod(
        Invocation.getter(#copyWith),
        returnValue: _Fake$ProfileUpdateModelCopyWith_2<_i3.ProfileUpdateModel>(
          this,
          Invocation.getter(#copyWith),
        ),
      ) as _i3.$ProfileUpdateModelCopyWith<_i3.ProfileUpdateModel>);
  @override
  _i3.ProfileUpdateModel fromJson(dynamic data) => (super.noSuchMethod(
        Invocation.method(
          #fromJson,
          [data],
        ),
        returnValue: _FakeProfileUpdateModel_3(
          this,
          Invocation.method(
            #fromJson,
            [data],
          ),
        ),
      ) as _i3.ProfileUpdateModel);
  @override
  Map<String, dynamic> toJson() => (super.noSuchMethod(
        Invocation.method(
          #toJson,
          [],
        ),
        returnValue: <String, dynamic>{},
      ) as Map<String, dynamic>);
}

/// A class which mocks [BuildContext].
///
/// See the documentation for Mockito's code generation for more information.
class MockBuildContext extends _i1.Mock implements _i4.BuildContext {
  MockBuildContext() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Widget get widget => (super.noSuchMethod(
        Invocation.getter(#widget),
        returnValue: _FakeWidget_4(
          this,
          Invocation.getter(#widget),
        ),
      ) as _i4.Widget);
  @override
  bool get mounted => (super.noSuchMethod(
        Invocation.getter(#mounted),
        returnValue: false,
      ) as bool);
  @override
  bool get debugDoingBuild => (super.noSuchMethod(
        Invocation.getter(#debugDoingBuild),
        returnValue: false,
      ) as bool);
  @override
  _i4.InheritedWidget dependOnInheritedElement(
    _i4.InheritedElement? ancestor, {
    Object? aspect,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #dependOnInheritedElement,
          [ancestor],
          {#aspect: aspect},
        ),
        returnValue: _FakeInheritedWidget_5(
          this,
          Invocation.method(
            #dependOnInheritedElement,
            [ancestor],
            {#aspect: aspect},
          ),
        ),
      ) as _i4.InheritedWidget);
  @override
  void visitAncestorElements(_i4.ConditionalElementVisitor? visitor) =>
      super.noSuchMethod(
        Invocation.method(
          #visitAncestorElements,
          [visitor],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void visitChildElements(_i4.ElementVisitor? visitor) => super.noSuchMethod(
        Invocation.method(
          #visitChildElements,
          [visitor],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void dispatchNotification(_i13.Notification? notification) =>
      super.noSuchMethod(
        Invocation.method(
          #dispatchNotification,
          [notification],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i5.DiagnosticsNode describeElement(
    String? name, {
    _i5.DiagnosticsTreeStyle? style = _i5.DiagnosticsTreeStyle.errorProperty,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #describeElement,
          [name],
          {#style: style},
        ),
        returnValue: _FakeDiagnosticsNode_6(
          this,
          Invocation.method(
            #describeElement,
            [name],
            {#style: style},
          ),
        ),
      ) as _i5.DiagnosticsNode);
  @override
  _i5.DiagnosticsNode describeWidget(
    String? name, {
    _i5.DiagnosticsTreeStyle? style = _i5.DiagnosticsTreeStyle.errorProperty,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #describeWidget,
          [name],
          {#style: style},
        ),
        returnValue: _FakeDiagnosticsNode_6(
          this,
          Invocation.method(
            #describeWidget,
            [name],
            {#style: style},
          ),
        ),
      ) as _i5.DiagnosticsNode);
  @override
  List<_i5.DiagnosticsNode> describeMissingAncestor(
          {required Type? expectedAncestorType}) =>
      (super.noSuchMethod(
        Invocation.method(
          #describeMissingAncestor,
          [],
          {#expectedAncestorType: expectedAncestorType},
        ),
        returnValue: <_i5.DiagnosticsNode>[],
      ) as List<_i5.DiagnosticsNode>);
  @override
  _i5.DiagnosticsNode describeOwnershipChain(String? name) =>
      (super.noSuchMethod(
        Invocation.method(
          #describeOwnershipChain,
          [name],
        ),
        returnValue: _FakeDiagnosticsNode_6(
          this,
          Invocation.method(
            #describeOwnershipChain,
            [name],
          ),
        ),
      ) as _i5.DiagnosticsNode);
}
