class AutorizacionVuelo {
  final int idAutorizacion;
  final int idVuelo;
  final String estadoAutorizacion;
  final String fechaEmision;

  const AutorizacionVuelo({
    required this.idAutorizacion,
    required this.idVuelo,
    required this.estadoAutorizacion,
    required this.fechaEmision,
  });

  factory AutorizacionVuelo.fromJson(Map<String, dynamic> json) => AutorizacionVuelo(
    idAutorizacion: json['id_autorizacion'],
    idVuelo: json['id_vuelo'],
    estadoAutorizacion: json['estado_autorizacion'],
    fechaEmision: json['fecha_emision'],
  );

  Map<String, dynamic> toJson() => {
    'id_autorizacion': idAutorizacion,
    'id_vuelo': idVuelo,
    'estado_autorizacion': estadoAutorizacion,
    'fecha_emision': fechaEmision,
  };
}