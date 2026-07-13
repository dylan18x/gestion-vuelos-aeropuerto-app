<<<<<<< HEAD
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
=======
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
>>>>>>> 9c93e9e349b58cd690bce44268335422b70f5c53
  );

  Map<String, dynamic> toJson() => {
    'id_asignacion': idAsignacion,
<<<<<<< HEAD
    'id_tripulacion': idTripulacion,
    'id_empleado': idEmpleado,
    'fecha_asignacion': fechaAsignacion,
=======
    'id_vuelo': idVuelo,
    'id_empleado': idEmpleado,
>>>>>>> 9c93e9e349b58cd690bce44268335422b70f5c53
  };
}