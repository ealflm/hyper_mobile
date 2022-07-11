abstract class BaseException implements Exception {
  final String message;
  final String detail;

  BaseException({this.message = "", this.detail = ""});
}
