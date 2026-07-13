// lib/domain/model/puerta_embarque.dart

class PuertaEmbarque {
  final int    idPuerta;
  final String numero;
  final int    idTerminal;

  const PuertaEmbarque({
    required this.idPuerta,
    required this.numero,
    required this.idTerminal,
  });

  factory PuertaEmbarque.fromJson(Map<String, dynamic> j) => PuertaEmbarque(
    idPuerta:   j['id_puerta']   as int,
    numero:     j['numero'].toString(),
    idTerminal: j['id_terminal'] is int
        ? j['id_terminal'] as int
        : (j['id_terminal'] is Map ? (j['id_terminal'] as Map)['id_terminal'] as int : 0),
  );

  Map<String, dynamic> toJson() => {
    'numero':      numero,
    'id_terminal': idTerminal,
  };

  PuertaEmbarque copyWith({String? numero, int? idTerminal}) => PuertaEmbarque(
    idPuerta:   idPuerta,
    numero:     numero     ?? this.numero,
    idTerminal: idTerminal ?? this.idTerminal,
  );
}
