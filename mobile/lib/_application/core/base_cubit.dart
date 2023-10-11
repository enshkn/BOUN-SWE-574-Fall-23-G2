import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../_core/extensions/context_extensions.dart';

abstract base class BaseCubit<T> extends Cubit<T> {
  BaseCubit(super.initialState);

  late BuildContext context;
  BuildContext setContext(BuildContext context) => this.context = context;

  void safeEmit(T state) {
    if (!isClosed) {
      emit(state);
    }
  }

  void showNotification(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: isError ? Colors.red.shade900 : Colors.green.shade900,
        margin: context.paddingNormal,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void setError(String? message) {
    showNotification(message ?? '', isError: true);
  }

  void setLoading(bool loading) {}

  void resetFailure() {
    if (kDebugMode) {
      print("State'inde failure objesi bulundurmalısın");
    }
  }
}
