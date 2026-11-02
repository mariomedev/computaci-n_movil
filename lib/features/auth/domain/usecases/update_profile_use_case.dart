import 'package:computacion_movil/features/auth/domain/repo/auth_repository.dart';
import 'package:dart_either/dart_either.dart';
import 'package:computacion_movil/core/errors/failures.dart';
import 'package:computacion_movil/features/auth/domain/entities/user_entity.dart';
import 'package:computacion_movil/features/auth/domain/entities/register_profile_params.dart';

class UpdateProfileUseCase {
  final AuthRepository repository;

  const UpdateProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> execute({
    required String idToken,
    required String uid,
    required RegisterProfileParams params,
  }) async {
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

    final result = await repository.updateProfile(idToken, uid, params);
    return result.fold(
      ifLeft: (error) => Left(toServerFailure(error)),
      ifRight: (user) => Right(user),
    );
  }
}
