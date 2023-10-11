// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:busenet/busenet.dart';

class ResponseModel extends BaseResponse<ResponseModel> {
  dynamic data;
  bool? status;
  ResponseModel({
    this.data,
    this.status,
  });

  @override
  ResponseModel fromJson(Map<String, dynamic> json) {
    return ResponseModel.fromMap(json);
  }

  @override
  void setData<R>(R entity) {
    data = entity;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': data,
      'status': status,
      'errorMessage': errorMessage,
    };
  }

  factory ResponseModel.fromMap(Map<String, dynamic> map) {
    return ResponseModel(
      data: map['data'] as dynamic,
      status: map['status'] != null ? map['status'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponseModel.fromJson(String source) =>
      ResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
