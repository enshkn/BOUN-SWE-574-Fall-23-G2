import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../../_common/constants/hive_constants.dart';
import '../../_core/storage/hive/i_cache_service.dart';
import '../../_domain/cache/model/config.dart';

@Named(HiveConstants.configServiceKey)
@LazySingleton(as: ICacheManager<Config>)
class ConfigCacheService extends ICacheManager<Config> {
  ConfigCacheService() : super(HiveConstants.configServiceKey);

  @override
  Config? getData() {
    return box?.get(HiveConstants.configKey);
  }

  @override
  Future<void> putAll(List<Config> items) async {}

  @override
  void registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveConstants.configId)) {
      Hive.registerAdapter(ConfigAdapter());
    }
  }

  @override
  Future<void> removeItem(String key) async {
    await box?.delete(HiveConstants.configKey);
  }

  @override
  Future<void> setData(Config data) async {
    await box?.put(HiveConstants.configKey, data);
  }
}
