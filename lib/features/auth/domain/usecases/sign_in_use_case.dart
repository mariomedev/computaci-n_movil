import 'package:dart_either/dart_either.dart';
import 'package:computacion_movil/core/errors/failures.dart';
import 'package:computacion_movil/features/auth/domain/entities/auth_token_entity.dart';
import 'package:computacion_movil/features/auth/domain/entities/login_params.dart';
import 'package:computacion_movil/features/auth/domain/repo/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;

  const SignInUseCase(this.repository);

  Future<Either<Failure, AuthTokenEntity>> execute(LoginParams params) async {
    // Validate email format
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(params.username)) {
      return const Left(
        ValidationFailure(message: 'Email debe tener formato válido'),
      );
    }

    // Validate password not empty
    if (params.password.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Contraseña es requerida'));
    }

    final result = await repository.signInWithEmailPassword(params);
    return result.fold(
      ifLeft: (error) => Left(toServerFailure(error)),
      ifRight: (token) => Right(token),
    );
  }
}
