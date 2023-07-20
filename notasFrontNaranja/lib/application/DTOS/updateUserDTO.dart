class updateUserDTO {
  String idUsuario;
  String nombre;
  String correo;
  String clave;
  DateTime fechaNacimiento;
  bool suscripcion;

  updateUserDTO(
      {required this.idUsuario,
      required this.nombre,
      required this.correo,
      required this.clave,
      required this.fechaNacimiento,
      required this.suscripcion});

  String getId() => idUsuario;
  String getName() => nombre;
  String getEmail() => correo;
  String getPassword() => clave;
  DateTime getBirthDay() => fechaNacimiento;
  bool getSuscription() => suscripcion;
}
