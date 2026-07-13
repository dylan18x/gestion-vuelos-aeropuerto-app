// lib/domain/model/asignacion_tripulacion.dart
class AsignacionTripulacion {
  final int idAsignacion;
  final int idVuelo;
  final int idEmpleado;

  const AsignacionTripulacion({
    required this.idAsignacion,
    required this.idVuelo,
    required this.idEmpleado,
  });

  factory AsignacionTripulacion.fromJson(Map<String, dynamic> json) => AsignacionTripulacion(
    idAsignacion:    json['id_asignacion'],
    idVuelo:   json['id_vuelo'],
    idEmpleado:      json['id_empleado'],
  );

  Map<String, dynamic> toJson() => {
    'id_asignacion': idAsignacion,
    'id_vuelo': idVuelo,
    'id_empleado': idEmpleado,
  };
}