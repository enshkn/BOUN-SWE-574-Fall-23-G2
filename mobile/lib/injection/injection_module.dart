import 'package:busenet/busenet.dart';
import 'package:injectable/injectable.dart';

import '../_domain/network/model/response_model.dart';

@module
abstract class InjectionModule {
  @lazySingleton
  INetworkManager<ResponseModel> get manager => NetworkManager<ResponseModel>();
}
