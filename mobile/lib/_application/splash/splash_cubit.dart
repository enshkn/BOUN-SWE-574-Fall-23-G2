import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swe/_application/session/session_cubit.dart';
import 'package:swe/_core/storage/hive/i_cache_service.dart';
import 'package:swe/_core/utility/record_utils.dart';
import 'package:swe/_domain/auth/i_auth_repository.dart';
import 'package:swe/_domain/cache/model/config.dart';
import 'package:swe/_domain/cache/model/token_model.dart';
import 'package:swe/_infrastructure/cache/config_cache_service.dart';
import 'package:swe/_infrastructure/cache/token_cache_service.dart';

import '../../_presentation/_route/router.dart';
import '../core/base_cubit.dart';
import 'splash_state.dart';

@injectable
final class SplashCubit extends BaseCubit<SplashState> {
  final ICacheManager<Config> _configCacheManager;
  final ICacheManager<TokenModel> _tokenCacheManager;
  final IAuthRepository _authRepository;
  SplashCubit(
    @Named.from(ConfigCacheService) this._configCacheManager,
    @Named.from(TokenCacheService) this._tokenCacheManager,
    this._authRepository,
  ) : super(SplashState.initial());

  Future<void> init() async {
    await Future.wait(
      [
        initCacheManagers(),
        getCurrentLocation(),
        Future.delayed(const Duration(seconds: 2), () {}),
      ],
    );
    await checkToken();
  }

  Future<void> initCacheManagers() async {
    await Future.wait([
      _configCacheManager.init(),
      _tokenCacheManager.init(),
    ]);
  }

  @override
  void setLoading(bool loading) {
    safeEmit(state.copyWith(isLoading: loading));
  }

  Future<void> checkUser() async {
    setLoading(true);

    final result = await _authRepository.autoLogin();
    setLoading(false);

    result.fold(
      (failure) {
        context.router.replaceAll([const LoginRoute()]);
      },
      (user) {
        final sessionCubit = context.read<SessionCubit>();
        sessionCubit.updateUser(user);
        context.router.replaceAll([const AppRoute()]);
      },
    );
  }

  Future<void> checkToken() async {
    setLoading(true);

    final result = await _authRepository.checkToken();
    setLoading(false);

    result.fold(
      (failure) {
        context.router.replaceAll([const LoginRoute()]);
      },
      (valid) {
        if (valid == true) {
          checkUser();
        } else {
          context.router.replaceAll([const LoginRoute()]);
        }
      },
    );
  }

  Future<void> getCurrentLocation() async {
    late LocationData currentLocation;
    final locationController = Location();
    final prefs = await SharedPreferences.getInstance();

    currentLocation = await locationController.getLocation();
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      await prefs.setDouble('latitude', currentLocation.latitude!);
      await prefs.setDouble('longitude', currentLocation.longitude!);
    }

    // currentLocation = await locationController.getLocation();
  }
}
