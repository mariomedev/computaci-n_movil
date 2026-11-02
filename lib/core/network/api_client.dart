import 'package:dio/dio.dart';
import 'package:computacion_movil/core/errors/item_error.dart';
import 'package:computacion_movil/core/network/dio_client.dart';
import 'package:dart_either/dart_either.dart';

/// Cliente API que envuelve DioClient con manejo de errores usando Either
class ApiClient {
  final DioClient _dioClient;

  const ApiClient(this._dioClient);

  /// GET request con manejo de errores
  Future<Either<ItemError, T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Options? options,
  }) async {
    try {
      final response = await _dioClient.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
      );

      if (response.data == null) {
        return Left(
          ItemError(message: 'No data received from server', code: 'NO_DATA'),
        );
      }

      if (fromJson != null) {
        return Right(fromJson(response.data));
      }

      return Right(response.data as T);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ItemError(message: e.toString(), code: 'UNKNOWN_ERROR'));
    }
  }

  /// POST request con manejo de errores
  Future<Either<ItemError, T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Options? options,
  }) async {
    try {
      final response = await _dioClient.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      if (response.data == null) {
        return Left(
          ItemError(message: 'No data received from server', code: 'NO_DATA'),
        );
      }

      if (fromJson != null) {
        return Right(fromJson(response.data));
      }

      return Right(response.data as T);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ItemError(message: e.toString(), code: 'UNKNOWN_ERROR'));
    }
  }

  /// PUT request con manejo de errores
  Future<Either<ItemError, T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Options? options,
  }) async {
    try {
      final response = await _dioClient.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      if (response.data == null) {
        return Left(
          ItemError(message: 'No data received from server', code: 'NO_DATA'),
        );
      }

      if (fromJson != null) {
        return Right(fromJson(response.data));
      }

      return Right(response.data as T);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ItemError(message: e.toString(), code: 'UNKNOWN_ERROR'));
    }
  }

  /// DELETE request con manejo de errores
  Future<Either<ItemError, T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Options? options,
  }) async {
    try {
      final response = await _dioClient.delete<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      if (response.data == null) {
        return Left(
          ItemError(message: 'No data received from server', code: 'NO_DATA'),
        );
      }

      if (fromJson != null) {
        return Right(fromJson(response.data));
      }

      return Right(response.data as T);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ItemError(message: e.toString(), code: 'UNKNOWN_ERROR'));
    }
  }

  /// PATCH request con manejo de errores
  Future<Either<ItemError, T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Options? options,
  }) async {
    try {
      final response = await _dioClient.patch<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      if (response.data == null) {
        return Left(
          ItemError(message: 'No data received from server', code: 'NO_DATA'),
        );
      }

      if (fromJson != null) {
        return Right(fromJson(response.data));
      }

      return Right(response.data as T);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ItemError(message: e.toString(), code: 'UNKNOWN_ERROR'));
    }
  }

  /// Acceso directo al DioClient para casos avanzados
  DioClient get dioClient => _dioClient;

  /// Agregar token de autorización
  void setAuthToken(String token) {
    _dioClient.setAuthToken(token);
  }

  /// Remover token de autorización
  void removeAuthToken() {
    _dioClient.removeAuthToken();
  }

  /// Manejo centralizado de errores de Dio
  ItemError _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ItemError(
          message: 'Connection timeout',
          code: 'CONNECTION_TIMEOUT',
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.sendTimeout:
        return ItemError(
          message: 'Send timeout',
          code: 'SEND_TIMEOUT',
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.receiveTimeout:
        return ItemError(
          message: 'Receive timeout',
          code: 'RECEIVE_TIMEOUT',
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;

        String message = 'Server error';
        if (responseData is Map && responseData.containsKey('message')) {
          message = responseData['message'].toString();
        } else if (responseData is String) {
          message = responseData;
        }

        return ItemError(
          message: message,
          code: 'HTTP_$statusCode',
          statusCode: statusCode,
          data: responseData,
        );

      case DioExceptionType.cancel:
        return ItemError(
          message: 'Request cancelled',
          code: 'REQUEST_CANCELLED',
        );

      case DioExceptionType.connectionError:
        return ItemError(
          message: 'No internet connection',
          code: 'NO_INTERNET',
        );

      case DioExceptionType.badCertificate:
        return ItemError(message: 'Bad certificate', code: 'BAD_CERTIFICATE');

      case DioExceptionType.unknown:
      default:
        return ItemError(
          message: error.message ?? 'Unknown error occurred',
          code: 'UNKNOWN_ERROR',
        );
    }
  }
}
