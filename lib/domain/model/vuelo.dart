// lib/domain/model/vuelo.dart

/// Referencia ligera a Avión (tabla de tu compañero).
class AvionRef {
  final int    id;
  final String modelo;
  final String matricula;

  const AvionRef({required this.id, required this.modelo, required this.matricula});

  factory AvionRef.fromJson(Map<String, dynamic> j) => AvionRef(
    id:        j['id']        as int,
    modelo:    j['modelo']    as String,
    matricula: j['matricula'] as String,
  );
}

/// Convierte cualquier valor (String, int, double, null) a String de forma segura.
/// Evita el error "type 'int' is not a subtype of type 'String'" cuando
/// Django manda un campo como número (ej: estado con choices numéricos).
String _asString(dynamic value) {
  if (value == null) return '';
  return value.toString();
}

/// Tabla Vuelo: id_vuelo(PK), código_vuelo, fecha, estado, id_avion(FK)
class Vuelo {
  final int       id;
  final String    codigoVuelo;
  final String    fecha;      // "2026-07-09"
  final String    estado;     // texto plano: "Programado", "Retrasado"... (NO es FK aquí)
  final AvionRef? avion;      // null hasta que el TECNICO lo asigne

  const Vuelo({
    required this.id,
    required this.codigoVuelo,
    required this.fecha,
    required this.estado,
    this.avion,
  });

  factory Vuelo.fromJson(Map<String, dynamic> j) => Vuelo(
    id:          j['id']           as int,
    codigoVuelo: _asString(j['codigo_vuelo']),
    fecha:       _asString(j['fecha']),
    estado:      _asString(j['estado']),
    avion:       j['id_avion'] != null && j['id_avion'] is Map
                 ? AvionRef.fromJson(j['id_avion'] as Map<String, dynamic>)
                 : null,
  );

  /// Para crear/editar los datos base del vuelo.
  Map<String, dynamic> toJson() => {
    'codigo_vuelo': codigoVuelo,
    'fecha':        fecha,
    'estado':       estado,
  };

  /// Body para el endpoint de "asignar avión" (acción del TECNICO).
  Map<String, dynamic> asignarAvionJson(int idAvion) => {'id_avion': idAvion};

  static Vuelo empty() => const Vuelo(id: 0, codigoVuelo: '', fecha: '', estado: '');

  Vuelo copyWith({String? estado, AvionRef? avion}) => Vuelo(
    id:          id,
    codigoVuelo: codigoVuelo,
    fecha:       fecha,
    estado:      estado ?? this.estado,
    avion:       avion  ?? this.avion,
  );
}

/// Lista paginada de vuelos.
class PaginatedVuelos {
  final int          count;
  final String?      next;
  final List<Vuelo>  results;

  const PaginatedVuelos({required this.count, required this.next, required this.results});

  factory PaginatedVuelos.fromJson(Map<String, dynamic> j) => PaginatedVuelos(
    count:   j['count'] as int,
    next:    j['next']  as String?,
    results: (j['results'] as List)
        .map((e) => Vuelo.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}