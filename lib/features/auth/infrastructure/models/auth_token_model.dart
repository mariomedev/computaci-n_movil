import 'package:computacion_movil/features/auth/domain/entities/auth_token_entity.dart';

class AuthTokenModel {
  final String idToken;
  final String localId;
  final String refreshToken;
  final int expiresIn;

  const AuthTokenModel({
    required this.idToken,
    required this.localId,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    final expiresInValue = json['expiresIn'];
    final expiresInInt = expiresInValue is int
        ? expiresInValue
        : int.parse(expiresInValue.toString());

    return AuthTokenModel(
      idToken: json['idToken'] as String,
      localId: json['localId'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresIn: expiresInInt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idToken': idToken,
      'localId': localId,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn.toString(),
    };
  }

  AuthTokenEntity toEntity() {
    return AuthTokenEntity(
      idToken: idToken,
      localId: localId,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
    );
  }
}
