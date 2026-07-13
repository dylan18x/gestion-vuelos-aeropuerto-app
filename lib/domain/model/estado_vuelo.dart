// lib/domain/model/estado_vuelo.dart

/// Referencia ligera usada por HistorialEstadoVuelo.
class EstadoVueloRef {
  final int    id;
  final String nombreEstado;

  const EstadoVueloRef({required this.id, required this.nombreEstado});

  factory EstadoVueloRef.fromJson(Map<String, dynamic> j) => EstadoVueloRef(
    id:           j['id_estado'] as int,
    nombreEstado: j['nombre_estado'] as String,
  );
}

/// Tabla 21: Estado_Vuelo
class EstadoVuelo {
  final int    idEstado;
  final String nombreEstado;
  final String descripcion;

  const EstadoVuelo({
    required this.idEstado,
    required this.nombreEstado,
    required this.descripcion,
  });

  factory EstadoVuelo.fromJson(Map<String, dynamic> j) => EstadoVuelo(
    idEstado:     j['id_estado']    as int,
    nombreEstado: j['nombre_estado'] as String,
    descripcion:  j['descripcion']  as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'nombre_estado': nombreEstado,
    'descripcion':   descripcion,
  };

  EstadoVuelo copyWith({String? nombreEstado, String? descripcion}) => EstadoVuelo(
    idEstado:     idEstado,
    nombreEstado: nombreEstado ?? this.nombreEstado,
    descripcion:  descripcion  ?? this.descripcion,
  );
}
