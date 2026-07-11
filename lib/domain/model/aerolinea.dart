// lib/domain/model/aerolinea.dart

class Aerolinea {
  final int    idAerolinea;
  final String nombre;
  final String pais;

  const Aerolinea({
    required this.idAerolinea,
    required this.nombre,
    required this.pais,
  });

  factory Aerolinea.fromJson(Map<String, dynamic> j) => Aerolinea(
    idAerolinea: j['id_aerolinea'] as int,
    nombre:      j['nombre']       as String,
    pais:        j['pais']         as String,
  );

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'pais':   pais,
  };

  Aerolinea copyWith({String? nombre, String? pais}) => Aerolinea(
    idAerolinea: idAerolinea,
    nombre:      nombre ?? this.nombre,
    pais:        pais   ?? this.pais,
  );
}
