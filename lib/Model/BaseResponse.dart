class BaseResponse{
  bool status = false;
  String message = "";
  int statusCode = 200;

  @override
  String toString() {
    return 'BaseResponse{status: $status, message: $message, statusCode: $statusCode}';
  }
}