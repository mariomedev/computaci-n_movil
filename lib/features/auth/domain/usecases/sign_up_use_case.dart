import 'package:computacion_movil/features/auth/domain/repo/auth_repository.dart';
import 'package:dart_either/dart_either.dart';
import 'package:computacion_movil/core/errors/failures.dart';
import 'package:computacion_movil/features/auth/domain/entities/user_entity.dart';
import 'package:computacion_movil/features/auth/domain/entities/user_register_params.dart';
import 'package:computacion_movil/features/auth/domain/entities/register_profile_params.dart';

class SignUpUseCase {
  final AuthRepository repository;

  const SignUpUseCase(this.repository);

  Future<Either<Failure, UserEntity>> execute({
    required UserRegisterParams authParams,
    required RegisterProfileParams profileParams,
  }) async {
    // Validar email
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(authParams.email)) {
      return const Left(
        ValidationFailure(message: 'Email debe tener formato válido'),
      );
    }

    // Validar contraseña
    if (authParams.password.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Contraseña es requerida'));
    }
    if (authParams.password.length < 6) {
      return const Left(
        ValidationFailure(
          message: 'Contraseña debe tener al menos 6 caracteres',
        ),
      );
    }

    // Validar campos del perfil
    if (profileParams.nombre.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Nombre es requerido'));
    }
    if (profileParams.apellido.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Apellido es requerido'));
    }
    if (profileParams.telefono.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Teléfono es requerido'));
    }
    if (profileParams.nacionalidad.trim().isEmpty) {
      return const Left(
        ValidationFailure(message: 'Nacionalidad es requerida'),
      );
    }

    // Paso 1: Crear cuenta en Firebase
    final signUpResult = await repository.signUpWithEmailPassword(authParams);

    return await signUpResult.fold(
      ifLeft: (error) async => Left(toServerFailure(error)),
      ifRight: (authToken) async {
        // Paso 2: Registrar perfil en el backend usando el token obtenido
        final profileResult = await repository.registerProfile(
          authToken.idToken,
          profileParams,
        );

        return profileResult.fold(
          ifLeft: (error) => Left(toServerFailure(error)),
          ifRight: (user) => Right(user),
        );
      },
    );
  }
}
