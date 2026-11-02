class AuthTokenEntity {
  final String idToken;
  final String localId;
  final String refreshToken;
  final int expiresIn;

  const AuthTokenEntity({
    required this.idToken,
    required this.localId,
    required this.refreshToken,
    required this.expiresIn,
  });

  DateTime get expiresAt => DateTime.now().add(Duration(seconds: expiresIn));
  
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  AuthTokenEntity copyWith({
    String? idToken,
    String? localId,
    String? refreshToken,
    int? expiresIn,
  }) {
    return AuthTokenEntity(
      idToken: idToken ?? this.idToken,
      localId: localId ?? this.localId,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresIn: expiresIn ?? this.expiresIn,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthTokenEntity &&
        other.idToken == idToken &&
        other.localId == localId &&
        other.refreshToken == refreshToken &&
        other.expiresIn == expiresIn;
  }

  @override
  int get hashCode {
    return idToken.hashCode ^
        localId.hashCode ^
        refreshToken.hashCode ^
        expiresIn.hashCode;
  }
}
