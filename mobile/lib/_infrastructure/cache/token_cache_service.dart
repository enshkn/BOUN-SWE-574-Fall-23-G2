import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../../_common/constants/hive_constants.dart';
import '../../_core/storage/hive/i_cache_service.dart';
import '../../_domain/cache/model/token_model.dart';

@Named(HiveConstants.tokenServiceKey)
@LazySingleton(as: ICacheManager<TokenModel>)
class TokenCacheService extends ICacheManager<TokenModel> {
  TokenCacheService() : super(HiveConstants.tokenServiceKey);

  @override
  TokenModel? getData() {
    return box?.get(HiveConstants.tokenKey);
  }

  @override
  Future<void> putAll(List<TokenModel> items) async {}

  @override
  void registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveConstants.tokenId)) {
      Hive.registerAdapter(TokenModelAdapter());
    }
  }

  @override
  Future<void> removeItem(String key) async {
    await box?.delete(HiveConstants.tokenKey);
  }

  @override
  Future<void> setData(TokenModel data) async {
    await box?.delete(HiveConstants.tokenKey);
    await box?.put(HiveConstants.tokenKey, data);
  }
}
