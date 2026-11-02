import 'package:computacion_movil/core/di/injection_container.dart';
import 'package:computacion_movil/features/auth/domain/entities/login_params.dart';
import 'package:computacion_movil/features/auth/domain/entities/register_profile_params.dart';
import 'package:computacion_movil/features/auth/domain/entities/user_entity.dart';
import 'package:computacion_movil/features/auth/domain/entities/user_register_params.dart';
import 'package:computacion_movil/features/auth/domain/usecases/login_use_case.dart';
import 'package:computacion_movil/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:computacion_movil/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthInitial());

  Future<void> login({required String email, required String password}) async {
    state = const AuthLoading();

    final loginUseCase = sl<LoginUseCase>();
    final result = await loginUseCase.execute(
      LoginParams(username: email, password: password),
    );

    result.fold(
      ifLeft: (failure) {
        state = AuthError(failure.message);
      },
      ifRight: (user) {
        state = AuthAuthenticated(user);
      },
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String nombre,
    required String apellido,
    required String telefono,
    required String nacionalidad,
  }) async {
    state = const AuthLoading();

    final signUpUseCase = sl<SignUpUseCase>();
    final result = await signUpUseCase.execute(
      authParams: UserRegisterParams(
        email: email,
        password: password,
        name: '$nombre $apellido',
      ),
      profileParams: RegisterProfileParams(
        nombre: nombre,
        apellido: apellido,
        telefono: telefono,
        nacionalidad: nacionalidad,
      ),
    );

    result.fold(
      ifLeft: (failure) {
        state = AuthError(failure.message);
      },
      ifRight: (user) {
        state = AuthAuthenticated(user);
      },
    );
  }

  Future<void> signOut() async {
    state = const AuthLoading();

    final signOutUseCase = sl<SignOutUseCase>();
    final result = await signOutUseCase.execute();

    result.fold(
      ifLeft: (failure) {
        state = AuthError(failure.message);
      },
      ifRight: (_) {
        state = const AuthUnauthenticated();
      },
    );
  }

  /// Limpiar error
  void clearError() {
    if (state is AuthError) {
      state = const AuthInitial();
    }
  }
}
