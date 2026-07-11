// lib/domain/model/clima.dart

/// Referencia ligera a Aeropuerto usada en Clima.
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
    id:         j['id_aeropuerto'] as int,
    nombre:     j['nombre']        as String,
    ciudad:     j['ciudad']        as String,
    codigoIata: j['codigo_iata']   as String,
  );
}

/// Tabla 22: Clima
class Clima {
  final int           idClima;
  final String        fecha;
  final double        temperatura;
  final String        condicion;
  final double        velocidadViento;
  final int           idAeropuerto;
  final AeropuertoRef? aeropuerto;

  const Clima({
    required this.idClima,
    required this.fecha,
    required this.temperatura,
    required this.condicion,
    required this.velocidadViento,
    required this.idAeropuerto,
    this.aeropuerto,
  });

  factory Clima.fromJson(Map<String, dynamic> j) {
    final aRef = j['id_aeropuerto'];
    return Clima(
      idClima:         j['id_clima']          as int,
      fecha:           j['fecha']             as String,
      temperatura:     _toDouble(j['temperatura']),
      condicion:       j['condicion']         as String,
      velocidadViento: _toDouble(j['velocidad_viento']),
      idAeropuerto:    aRef is int ? aRef : (aRef is Map ? aRef['id_aeropuerto'] as int : 0),
      aeropuerto:      aRef is Map ? AeropuertoRef.fromJson(aRef as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'fecha':           fecha,
    'temperatura':     temperatura,
    'condicion':       condicion,
    'velocidad_viento': velocidadViento,
    'id_aeropuerto':   idAeropuerto,
  };

  Clima copyWith({String? fecha, double? temperatura, String? condicion, double? velocidadViento}) => Clima(
    idClima:         idClima,
    fecha:           fecha           ?? this.fecha,
    temperatura:     temperatura     ?? this.temperatura,
    condicion:       condicion       ?? this.condicion,
    velocidadViento: velocidadViento ?? this.velocidadViento,
    idAeropuerto:    idAeropuerto,
    aeropuerto:      aeropuerto,
  );
}

double _toDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0.0;
}
