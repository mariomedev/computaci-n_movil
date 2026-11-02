import 'package:get_it/get_it.dart';

// Domain
import 'package:computacion_movil/features/auth/domain/data/auth_remote_data_source.dart';
import 'package:computacion_movil/features/auth/domain/repo/auth_repository.dart';

// Infrastructure
import 'package:computacion_movil/features/auth/infrastructure/data/lapticon_auth_data_source.dart';
import 'package:computacion_movil/features/auth/infrastructure/repo/auth_repository_impl.dart';

// Use Cases
import 'package:computacion_movil/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:computacion_movil/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:computacion_movil/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:computacion_movil/features/auth/domain/usecases/login_use_case.dart';
import 'package:computacion_movil/features/auth/domain/usecases/logout_use_case.dart';
import 'package:computacion_movil/features/auth/domain/usecases/get_profile_use_case.dart';
import 'package:computacion_movil/features/auth/domain/usecases/register_profile_use_case.dart';
import 'package:computacion_movil/features/auth/domain/usecases/update_profile_use_case.dart';

// Core
import 'package:computacion_movil/core/network/api_client.dart';

Future<void> initAuthDependencies(GetIt sl) async {
  // ========== DataSources ==========
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => LapticonAuthDataSource(apiClient: sl<ApiClient>()),
  );

  // ========== Repositories ==========
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      dataSource: sl<AuthRemoteDataSource>(),
      apiClient: sl<ApiClient>(),
    ),
  );

  // ========== Use Cases - Authentication ==========

  // Sign In con Firebase (solo obtiene token)
  sl.registerFactory(() => SignInUseCase(sl<AuthRepository>()));

  // Sign Up completo (Firebase + registrar perfil en backend)
  sl.registerFactory(() => SignUpUseCase(sl<AuthRepository>()));

  // Sign Out (cerrar sesión)
  sl.registerFactory(() => SignOutUseCase(sl<AuthRepository>()));

  // Login completo (Firebase + obtener perfil del backend)
  sl.registerFactory(() => LoginUseCase(sl<AuthRepository>()));

  // Logout (alias de SignOut para compatibilidad)
  sl.registerFactory(() => LogoutUseCase(sl<AuthRepository>()));

  // ========== Use Cases - Profile Management ==========

  // Obtener perfil del backend
  sl.registerFactory(() => GetProfileUseCase(sl<AuthRepository>()));

  // Registrar perfil en el backend
  sl.registerFactory(() => RegisterProfileUseCase(sl<AuthRepository>()));

  // Actualizar perfil en el backend
  sl.registerFactory(() => UpdateProfileUseCase(sl<AuthRepository>()));
}
