// lib/domain/model/historial_estado_vuelo.dart
import 'estado_vuelo.dart';

class HistorialEstadoVuelo {
  final int            id;
  final String         fechaCambio;
  final String         observacion;
  final int            idVuelo;
  final EstadoVueloRef estado;

  const HistorialEstadoVuelo({
    required this.id,
    required this.fechaCambio,
    required this.observacion,
    required this.idVuelo,
    required this.estado,
  });

  factory HistorialEstadoVuelo.fromJson(Map<String, dynamic> j) => HistorialEstadoVuelo(
    id:          j['id']           as int,
    fechaCambio: j['fecha_cambio'] as String,
    observacion: j['observacion']  as String,
    idVuelo:     j['id_vuelo']     as int,
    estado:      EstadoVueloRef.fromJson(j['id_estado'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'observacion': observacion,
    'id_vuelo':    idVuelo,
    'id_estado':   estado.id,
  };
}