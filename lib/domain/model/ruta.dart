class AeropuertoRef {
  final int    id;
  final String nombre;
  final String ciudad;
  final String codigoIata;

  const AeropuertoRef({
    required this.id,
    required this.nombre,
    required this.ciudad,
    required this.codigoIata,
  });

  factory AeropuertoRef.fromJson(Map<String, dynamic> j) => AeropuertoRef(
    id:         j['id']          as int,
    nombre:     j['nombre']      as String,
    ciudad:     j['ciudad']      as String,
    codigoIata: j['codigo_iata'] as String,
  );
}

class Ruta {
  final int            id;
  final AeropuertoRef  origen;
  final AeropuertoRef  destino;

  const Ruta({
    required this.id,
    required this.origen,
    required this.destino,
  });

  factory Ruta.fromJson(Map<String, dynamic> j) => Ruta(
    id:      j['id']      as int,
    origen:  AeropuertoRef.fromJson(j['origen']  as Map<String, dynamic>),
    destino: AeropuertoRef.fromJson(j['destino'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'origen':  origen.id,
    'destino': destino.id,
  };

  Ruta copyWith({AeropuertoRef? origen, AeropuertoRef? destino}) => Ruta(
    id:      id,
    origen:  origen  ?? this.origen,
    destino: destino ?? this.destino,
  );
}