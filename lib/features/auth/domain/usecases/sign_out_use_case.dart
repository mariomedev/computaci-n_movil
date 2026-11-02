import 'package:dart_either/dart_either.dart';
import 'package:computacion_movil/core/errors/failures.dart';
import 'package:computacion_movil/features/auth/domain/repo/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository repository;

  const SignOutUseCase(this.repository);

  Future<Either<Failure, bool>> execute() async {
    final result = await repository.signOut();
    return result.fold(
      ifLeft: (error) => Left(toServerFailure(error)),
      ifRight: (success) => Right(success),
    );
  }
}
