// lib/domain/model/autorizacion_vuelo.dart
class AutorizacionVuelo {
  final int idAutorizacion;
  final int idVuelo;
  final String tipoAutorizacion;
  final String fecha;
  final String estado;

  const AutorizacionVuelo({
    required this.idAutorizacion,
    required this.idVuelo,
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
  );

  Map<String, dynamic> toJson() => {
    'id_autorizacion': idAutorizacion,
    'id_vuelo': idVuelo,
    'tipo_autorizacion': tipoAutorizacion,
    'fecha': fecha,
    'estado': estado,
  };
}