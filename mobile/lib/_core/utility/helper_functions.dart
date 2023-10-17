import 'package:flutter/material.dart';

import '../../injection/get_it_container.dart';

T di<T extends Object>() => GetItContainer.instance<T>();

void customPrint({
  required String fromWhere,
  required String data,
  String? type,
}) {
  debugPrint(
    "👉 [ DEBUG PRINT ] [ $fromWhere ] ${type == null ? "" : " [ $type ] "} $data",
  );
}
