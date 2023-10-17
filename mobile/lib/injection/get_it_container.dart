import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'get_it_container.config.dart';

@InjectableInit()
@immutable
final class GetItContainer {
  static final GetIt _di = GetIt.I;

  static void configureDependencies() => _di.init();

  static Future<void> resetDependencies() => _di.reset(dispose: false);

  static T instance<T extends Object>() => _di.get<T>();
}
