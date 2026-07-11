// lib/domain/model/registro_vuelo.dart

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

class RegistroVuelo {
  final int id;
  final String? horaRealSalida;  // 'String?' porque en Django es null=True
  final String? horaRealLlegada; // 'String?' porque en Django es null=True
  final VueloRef? vuelo;

  const RegistroVuelo({
    required this.id,
    this.horaRealSalida,
    this.horaRealLlegada,
    this.vuelo,
  });

  factory RegistroVuelo.fromJson(Map<String, dynamic> j) => RegistroVuelo(
    id:              j['id']                as int,
    horaRealSalida:  j['hora_real_salida']  as String?,
    horaRealLlegada: j['hora_real_llegada'] as String?,
    vuelo:           j['id_vuelo'] != null
                     ? VueloRef.fromJson(j['id_vuelo'] as Map<String, dynamic>)
                     : null,
  );

  Map<String, dynamic> toJson() => {
    'hora_real_salida':  horaRealSalida,
    'hora_real_llegada': horaRealLlegada,
  };

  Map<String, dynamic> asignarVueloJson(int idVuelo) => {'id_vuelo': idVuelo};

  static RegistroVuelo empty() => const RegistroVuelo(id: 0);

  RegistroVuelo copyWith({String? horaRealSalida, String? horaRealLlegada, VueloRef? vuelo}) => RegistroVuelo(
    id:              id,
    horaRealSalida:  horaRealSalida  ?? this.horaRealSalida,
    horaRealLlegada: horaRealLlegada ?? this.horaRealLlegada,
    vuelo:           vuelo           ?? this.vuelo,
  );
}

class PaginatedRegistrosVuelo {
  final int                  count;
  final String?              next;
  final List<RegistroVuelo>  results;

  const PaginatedRegistrosVuelo({required this.count, required this.next, required this.results});

  factory PaginatedRegistrosVuelo.fromJson(Map<String, dynamic> j) => PaginatedRegistrosVuelo(
    count:   j['count'] as int,
    next:    j['next']  as String?,
    results: (j['results'] as List)
        .map((e) => RegistroVuelo.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}