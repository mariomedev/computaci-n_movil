import 'package:dart_either/dart_either.dart';
import 'package:computacion_movil/core/errors/failures.dart';
import 'package:computacion_movil/features/auth/domain/entities/user_entity.dart';
import 'package:computacion_movil/features/auth/domain/entities/register_profile_params.dart';
import 'package:computacion_movil/features/auth/domain/repo/auth_repository.dart';

class RegisterProfileUseCase {
  final AuthRepository repository;

  const RegisterProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> execute({
    required String idToken,
    required RegisterProfileParams params,
  }) async {
    // Validate fields not empty
    if (params.nombre.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Nombre es requerido'));
    }
    if (params.apellido.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Apellido es requerido'));
    }
    if (params.telefono.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Teléfono es requerido'));
    }
    if (params.nacionalidad.trim().isEmpty) {
      return const Left(
        ValidationFailure(message: 'Nacionalidad es requerida'),
      );
    }

    final result = await repository.registerProfile(idToken, params);
    return result.fold(
      ifLeft: (error) => Left(toServerFailure(error)),
      ifRight: (user) => Right(user),
    );
  }
}
