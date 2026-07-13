<<<<<<< HEAD
class AutorizacionVuelo {
  final int idAutorizacion;
  final int idVuelo;
  final String estadoAutorizacion;
  final String fechaEmision;
=======
// lib/domain/model/autorizacion_vuelo.dart
class AutorizacionVuelo {
  final int idAutorizacion;
  final int idVuelo;
  final String tipoAutorizacion;
  final String fecha;
  final String estado;
>>>>>>> 9c93e9e349b58cd690bce44268335422b70f5c53

  const AutorizacionVuelo({
    required this.idAutorizacion,
    required this.idVuelo,
<<<<<<< HEAD
    required this.estadoAutorizacion,
    required this.fechaEmision,
  });

  factory AutorizacionVuelo.fromJson(Map<String, dynamic> json) => AutorizacionVuelo(
    idAutorizacion: json['id_autorizacion'],
    idVuelo: json['id_vuelo'],
    estadoAutorizacion: json['estado_autorizacion'],
    fechaEmision: json['fecha_emision'],
=======
    required this.tipoAutorizacion,
    required this.fecha,
    required this.estado,
  });

  factory AutorizacionVuelo.fromJson(Map<String, dynamic> json) => AutorizacionVuelo(
    idAutorizacion:   json['id_autorizacion']   as int? ?? 0,
    idVuelo:          json['id_vuelo']          as int? ?? 0,
    tipoAutorizacion: json['tipo_autorizacion'] as String? ?? '',
    fecha:            json['fecha']             as String? ?? '',
    estado:           json['estado']            as String? ?? '',
>>>>>>> 9c93e9e349b58cd690bce44268335422b70f5c53
  );

  Map<String, dynamic> toJson() => {
    'id_autorizacion': idAutorizacion,
    'id_vuelo': idVuelo,
<<<<<<< HEAD
    'estado_autorizacion': estadoAutorizacion,
    'fecha_emision': fechaEmision,
=======
    'tipo_autorizacion': tipoAutorizacion,
    'fecha': fecha,
    'estado': estado,
>>>>>>> 9c93e9e349b58cd690bce44268335422b70f5c53
  };
}