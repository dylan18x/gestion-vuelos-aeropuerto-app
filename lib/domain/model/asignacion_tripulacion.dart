class AsignacionTripulacion {
  final int idAsignacion;
  final int idTripulacion;
  final int idEmpleado;
  final String fechaAsignacion;

  const AsignacionTripulacion({
    required this.idAsignacion,
    required this.idTripulacion,
    required this.idEmpleado,
    required this.fechaAsignacion,
  });

  factory AsignacionTripulacion.fromJson(Map<String, dynamic> json) => AsignacionTripulacion(
    idAsignacion: json['id_asignacion'],
    idTripulacion: json['id_tripulacion'],
    idEmpleado: json['id_empleado'],
    fechaAsignacion: json['fecha_asignacion'],
  );

  Map<String, dynamic> toJson() => {
    'id_asignacion': idAsignacion,
    'id_tripulacion': idTripulacion,
    'id_empleado': idEmpleado,
    'fecha_asignacion': fechaAsignacion,
  };
}