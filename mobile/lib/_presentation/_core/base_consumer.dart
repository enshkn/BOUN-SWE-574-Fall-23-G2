// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../_application/core/base_cubit.dart';
import '../../_application/core/base_state.dart';

class BaseConsumer<T extends BaseCubit<R>, R extends BaseState> extends StatefulWidget {
  final BuildContext context;
  final Widget Function(BuildContext context, T cubit, R state) builder;
  final bool Function(R, R)? listenWhen;
  final void Function(BuildContext context, T cubit, R state)? listener;
  final void Function(T cubit)? onCubitReady;
  const BaseConsumer(
    this.context, {
    required this.builder,
    super.key,
    this.listenWhen,
    this.listener,
    this.onCubitReady,
  });

  @override
  State<BaseConsumer<T, R>> createState() => _BaseConsumerState<T, R>();
}

class _BaseConsumerState<T extends BaseCubit<R>, R extends BaseState> extends State<BaseConsumer<T, R>> {
  late BuildContext baseContext;
  late T cubit;

  @override
  void initState() {
    super.initState();
    baseContext = widget.context;
    cubit = baseContext.read<T>();
    widget.onCubitReady?.call(cubit);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<T, R>(
      builder: (context, state) {
        return widget.builder(baseContext, cubit, state);
      },
      listenWhen: widget.listenWhen,
      listener: (context, state) {
        if (widget.listener != null) {
          return widget.listener!(baseContext, cubit, state);
        }
      },
    );
  }
}
