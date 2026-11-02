class LoginParams {
  final String username;
  final String password;

  const LoginParams({
    required this.username,
    required this.password,
  });

  LoginParams copyWith({
    String? username,
    String? password,
  }) {
    return LoginParams(
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}
