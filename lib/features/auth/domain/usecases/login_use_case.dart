import 'package:computacion_movil/features/auth/domain/repo/auth_repository.dart';
import 'package:dart_either/dart_either.dart';
import 'package:computacion_movil/core/errors/failures.dart';
import 'package:computacion_movil/features/auth/domain/entities/login_params.dart';
import 'package:computacion_movil/features/auth/domain/entities/user_entity.dart';

class LoginUseCase {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> execute(LoginParams params) async {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(params.username)) {
      return const Left(
        ValidationFailure(
          message: 'Email debe tener formato válido (ejemplo@dominio.com)',
        ),
      );
    }

    if (params.password.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Contraseña es requerida'));
    }

    final signInResult = await repository.signInWithEmailPassword(params);

    return await signInResult.fold(
      ifLeft: (error) async => Left(toServerFailure(error)),
      ifRight: (authToken) async {
        final profileResult = await repository.getProfile(
          authToken.idToken,
          authToken.localId,
        );

        return profileResult.fold(
          ifLeft: (error) => Left(toServerFailure(error)),
          ifRight: (user) => Right(user),
        );
      },
    );
  }
}
