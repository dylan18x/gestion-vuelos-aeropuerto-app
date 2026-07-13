class AsignacionPista {
  final int idAsignacionPista;
  final int idPista;
  final int idVuelo;
  final String horaAsignacion;

  const AsignacionPista({
    required this.idAsignacionPista,
    required this.idPista,
    required this.idVuelo,
    required this.horaAsignacion,
  });

  factory AsignacionPista.fromJson(Map<String, dynamic> json) => AsignacionPista(
    idAsignacionPista: json['id_asignacion_pista'] as int? ?? 0,
    idPista: json['id_pista'] as int? ?? 0,
    idVuelo: json['id_vuelo'] as int? ?? 0,
    horaAsignacion: json['hora_asignacion']as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id_asignacion_pista': idAsignacionPista,
    'id_pista': idPista,
    'id_vuelo': idVuelo,
    'hora_asignacion': horaAsignacion,
  };
}