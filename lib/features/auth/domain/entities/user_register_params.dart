class UserRegisterParams {
  final String email;
  final String password;
  final String? name;
  final Map<String, dynamic>? metadata;

  const UserRegisterParams({
    required this.email,
    required this.password,
    this.name,
    this.metadata,
  });

  UserRegisterParams copyWith({
    String? email,
    String? password,
    String? name,
    Map<String, dynamic>? metadata,
  }) {
    return UserRegisterParams(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      metadata: metadata ?? this.metadata,
    );
  }
}
