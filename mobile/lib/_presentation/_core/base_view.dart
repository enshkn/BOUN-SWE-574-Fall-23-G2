import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../_application/core/base_cubit.dart';
import '../../_application/core/base_state.dart';
import '../../_core/utility/helper_functions.dart';

class BaseView<T extends BaseCubit<R>, R extends BaseState> extends StatefulWidget {
  const BaseView({
    required this.builder,
    super.key,
    this.listener,
    this.listenWhen,
    this.onCubitReady,
  });
  final Widget Function(BuildContext context, T cubit, R state) builder;
  final bool Function(R, R)? listenWhen;
  final void Function(BuildContext context, T cubit, R state)? listener;
  final void Function(T cubit)? onCubitReady;

  @override
  State<BaseView> createState() => _BaseViewState<T, R>();
}

class _BaseViewState<T extends BaseCubit<R>, R extends BaseState> extends State<BaseView<T, R>> {
  late T cubit;

  @override
  void initState() {
    super.initState();

    cubit = di<T>();
    widget.onCubitReady?.call(cubit);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<T, R>(
        builder: (context, state) {
          return widget.builder(context, cubit, state);
        },
        listenWhen: widget.listenWhen,
        listener: (context, state) {
          final cubit = context.read<T>();
          if (widget.listener != null) {
            return widget.listener!(context, cubit, state);
          }
        },
      ),
    );
  }
}
