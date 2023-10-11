import 'dart:async';

import 'package:busenet/busenet.dart';
import 'package:injectable/injectable.dart';

import '../../_core/env/env.dart';
import 'model/response_model.dart';

@singleton
class AppNetworkManager {
  late final INetworkManager<ResponseModel> _networkManager;
  AppNetworkManager(this._networkManager) {
    init();
  }

  Completer<void> initializeCompleter = Completer<void>();

  Future<void> init() async {
    await _networkManager.initialize(
      NetworkConfiguration(
        AppEnv.apiUrl,
      ),
      responseModel: ResponseModel(),
      entityKey: 'entity',
    );
    initializeCompleter.complete();
  }

  Future<ResponseModel> fetch<T extends BaseEntity<T>, R>(
    String path, {
    required T parserModel,
    required HttpTypes type,
    String contentType = Headers.jsonContentType,
    ResponseType responseType = ResponseType.json,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    CachePolicy cachePolicy = CachePolicy.forceCache,
    Duration maxStale = const Duration(minutes: 1),
    bool ignoreEntityKey = false,
  }) async {
    await waitForManagerInitialization;

    return _networkManager.fetch<T, R>(
      path,
      parserModel: parserModel,
      type: type,
      cachePolicy: cachePolicy,
      cancelToken: cancelToken,
      contentType: contentType,
      data: data,
      maxStale: maxStale,
      onSendProgress: onSendProgress,
      queryParameters: queryParameters,
      responseType: responseType,
      ignoreEntityKey: ignoreEntityKey,
    );
  }

  Future<void> get waitForManagerInitialization async {
    if (!initializeCompleter.isCompleted) {
      await initializeCompleter.future;
    }
  }

  void changeLangHeader(String langCode) {
    _networkManager.removeHeader('Lang');
    _networkManager.addHeader({'Lang': langCode});
  }

  void addAuthHeader(String token) {
    removeAuthHeader();
    _networkManager.addAuthorizationHeader(token);
  }

  void removeAuthHeader() {
    _networkManager.removeAuthorizationHeader();
  }
}
