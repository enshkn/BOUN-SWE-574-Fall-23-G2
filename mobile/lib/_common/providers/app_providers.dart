// ignore_for_file: prefer_constructors_over_static_methods

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../_application/app/app_cubit.dart';
import '../../_application/services/connectivity/connectivity_cubit.dart';
import '../../_application/session/session_cubit.dart';
import '../../_core/utility/helper_functions.dart';

class ApplicationProvider {
  ApplicationProvider._();

  static final List<BlocProvider> _singleItems = [
    BlocProvider<ConnectivityCubit>(
      create: (context) => di<ConnectivityCubit>(),
      lazy: false,
    ),
    BlocProvider<SessionCubit>(
      create: (context) => di<SessionCubit>(),
      lazy: false,
    ),
  ];
  static final List<BlocProvider> _dependItems = [
    BlocProvider<AppCubit>(
      create: (context) => di<AppCubit>(),
      lazy: false,
    ),
  ];
  static final List<BlocProvider> _uiChangesItems = [];

  static List<BlocProvider> get providers => [..._singleItems, ..._dependItems, ..._uiChangesItems];
}
