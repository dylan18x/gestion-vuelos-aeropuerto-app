// lib/domain/model/control_trafico.dart

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

class ControlTrafico {
  final int id;
  final String autorizacion;
  final String hora; // Almacenada como String ISO8601 para fácil parseo
  final VueloRef? vuelo;

  const ControlTrafico({
    required this.id,
    required this.autorizacion,
    required this.hora,
    this.vuelo,
  });

  factory ControlTrafico.fromJson(Map<String, dynamic> j) => ControlTrafico(
    id:           j['id']           as int,
    autorizacion: j['autorizacion'] as String,
    hora:         j['hora']         as String,
    vuelo:        j['id_vuelo'] != null
                  ? VueloRef.fromJson(j['id_vuelo'] as Map<String, dynamic>)
                  : null,
  );

  Map<String, dynamic> toJson() => {
    'autorizacion': autorizacion,
    'hora':         hora,
  };

  Map<String, dynamic> asignarVueloJson(int idVuelo) => {'id_vuelo': idVuelo};

  static ControlTrafico empty() => const ControlTrafico(id: 0, autorizacion: '', hora: '');

  ControlTrafico copyWith({String? autorizacion, String? hora, VueloRef? vuelo}) => ControlTrafico(
    id:           id,
    autorizacion: autorizacion ?? this.autorizacion,
    hora:         hora         ?? this.hora,
    vuelo:        vuelo        ?? this.vuelo,
  );
}

class PaginatedControlesTrafico {
  final int            count;
  final String?        next;
  final List<ControlTrafico> results;

  const PaginatedControlesTrafico({required this.count, required this.next, required this.results});

  factory PaginatedControlesTrafico.fromJson(Map<String, dynamic> j) => PaginatedControlesTrafico(
    count:   j['count'] as int,
    next:    j['next']  as String?,
    results: (j['results'] as List)
        .map((e) => ControlTrafico.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}