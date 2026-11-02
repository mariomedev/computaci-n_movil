import 'package:computacion_movil/core/network/dio_client.dart';
import 'package:computacion_movil/core/network/api_client.dart';
import 'package:computacion_movil/core/network/api_endpoints.dart';
import 'package:get_it/get_it.dart';

Future<void> initNetworkDependencies(GetIt sl) async {
  // DioClient con configuración base
  sl.registerLazySingleton(
    () => DioClient(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  );

  // ApiClient que envuelve DioClient con Either
  sl.registerLazySingleton(() => ApiClient(sl<DioClient>()));
}
