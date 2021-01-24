import 'package:bytecare_mobile/models/api_result.dart';
import 'package:flutter/material.dart';

/* Project-level Imports */
// Data Models
import '../models/api_result.dart';
import '../models/processing_dialog_theme.dart';

class ProcessingViewController {
  ConnectionState connectionState = ConnectionState.none;
  ApiResultModel _result;

  final ProcessingDialogThemeModel successData;
  final ProcessingDialogThemeModel errorData;
  final ProcessingDialogThemeModel loadingData;

  final Widget Function(ProcessingDialogThemeModel, Widget, String)
      modalBuilder;

  bool isComplete;

  ProcessingViewController({
    this.modalBuilder,
    this.successData,
    this.errorData,
    this.loadingData,
  });

  Widget build(Widget content) {
    if (connectionState == ConnectionState.active) {
      String message = loadingData.message ?? '';
      return modalBuilder(loadingData, content, message);
    } else if (connectionState == ConnectionState.done) {
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

  void begin() {
    _result = null;
    connectionState = ConnectionState.active;
  }

  ApiResultModel complete(int code, String message, [bool hasError = false]) {
    _result = ApiResultModel(code: code, message: message, hasError: hasError);
    connectionState = ConnectionState.done;
    return _result;
  }

  ApiResultModel completeWithError(int code, String message) {
    return this.complete(code, message, true);
  }

  void reset() {
    _result = null;
    connectionState = ConnectionState.none;
  }

  bool get hasError => _result.hasError;
}
