// lib/domain/model/aeropuerto.dart

class Aeropuerto {
  final int    idAeropuerto;
  final String nombre;
  final String ciudad;
  final String pais;
  final String codigoIata;
  final String? imageUrl;

  const Aeropuerto({
    required this.idAeropuerto,
    required this.nombre,
    required this.ciudad,
    required this.pais,
    required this.codigoIata,
    this.imageUrl,
  });

  factory Aeropuerto.fromJson(Map<String, dynamic> j) => Aeropuerto(
    idAeropuerto: j['id_aeropuerto'] as int,
    nombre:       j['nombre']        as String,
    ciudad:       j['ciudad']        as String,
    pais:         j['pais']          as String,
    codigoIata:   j['codigo_iata']   as String,
    imageUrl: j['image_url'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'nombre':      nombre,
    'ciudad':      ciudad,
    'pais':        pais,
    'codigo_iata': codigoIata,
  };

  Aeropuerto copyWith({
    String? nombre, String? ciudad, String? pais, String? codigoIata,String? imageUrl,
  }) => Aeropuerto(
    idAeropuerto: idAeropuerto,
    nombre:       nombre      ?? this.nombre,
    ciudad:       ciudad      ?? this.ciudad,
    pais:         pais        ?? this.pais,
    codigoIata:   codigoIata  ?? this.codigoIata,
    imageUrl: imageUrl ?? this.imageUrl,
  );
}
