import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:swe/_application/core/base_state.dart';

import '../../_common/enums/bottom_tabs.dart';

part 'app_state.freezed.dart';

@freezed
class AppState extends BaseState with _$AppState {
  const factory AppState({
    @Default(false) bool isLoading,
    @Default(BottomTabs.home) BottomTabs bottomTab,
    BuildContext? context,
  }) = _AppState;
  factory AppState.initial() => const AppState();
}
