import '/app/network/exceptions/base_api_exception.dart';

class ApiException extends BaseApiException {
  ApiException({
    required int httpCode,
    required String status,
    String message = "",
    String detail = "",
  }) : super(
            httpCode: httpCode,
            status: status,
            message: message,
            detail: detail);
}
