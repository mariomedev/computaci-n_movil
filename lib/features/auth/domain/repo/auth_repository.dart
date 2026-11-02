import 'package:dart_either/dart_either.dart';
import 'package:computacion_movil/core/errors/item_error.dart';
import 'package:computacion_movil/features/auth/domain/entities/auth_token_entity.dart';
import 'package:computacion_movil/features/auth/domain/entities/user_entity.dart';
import 'package:computacion_movil/features/auth/domain/entities/login_params.dart';
import 'package:computacion_movil/features/auth/domain/entities/register_profile_params.dart';
import 'package:computacion_movil/features/auth/domain/entities/user_register_params.dart';

abstract class AuthRepository {
  // Firebase Authentication
  Future<Either<ItemError, AuthTokenEntity>> signInWithEmailPassword(
    LoginParams params,
  );
  Future<Either<ItemError, AuthTokenEntity>> signUpWithEmailPassword(
    UserRegisterParams params,
  );
  Future<Either<ItemError, bool>> signOut();
  Future<Either<ItemError, AuthTokenEntity?>> getCurrentToken();

  // Backend API
  Future<Either<ItemError, UserEntity>> registerProfile(
    String idToken,
    RegisterProfileParams params,
  );
  Future<Either<ItemError, UserEntity>> getProfile(String idToken, String uid);
  Future<Either<ItemError, UserEntity>> updateProfile(
    String idToken,
    String uid,
    RegisterProfileParams params,
  );
}
