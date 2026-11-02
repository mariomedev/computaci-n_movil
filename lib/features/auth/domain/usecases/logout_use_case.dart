import 'package:computacion_movil/features/auth/domain/repo/auth_repository.dart';
import 'package:dart_either/dart_either.dart';
import 'package:computacion_movil/core/errors/failures.dart';

class LogoutUseCase {
  final AuthRepository repository;

  const LogoutUseCase(this.repository);

  Future<Either<Failure, bool>> execute() async {
    final result = await repository.signOut();
    return result.fold(
      ifLeft: (error) => Left(toServerFailure(error)),
      ifRight: (success) => Right(success),
    );
  }
}
