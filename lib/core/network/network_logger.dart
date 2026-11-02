import 'package:flutter/foundation.dart';

class NetworkLogger {
  NetworkLogger._();

  static void logRequest({
    required String method,
    required String url,
    Map<String, String>? headers,
    String? contentType,
    dynamic body,
  }) {
    if (!kDebugMode) return;

    debugPrint('┌── REQUEST ──────────────────────────────');
    debugPrint('│ $method $url');
    if (headers != null && headers.isNotEmpty) {
      debugPrint('│ Headers: $headers');
    }
    if (contentType != null) {
      debugPrint('│ ContentType: $contentType');
    }
    if (body != null) {
      debugPrint('│ Body type: ${body.runtimeType}');
      debugPrint('│ Body: ${body.toString()}');
    }
    debugPrint('└─────────────────────────────────────────');
  }

  static void logResponse({
    required int statusCode,
    required String url,
    dynamic body,
  }) {
    if (!kDebugMode) return;

    debugPrint('┌── RESPONSE ─────────────────────────────');
    debugPrint('│ $statusCode $url');
    if (body != null) {
      final bodyStr = body.toString();
      debugPrint('│ Data: $bodyStr');
    }
    debugPrint('└─────────────────────────────────────────');
  }

  static void logError({
    required String url,
    String? errorType,
    String? message,
    int? statusCode,
    dynamic responseBody,
  }) {
    if (!kDebugMode) return;

    debugPrint('┌── ERROR ────────────────────────────────');
    debugPrint('│ ${errorType ?? 'unknown'} $url');
    if (statusCode != null) {
      debugPrint('│ Status: $statusCode');
    }
    if (message != null) {
      debugPrint('│ Message: $message');
    }
    if (responseBody != null) {
      debugPrint('│ Response: $responseBody');
    }
    debugPrint('└─────────────────────────────────────────');
  }
}
