import 'dart:io';

import 'package:flutter/material.dart';

/* Project-level Imports */
// Data Models
import '../models/api_result.dart';
import '../models/connection_result_data.dart';

class ProcessingManager {
  ConnectionState _state = ConnectionState.none;
  ApiResult _result;

  final ConnectionResultData successData;
  final ConnectionResultData errorData;
  final ConnectionResultData loadingData;

  final Widget Function(ConnectionResultData, Widget, String) modalBuilder;
  final Widget modalContainer;

  bool isComplete;

  ProcessingManager({
    this.modalBuilder,
    this.modalContainer,
    this.successData,
    this.errorData,
    this.loadingData,
  });

  Widget build(Widget content) {
    if (_state == ConnectionState.none) {
      return modalContainer;
    } else if (_state == ConnectionState.active) {
      String message = loadingData.message ?? _result.message;
      return modalBuilder(loadingData, content, message);
    } else if (_state == ConnectionState.done) {
      if (_result != null) {
        if (_result.hasError) {
          String message = errorData.message ?? _result.message;
          return modalBuilder(errorData, content, message);
        } else {
          String message = successData.message ?? _result.message;
          return modalBuilder(successData, content, message);
        }
      } else {
        return content;
      }
    } else {
      return content;
    }
  }

  ConnectionState get state => _state;

  set connectionState(ConnectionState state) => _state = state;

  void begin() {
    _result = null;
    connectionState = ConnectionState.active;
  }

  ApiResult complete(int code, String message, {bool hasError = false}) {
    _result = ApiResult(code: code, message: message, hasError: hasError);
    connectionState = ConnectionState.done;
    return _result;
  }

  ApiResult completeWithError(int code, String message) {
    return this.complete(code, message, hasError: true);
  }

  void reset() {
    _result = null;
    connectionState = ConnectionState.none;
  }

  bool get hasError => _result.hasError;
}
