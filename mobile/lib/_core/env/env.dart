// ignore_for_file: non_constant_identifier_names

import 'package:envied/envied.dart';

import '../../main/config/app_flavor_config.dart';

part 'env.g.dart';

class AppEnv {
  static AppFlavorConfig config = AppFlavorConfig.initial();

  static bool get isDev => config.flavor == AppFlavor.dev;
  static bool get isProd => config.flavor == AppFlavor.prod;

  static void setConfig(AppFlavorConfig appConfig) {
    config = appConfig;
  }

  static String get apiUrl {
    switch (config.flavor) {
      case AppFlavor.dev:
        return _DevEnv.API_URL;
      case AppFlavor.prod:
        return _ProdEnv.API_URL;
    }
  }

  static String get apiKey {
    switch (config.flavor) {
      case AppFlavor.dev:
        return _DevEnv.API_KEY;
      case AppFlavor.prod:
        return _ProdEnv.API_KEY;
    }
  }
}

@Envied(path: '.env_development')
abstract class _DevEnv {
  @EnviedField(varName: 'API_URL', obfuscate: true)
  static String API_URL = __DevEnv.API_URL;

  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static String API_KEY = __DevEnv.API_KEY;
}

@Envied(path: '.env_production')
abstract class _ProdEnv {
  @EnviedField(varName: 'API_URL', obfuscate: true)
  static String API_URL = __ProdEnv.API_URL;
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static String API_KEY = __ProdEnv.API_KEY;
}
