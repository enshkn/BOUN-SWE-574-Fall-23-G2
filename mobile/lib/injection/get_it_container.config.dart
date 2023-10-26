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
import 'package:swe/_application/auth/auth_cubit.dart' as _i23;
import 'package:swe/_application/profile/profile_cubit.dart' as _i20;
import 'package:swe/_application/services/connectivity/connectivity_cubit.dart'
    as _i4;
import 'package:swe/_application/session/session_cubit.dart' as _i12;
import 'package:swe/_application/splash/splash_cubit.dart' as _i21;
import 'package:swe/_application/story/story_cubit.dart' as _i22;
import 'package:swe/_core/storage/hive/i_cache_service.dart' as _i5;
import 'package:swe/_domain/auth/i_auth_repository.dart' as _i14;
import 'package:swe/_domain/cache/model/config.dart' as _i8;
import 'package:swe/_domain/cache/model/token_model.dart' as _i6;
import 'package:swe/_domain/network/app_network_manager.dart' as _i13;
import 'package:swe/_domain/network/model/response_model.dart' as _i11;
import 'package:swe/_domain/profile/i_profile_repository.dart' as _i16;
import 'package:swe/_domain/story/i_story_repository.dart' as _i18;
import 'package:swe/_infrastructure/auth/auth_repository.dart' as _i15;
import 'package:swe/_infrastructure/cache/config_cache_service.dart' as _i9;
import 'package:swe/_infrastructure/cache/token_cache_service.dart' as _i7;
import 'package:swe/_infrastructure/profile/profile_repository.dart' as _i17;
import 'package:swe/_infrastructure/story/story_repository.dart' as _i19;
import 'package:swe/injection/injection_module.dart' as _i24;

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
      instanceName: 'TokenCacheService',
    );
    gh.lazySingleton<_i5.ICacheManager<_i8.Config>>(
      () => _i9.ConfigCacheService(),
      instanceName: 'ConfigCacheService',
    );
    gh.lazySingleton<_i10.INetworkManager<_i11.ResponseModel>>(
      () => injectionModule.manager,
    );
    gh.factory<_i12.SessionCubit>(() => _i12.SessionCubit());
    gh.singleton<_i13.AppNetworkManager>(
      _i13.AppNetworkManager(gh<_i10.INetworkManager<_i11.ResponseModel>>()),
    );
    gh.lazySingleton<_i14.IAuthRepository>(
      () => _i15.AuthRepository(
        gh<_i13.AppNetworkManager>(),
        gh<_i5.ICacheManager<_i6.TokenModel>>(
          instanceName: 'TokenCacheService',
        ),
      ),
    );
    gh.lazySingleton<_i16.IProfileRepository>(
      () => _i17.ProfileRepository(gh<_i13.AppNetworkManager>()),
    );
    gh.lazySingleton<_i18.IStoryRepository>(
      () => _i19.StoryRepository(gh<_i13.AppNetworkManager>()),
    );
    gh.factory<_i20.ProfileCubit>(
      () => _i20.ProfileCubit(
        gh<_i16.IProfileRepository>(),
        gh<_i14.IAuthRepository>(),
      ),
    );
    gh.factory<_i21.SplashCubit>(
      () => _i21.SplashCubit(
        gh<_i5.ICacheManager<_i8.Config>>(instanceName: 'ConfigCacheService'),
        gh<_i5.ICacheManager<_i6.TokenModel>>(
          instanceName: 'TokenCacheService',
        ),
        gh<_i14.IAuthRepository>(),
      ),
    );
    gh.factory<_i22.StoryCubit>(
      () => _i22.StoryCubit(gh<_i18.IStoryRepository>()),
    );
    gh.factory<_i23.AuthCubit>(
      () => _i23.AuthCubit(gh<_i14.IAuthRepository>()),
    );
    return this;
  }
}

class _$InjectionModule extends _i24.InjectionModule {}
