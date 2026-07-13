// lib/domain/model/terminal.dart

class Terminal {
  final int    idTerminal;
  final String numero;
  final int    idAeropuerto;

  const Terminal({
    required this.idTerminal,
    required this.numero,
    required this.idAeropuerto,
  });

  factory Terminal.fromJson(Map<String, dynamic> j) => Terminal(
    idTerminal:   j['id_terminal']   as int,
    numero:       j['numero'].toString(),
    idAeropuerto: j['id_aeropuerto'] is int
        ? j['id_aeropuerto'] as int
        : (j['id_aeropuerto'] is Map ? (j['id_aeropuerto'] as Map)['id_aeropuerto'] as int : 0),
  );

  Map<String, dynamic> toJson() => {
    'numero':        numero,
    'id_aeropuerto': idAeropuerto,
  };

  Terminal copyWith({String? numero, int? idAeropuerto}) => Terminal(
    idTerminal:   idTerminal,
    numero:       numero        ?? this.numero,
    idAeropuerto: idAeropuerto  ?? this.idAeropuerto,
  );
}
