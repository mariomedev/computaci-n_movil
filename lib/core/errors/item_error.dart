class ItemError {
  final String message;
  final String? code;
  final int? statusCode;
  final dynamic data;

  const ItemError({
    required this.message,
    this.code,
    this.statusCode,
    this.data,
  });

  @override
  String toString() =>
      'ItemError(message: $message, code: $code, statusCode: $statusCode)';
}
