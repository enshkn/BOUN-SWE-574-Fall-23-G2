// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:busenet/busenet.dart';

class ResponseModel extends BaseResponse<ResponseModel> {
  dynamic entity;
  bool? success;
  String? message;
  int? status;
  int? count;

  ResponseModel({
    this.entity,
    this.status,
    this.success,
    this.message,
    this.count,
  });

  @override
  ResponseModel fromJson(Map<String, dynamic> json) {
    return ResponseModel.fromMap(json);
  }

  @override
  void setData<R>(R entity) {
    this.entity = entity;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'entity': entity,
      'success': success,
      'message': message,
      'status': status,
      'count': count,
    };
  }

  factory ResponseModel.fromMap(Map<String, dynamic> map) {
    return ResponseModel(
      entity: map['entity'] as dynamic,
      success: map['success'] != null ? map['success'] as bool : null,
      message: map['message'] != null ? map['message'] as String : null,
      status: map['status'] != null ? map['status'] as int : null,
      count: map['count'] != null ? map['count'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponseModel.fromJson(String source) =>
      ResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  ResponseModel copyWith({
    dynamic entity,
    int? count,
    bool? success,
    String? message,
    int? status,
  }) {
    return ResponseModel(
      entity: entity ?? this.entity,
      count: count ?? this.count,
      success: success ?? this.success,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }

  @override
  void clearEntity() {
    entity = null;
    count = null;
    status = null;
    success = null;
    message = null;
  }
}
