import 'package:hive_flutter/hive_flutter.dart';

import '../../../_common/constants/hive_constants.dart';

part 'token_model.g.dart';

@HiveType(typeId: HiveConstants.tokenId)
class TokenModel extends HiveObject {
  TokenModel({
    this.accessToken,
  });

  @HiveField(0)
  String? accessToken;

  TokenModel copyWith({
    String? accessToken,
  }) {
    return TokenModel(
      accessToken: accessToken ?? this.accessToken,
    );
  }
}
