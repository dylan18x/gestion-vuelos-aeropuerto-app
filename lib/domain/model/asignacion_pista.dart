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
    idAsignacionPista: json['id_asignacion_pista'],
    idPista: json['id_pista'],
    idVuelo: json['id_vuelo'],
    horaAsignacion: json['hora_asignacion'],
  );

  Map<String, dynamic> toJson() => {
    'id_asignacion_pista': idAsignacionPista,
    'id_pista': idPista,
    'id_vuelo': idVuelo,
    'hora_asignacion': horaAsignacion,
  };
}