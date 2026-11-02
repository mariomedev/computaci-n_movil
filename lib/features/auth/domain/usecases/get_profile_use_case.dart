import 'package:dart_either/dart_either.dart';
import 'package:computacion_movil/core/errors/failures.dart';
import 'package:computacion_movil/features/auth/domain/entities/user_entity.dart';
import 'package:computacion_movil/features/auth/domain/repo/auth_repository.dart';

class GetProfileUseCase {
  final AuthRepository repository;

  const GetProfileUseCase(this.repository);
  Future<Either<Failure, UserEntity>> execute({
    required String idToken,
    required String uid,
  }) async {
    final result = await repository.getProfile(idToken, uid);
    return result.fold(
      ifLeft: (error) => Left(toServerFailure(error)),
      ifRight: (user) => Right(user),
    );
  }
}
