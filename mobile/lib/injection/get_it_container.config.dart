// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:busenet/busenet.dart' as _i10;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:swe/_application/app/app_cubit.dart' as _i3;
import 'package:swe/_application/auth/auth_cubit.dart' as _i17;
import 'package:swe/_application/services/connectivity/connectivity_cubit.dart'
    as _i4;
import 'package:swe/_application/session/session_cubit.dart' as _i12;
import 'package:swe/_application/splash/splash_cubit.dart' as _i13;
import 'package:swe/_core/storage/hive/i_cache_service.dart' as _i5;
import 'package:swe/_domain/auth/i_auth_repository.dart' as _i15;
import 'package:swe/_domain/cache/model/config.dart' as _i8;
import 'package:swe/_domain/cache/model/token_model.dart' as _i6;
import 'package:swe/_domain/network/app_network_manager.dart' as _i14;
import 'package:swe/_domain/network/model/response_model.dart' as _i11;
import 'package:swe/_infrastructure/auth/auth_repository.dart' as _i16;
import 'package:swe/_infrastructure/cache/config_cache_service.dart' as _i9;
import 'package:swe/_infrastructure/cache/token_cache_service.dart' as _i7;
import 'package:swe/injection/injection_module.dart' as _i18;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final injectionModule = _$InjectionModule();
    gh.lazySingleton<_i3.AppCubit>(() => _i3.AppCubit());
    gh.factory<_i4.ConnectivityCubit>(() => _i4.ConnectivityCubit());
    gh.lazySingleton<_i5.ICacheManager<_i6.TokenModel>>(
      () => _i7.TokenCacheService(),
      instanceName: 'token_service',
    );
    gh.lazySingleton<_i5.ICacheManager<_i8.Config>>(
      () => _i9.ConfigCacheService(),
      instanceName: 'config_service',
    );
    gh.lazySingleton<_i10.INetworkManager<_i11.ResponseModel>>(
        () => injectionModule.manager);
    gh.factory<_i12.SessionCubit>(() => _i12.SessionCubit());
    gh.factory<_i13.SplashCubit>(() => _i13.SplashCubit());
    gh.singleton<_i14.AppNetworkManager>(
        _i14.AppNetworkManager(gh<_i10.INetworkManager<_i11.ResponseModel>>()));
    gh.lazySingleton<_i15.IAuthRepository>(() => _i16.AuthRepository(
          gh<_i14.AppNetworkManager>(),
          gh<_i5.ICacheManager<_i6.TokenModel>>(instanceName: 'config_service'),
        ));
    gh.factory<_i17.AuthCubit>(
        () => _i17.AuthCubit(gh<_i15.IAuthRepository>()));
    return this;
  }
}

class _$InjectionModule extends _i18.InjectionModule {}
