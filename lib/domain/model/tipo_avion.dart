// lib/domain/model/tipo_avion.dart

class TipoAvion {
  final int    idTipo;
  final String fabricante;
  final String modelo;
  final String alcance;

  const TipoAvion({
    required this.idTipo,
    required this.fabricante,
    required this.modelo,
    required this.alcance,
  });

  factory TipoAvion.fromJson(Map<String, dynamic> j) => TipoAvion(
    idTipo:     j['id_tipo']    as int,
    fabricante: j['fabricante'] as String,
    modelo:     j['modelo']     as String,
    alcance:    j['alcance'].toString(),
  );

  Map<String, dynamic> toJson() => {
    'fabricante': fabricante,
    'modelo':     modelo,
    'alcance':    alcance,
  };

  TipoAvion copyWith({String? fabricante, String? modelo, String? alcance}) => TipoAvion(
    idTipo:     idTipo,
    fabricante: fabricante ?? this.fabricante,
    modelo:     modelo     ?? this.modelo,
    alcance:    alcance    ?? this.alcance,
  );
}
