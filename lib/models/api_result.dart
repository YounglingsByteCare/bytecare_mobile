class ApiResult {
  final int code;
  final String message;
  final bool hasError;
  final dynamic data;

  ApiResult({this.code, this.message, this.hasError, this.data});
}
