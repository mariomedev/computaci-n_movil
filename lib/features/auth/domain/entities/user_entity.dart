class UserEntity {
  final String uid;
  final String email;
  final String nombre;
  final String apellido;
  final String telefono;
  final String nacionalidad;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.nacionalidad,
  });

  UserEntity copyWith({
    String? uid,
    String? email,
    String? nombre,
    String? apellido,
    String? telefono,
    String? nacionalidad,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      telefono: telefono ?? this.telefono,
      nacionalidad: nacionalidad ?? this.nacionalidad,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}
