class Vuelo {
  final int       id;
  final String    codigoVuelo;
  final String    fecha;      
  final String    estado;    
  final AvionRef? avion; 

  const Vuelo({
    required this.id,
    required this.codigoVuelo,
    required this.fecha,
    required this.estado,
    this.avion,
  });

  factory Vuelo.fromJson(Map<String, dynamic> j) => Vuelo(
    id:          j['id']           as int,
    codigoVuelo: j['codigo_vuelo'] as String,
    fecha:       j['fecha']        as String,
    estado:      j['estado']       as String,
    avion:       j['id_avion'] != null
                 ? AvionRef.fromJson(j['id_avion'] as Map<String, dynamic>)
                 : null,
  );

  Map<String, dynamic> toJson() => {
    'codigo_vuelo': codigoVuelo,
    'fecha':        fecha,
    'estado':       estado,
  };

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