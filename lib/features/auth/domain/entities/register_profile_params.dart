class RegisterProfileParams {
  final String nombre;
  final String apellido;
  final String telefono;
  final String nacionalidad;

  const RegisterProfileParams({
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.nacionalidad,
  });

  RegisterProfileParams copyWith({
    String? nombre,
    String? apellido,
    String? telefono,
    String? nacionalidad,
  }) {
    return RegisterProfileParams(
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      telefono: telefono ?? this.telefono,
      nacionalidad: nacionalidad ?? this.nacionalidad,
    );
  }
}
