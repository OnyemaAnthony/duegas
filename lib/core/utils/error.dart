class AppError implements Exception {
  String message;
  dynamic e;
  int? code;

  AppError(this.message);

  AppError.exception(this.e) : message = e.toString();

  @override
  String toString() {
    return message;
  }
}
