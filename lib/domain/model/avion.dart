// lib/domain/model/avion.dart

class Avion {
  final int    idAvion;
  final String modelo;
  final int    capacidad;
  final String matricula;
  final int    idAerolinea;
  final String? imageUrl;

  const Avion({
    required this.idAvion,
    required this.modelo,
    required this.capacidad,
    required this.matricula,
    required this.idAerolinea,
    this.imageUrl,
  });

  factory Avion.fromJson(Map<String, dynamic> j) {
    final aRef = j['id_aerolinea'];
    return Avion(
      idAvion:     j['id_avion']   as int,
      modelo:      j['modelo']     as String,
      capacidad:   j['capacidad']  is int ? j['capacidad'] as int : int.tryParse(j['capacidad'].toString()) ?? 0,
      matricula:   j['matricula']  as String,
      idAerolinea: aRef is int ? aRef : (aRef is Map ? aRef['id_aerolinea'] as int : 0),
      imageUrl: j['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'modelo':      modelo,
    'capacidad':   capacidad,
    'matricula':   matricula,
    'id_aerolinea': idAerolinea,
  };

  Avion copyWith({String? modelo, int? capacidad, String? matricula, int? idAerolinea,String? imageUrl,}) => Avion(
    idAvion:     idAvion,
    modelo:      modelo      ?? this.modelo,
    capacidad:   capacidad   ?? this.capacidad,
    matricula:   matricula   ?? this.matricula,
    idAerolinea: idAerolinea ?? this.idAerolinea,
  );
}
