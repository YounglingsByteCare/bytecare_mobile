import 'package:flutter/foundation.dart';

class ApiResultModel<T> {
  final int code;
  final String message;
  final bool hasError;
  final T data;

  ApiResultModel({
    @required this.code,
    this.message,
    this.hasError,
    this.data,
  });

  ApiResultModel copyWith({
    int code,
    String message,
    bool hasError,
    dynamic data,
  }) {
    return ApiResultModel(
      code: code ?? this.code,
      message: message ?? this.message,
      hasError: hasError ?? this.hasError,
      data: data ?? this.data,
    );
  }
}
