// lib/domain/model/incidente.dart

class VueloRef {
  final int id;
  final String codigoVuelo;
  final String fecha;
  final String estado;

  const VueloRef({
    required this.id,
    required this.codigoVuelo,
    required this.fecha,
    required this.estado,
  });

  factory VueloRef.fromJson(Map<String, dynamic> j) => VueloRef(
    id:          j['id']           as int,
    codigoVuelo: j['codigo_vuelo'] as String,
    fecha:       j['fecha']        as String,
    estado:      j['estado']       as String,
  );
}

class Incidente {
  final int id;
  final String descripcion;
  final String fecha; // Mapeado como String 'YYYY-MM-DD'
  final VueloRef? vuelo;

  const Incidente({
    required this.id,
    required this.descripcion,
    required this.fecha,
    this.vuelo,
  });

  factory Incidente.fromJson(Map<String, dynamic> j) => Incidente(
    id:          j['id']          as int,
    descripcion: j['descripcion'] as String,
    fecha:       j['fecha']       as String,
    vuelo:       j['id_vuelo'] != null
                 ? VueloRef.fromJson(j['id_vuelo'] as Map<String, dynamic>)
                 : null,
  );

  Map<String, dynamic> toJson() => {
    'descripcion': descripcion,
    'fecha':       fecha,
  };

  Map<String, dynamic> asignarVueloJson(int idVuelo) => {'id_vuelo': idVuelo};

  static Incidente empty() => const Incidente(id: 0, descripcion: '', fecha: '');

  Incidente copyWith({String? descripcion, String? fecha, VueloRef? vuelo}) => Incidente(
    id:          id,
    descripcion: descripcion ?? this.descripcion,
    fecha:       fecha       ?? this.fecha,
    vuelo:       vuelo       ?? this.vuelo,
  );
}

class PaginatedIncidentes {
  final int              count;
  final String?          next;
  final List<Incidente>  results;

  const PaginatedIncidentes({required this.count, required this.next, required this.results});

  factory PaginatedIncidentes.fromJson(Map<String, dynamic> j) => PaginatedIncidentes(
    count:   j['count'] as int,
    next:    j['next']  as String?,
    results: (j['results'] as List)
        .map((e) => Incidente.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}