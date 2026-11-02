import 'package:computacion_movil/core/network/network_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class LoggingHttpClient extends http.BaseClient {
  final http.Client _inner;

  LoggingHttpClient([http.Client? inner]) : _inner = inner ?? http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (kDebugMode) {
      NetworkLogger.logRequest(
        method: request.method,
        url: request.url.toString(),
        headers: request.headers,
        contentType: request.headers['content-type'],
        body: request is http.Request ? request.body : null,
      );
    }

    final stopwatch = Stopwatch()..start();

    try {
      final response = await _inner.send(request);
      stopwatch.stop();

      if (kDebugMode) {
        final responseBytes = await response.stream.toBytes();
        final responseBody = String.fromCharCodes(responseBytes);

        final statusCode = response.statusCode;

        if (statusCode >= 400) {
          NetworkLogger.logError(
            url: request.url.toString(),
            errorType: 'HTTP $statusCode',
            statusCode: statusCode,
            message: '${stopwatch.elapsedMilliseconds}ms',
            responseBody: responseBody,
          );
        } else {
          NetworkLogger.logResponse(
            statusCode: statusCode,
            url: request.url.toString(),
            body: responseBody,
          );
        }

        return http.StreamedResponse(
          Stream.value(responseBytes),
          response.statusCode,
          contentLength: response.contentLength,
          request: response.request,
          headers: response.headers,
          isRedirect: response.isRedirect,
          persistentConnection: response.persistentConnection,
          reasonPhrase: response.reasonPhrase,
        );
      }

      return response;
    } catch (e) {
      stopwatch.stop();

      if (kDebugMode) {
        NetworkLogger.logError(
          url: request.url.toString(),
          errorType: e.runtimeType.toString(),
          message: e.toString(),
        );
      }

      rethrow;
    }
  }

  @override
  void close() {
    _inner.close();
  }
}
