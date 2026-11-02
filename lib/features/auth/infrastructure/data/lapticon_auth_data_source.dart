import 'package:computacion_movil/core/network/api_client.dart';
import 'package:computacion_movil/core/network/api_endpoints.dart';
import 'package:computacion_movil/features/auth/domain/data/auth_remote_data_source.dart';
import 'package:computacion_movil/features/auth/domain/entities/login_params.dart';
import 'package:computacion_movil/features/auth/domain/entities/user_register_params.dart';
import 'package:computacion_movil/features/auth/infrastructure/models/auth_token_model.dart';
import 'package:computacion_movil/features/auth/infrastructure/models/user_model.dart';
import 'package:dart_either/dart_either.dart';
import 'package:computacion_movil/core/errors/item_error.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LapticonAuthDataSource implements AuthRemoteDataSource {
  final ApiClient _apiClient;
  final FirebaseAuth _firebaseAuth;

  LapticonAuthDataSource({required this._apiClient, FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<Either<ItemError, AuthTokenModel>> login(LoginParams params) async {
    try {
      // Login con Firebase Auth
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: params.username,
        password: params.password,
      );

      final user = userCredential.user;
      if (user == null) {
        return const Left(
          ItemError(
            message: 'No se pudo autenticar el usuario',
            code: 'AUTH_FAILED',
          ),
        );
      }

      // Obtener el ID Token
      final idToken = await user.getIdToken();
      if (idToken == null) {
        return const Left(
          ItemError(
            message: 'No se pudo obtener el token de autenticación',
            code: 'TOKEN_FAILED',
          ),
        );
      }

      return Right(
        AuthTokenModel(
          idToken: idToken,
          localId: user.uid,
          refreshToken: user.refreshToken ?? '',
          expiresIn: 3600, // Firebase tokens duran 1 hora por defecto
        ),
      );
    } on FirebaseAuthException catch (e) {
      return Left(
        ItemError(message: _getFirebaseErrorMessage(e.code), code: e.code),
      );
    } catch (e) {
      return Left(ItemError(message: e.toString(), code: 'UNKNOWN_ERROR'));
    }
  }

  @override
  Future<Either<ItemError, AuthTokenModel>> register(
    UserRegisterParams params,
  ) async {
    try {
      // Crear cuenta en Firebase Auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );

      final user = userCredential.user;
      if (user == null) {
        return const Left(
          ItemError(
            message: 'No se pudo crear el usuario',
            code: 'REGISTER_FAILED',
          ),
        );
      }

      // Actualizar el displayName si se proporcionó
      if (params.name != null) {
        await user.updateDisplayName(params.name);
      }

      // Obtener el ID Token
      final idToken = await user.getIdToken();
      if (idToken == null) {
        return const Left(
          ItemError(
            message: 'No se pudo obtener el token de autenticación',
            code: 'TOKEN_FAILED',
          ),
        );
      }

      return Right(
        AuthTokenModel(
          idToken: idToken,
          localId: user.uid,
          refreshToken: user.refreshToken ?? '',
          expiresIn: 3600,
        ),
      );
    } on FirebaseAuthException catch (e) {
      return Left(
        ItemError(message: _getFirebaseErrorMessage(e.code), code: e.code),
      );
    } catch (e) {
      return Left(ItemError(message: e.toString(), code: 'UNKNOWN_ERROR'));
    }
  }

  @override
  Future<Either<ItemError, bool>> logout() async {
    try {
      await _firebaseAuth.signOut();
      _apiClient.removeAuthToken();
      return const Right(true);
    } catch (e) {
      return Left(ItemError(message: e.toString(), code: 'LOGOUT_FAILED'));
    }
  }

  @override
  Future<Either<ItemError, UserModel>> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return const Left(
          ItemError(message: 'No hay usuario autenticado', code: 'NO_USER'),
        );
      }

      final idToken = await user.getIdToken();
      if (idToken == null) {
        return const Left(
          ItemError(
            message: 'No se pudo obtener el token',
            code: 'TOKEN_FAILED',
          ),
        );
      }

      // Configurar token en ApiClient
      _apiClient.setAuthToken(idToken);

      // Obtener perfil del backend
      final result = await _apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.getUser(user.uid),
        fromJson: (data) => data as Map<String, dynamic>,
      );

      return await result.fold(
        ifLeft: (error) => Future.value(Left(error)),
        ifRight: (data) => Future.value(Right(UserModel.fromJson(data))),
      );
    } catch (e) {
      return Left(ItemError(message: e.toString(), code: 'GET_USER_FAILED'));
    }
  }

  @override
  Future<Either<ItemError, String?>> getAuthToken() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return const Right(null);
      }

      final idToken = await user.getIdToken();
      return Right(idToken);
    } catch (e) {
      return Left(ItemError(message: e.toString(), code: 'GET_TOKEN_FAILED'));
    }
  }

  @override
  Future<Either<ItemError, bool>> sendPasswordReset(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(true);
    } on FirebaseAuthException catch (e) {
      return Left(
        ItemError(message: _getFirebaseErrorMessage(e.code), code: e.code),
      );
    } catch (e) {
      return Left(
        ItemError(message: e.toString(), code: 'PASSWORD_RESET_FAILED'),
      );
    }
  }

  /// Mensajes de error de Firebase en español
  String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No existe una cuenta con este correo electrónico';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con este correo electrónico';
      case 'weak-password':
        return 'La contraseña es muy débil';
      case 'invalid-email':
        return 'Correo electrónico inválido';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde';
      case 'operation-not-allowed':
        return 'Operación no permitida';
      case 'network-request-failed':
        return 'Error de conexión. Verifica tu internet';
      default:
        return 'Error de autenticación: $code';
    }
  }
}
