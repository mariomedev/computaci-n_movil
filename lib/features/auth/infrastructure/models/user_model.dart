import 'package:computacion_movil/features/auth/domain/entities/user_entity.dart';

class UserModel {
  final String uid;
  final String email;
  final String nombre;
  final String apellido;
  final String telefono;
  final String nacionalidad;

  const UserModel({
    required this.uid,
    required this.email,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.nacionalidad,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: (json['uid'] as String?) ?? (json['_id'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      nombre: (json['nombre'] as String?) ?? '',
      apellido: (json['apellido'] as String?) ?? '',
      telefono: (json['telefono'] as String?) ?? '',
      nacionalidad: (json['nacionalidad'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
      'nacionalidad': nacionalidad,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      nombre: nombre,
      apellido: apellido,
      telefono: telefono,
      nacionalidad: nacionalidad,
    );
  }
}
