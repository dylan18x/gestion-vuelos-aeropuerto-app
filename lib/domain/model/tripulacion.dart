import 'empleado.dart';

class Tripulacion {
  final int      id;
  final String   cargo;     
  final Empleado empleado;

  const Tripulacion({
    required this.id,
    required this.cargo,
    required this.empleado,
  });

  factory Tripulacion.fromJson(Map<String, dynamic> j) => Tripulacion(
    id:       j['id']       as int,
    cargo:    j['cargo']    as String,
    empleado: Empleado.fromJson(j['id_empleado'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'cargo':      cargo,
    'id_empleado': empleado.id,
  };

  Tripulacion copyWith({String? cargo}) => Tripulacion(
    id:       id,
    cargo:    cargo ?? this.cargo,
    empleado: empleado,
  );
}