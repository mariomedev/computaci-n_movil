import 'package:dart_either/dart_either.dart';
import 'package:computacion_movil/core/errors/item_error.dart';
import 'package:computacion_movil/features/auth/domain/entities/login_params.dart';
import 'package:computacion_movil/features/auth/domain/entities/user_register_params.dart';

abstract class AuthRemoteDataSource<T> {
  Future<Either<ItemError, T>> login(LoginParams params);
  Future<Either<ItemError, bool>> logout();
  Future<Either<ItemError, T>> register(UserRegisterParams params);
  Future<Either<ItemError, T>> getCurrentUser();
  Future<Either<ItemError, bool>> sendPasswordReset(String email);
  Future<Either<ItemError, String?>> getAuthToken();
}
