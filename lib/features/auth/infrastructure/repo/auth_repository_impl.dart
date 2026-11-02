import 'package:computacion_movil/core/errors/item_error.dart';
import 'package:computacion_movil/core/network/api_client.dart';
import 'package:computacion_movil/core/network/api_endpoints.dart';
import 'package:computacion_movil/features/auth/domain/data/auth_remote_data_source.dart';
import 'package:computacion_movil/features/auth/domain/entities/auth_token_entity.dart';
import 'package:computacion_movil/features/auth/domain/entities/login_params.dart';
import 'package:computacion_movil/features/auth/domain/entities/register_profile_params.dart';
import 'package:computacion_movil/features/auth/domain/entities/user_entity.dart';
import 'package:computacion_movil/features/auth/domain/entities/user_register_params.dart';
import 'package:computacion_movil/features/auth/domain/repo/auth_repository.dart';
import 'package:computacion_movil/features/auth/infrastructure/models/user_model.dart';
import 'package:dart_either/dart_either.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource dataSource;
  final ApiClient apiClient;

  const AuthRepositoryImpl({required this.dataSource, required this.apiClient});

  @override
  Future<Either<ItemError, AuthTokenEntity>> signInWithEmailPassword(
    LoginParams params,
  ) async {
    final result = await dataSource.login(params);
    return result.fold(
      ifLeft: (error) => Left(error),
      ifRight: (tokenModel) {
        // Configurar token en ApiClient para futuras llamadas
        apiClient.setAuthToken(tokenModel.idToken);
        return Right(tokenModel.toEntity());
      },
    );
  }

  @override
  Future<Either<ItemError, AuthTokenEntity>> signUpWithEmailPassword(
    UserRegisterParams params,
  ) async {
    final result = await dataSource.register(params);
    return result.fold(
      ifLeft: (error) => Left(error),
      ifRight: (tokenModel) {
        // Configurar token en ApiClient
        apiClient.setAuthToken(tokenModel.idToken);
        return Right(tokenModel.toEntity());
      },
    );
  }

  @override
  Future<Either<ItemError, bool>> signOut() async {
    final result = await dataSource.logout();
    return result.fold(
      ifLeft: (error) => Left(error),
      ifRight: (success) {
        // Remover token del ApiClient
        apiClient.removeAuthToken();
        return Right(success);
      },
    );
  }

  @override
  Future<Either<ItemError, UserEntity>> getProfile(
    String idToken,
    String uid,
  ) async {
    // Configurar token
    apiClient.setAuthToken(idToken);

    // Llamar al backend para obtener el perfil
    final result = await apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.getUser(uid),
      fromJson: (data) => data as Map<String, dynamic>,
    );

    return result.fold(
      ifLeft: (error) => Left(error),
      ifRight: (data) {
        final userModel = UserModel.fromJson(data);
        return Right(userModel.toEntity());
      },
    );
  }

  @override
  Future<Either<ItemError, UserEntity>> registerProfile(
    String idToken,
    RegisterProfileParams params,
  ) async {
    // Configurar token
    apiClient.setAuthToken(idToken);

    // Registrar perfil en el backend
    final result = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.registerUser,
      data: {
        'nombre': params.nombre,
        'apellido': params.apellido,
        'telefono': params.telefono,
        'nacionalidad': params.nacionalidad,
      },
      fromJson: (data) => data as Map<String, dynamic>,
    );

    return result.fold(
      ifLeft: (error) => Left(error),
      ifRight: (data) {
        final userModel = UserModel.fromJson(data);
        return Right(userModel.toEntity());
      },
    );
  }

  @override
  Future<Either<ItemError, UserEntity>> updateProfile(
    String idToken,
    String uid,
    RegisterProfileParams params,
  ) async {
    // Configurar token
    apiClient.setAuthToken(idToken);

    // Actualizar perfil en el backend
    final result = await apiClient.put<Map<String, dynamic>>(
      ApiEndpoints.updateUser(uid),
      data: {
        'nombre': params.nombre,
        'apellido': params.apellido,
        'telefono': params.telefono,
        'nacionalidad': params.nacionalidad,
      },
      fromJson: (data) => data as Map<String, dynamic>,
    );

    return result.fold(
      ifLeft: (error) => Left(error),
      ifRight: (data) {
        final userModel = UserModel.fromJson(data);
        return Right(userModel.toEntity());
      },
    );
  }

  @override
  Future<Either<ItemError, AuthTokenEntity?>> getCurrentToken() async {
    final result = await dataSource.getAuthToken();
    return result.fold(
      ifLeft: (error) => Left(error),
      ifRight: (token) {
        if (token == null) return const Right(null);

        // Si hay token, intentar obtener el usuario actual
        return const Right(
          null,
        ); // TODO: Implementar si se necesita persistir token
      },
    );
  }
}
