// lib/domain/model/asignacion_tripulacion.dart
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
    idAsignacion:    json['id_asignacion']    as int? ?? 0,
    idTripulacion:   json['id_tripulacion']   as int? ?? 0,
    idEmpleado:      json['id_empleado']      as int? ?? 0,
    fechaAsignacion: json['fecha_asignacion'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id_asignacion': idAsignacion,
    'id_tripulacion': idTripulacion,
    'id_empleado': idEmpleado,
    'fecha_asignacion': fechaAsignacion,
  };
}