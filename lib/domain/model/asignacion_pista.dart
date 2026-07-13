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
<<<<<<< HEAD
    idAsignacionPista: json['id_asignacion_pista'],
    idPista: json['id_pista'],
    idVuelo: json['id_vuelo'],
    horaAsignacion: json['hora_asignacion'],
=======
    idAsignacionPista: json['id_asignacion_pista'] as int? ?? 0,
    idPista: json['id_pista'] as int? ?? 0,
    idVuelo: json['id_vuelo'] as int? ?? 0,
    horaAsignacion: json['hora_asignacion']as String? ?? '',
>>>>>>> 9c93e9e349b58cd690bce44268335422b70f5c53
  );

  Map<String, dynamic> toJson() => {
    'id_asignacion_pista': idAsignacionPista,
    'id_pista': idPista,
    'id_vuelo': idVuelo,
    'hora_asignacion': horaAsignacion,
  };
}