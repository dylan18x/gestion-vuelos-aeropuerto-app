class Empleado {
  final int    id;
  final String nombre;
  final String cargo;
  final String? imageUrl;

  const Empleado({
    required this.id,
    required this.nombre,
    required this.cargo,
    this.imageUrl,
  });

  factory Empleado.fromJson(Map<String, dynamic> j) => Empleado(
    id:        j['id'] as int,
    nombre:    j['nombre'] as String,
    cargo:     j['cargo'] as String,
    imageUrl:  j['image_url'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'cargo':  cargo,
  };

  static Empleado empty() => const Empleado(
    id: 0,
    nombre: '',
    cargo: '',
    imageUrl: null,
  );

  Empleado copyWith({
    String? nombre,
    String? cargo,
    String? imageUrl,
  }) => Empleado(
    id:        id,
    nombre:    nombre ?? this.nombre,
    cargo:     cargo ?? this.cargo,
    imageUrl:  imageUrl ?? this.imageUrl,
  );
}


class PaginatedEmpleados {
  final int             count;
  final String?         next;
  final List<Empleado>  results;

  const PaginatedEmpleados({
    required this.count,
    required this.next,
    required this.results,
  });

  factory PaginatedEmpleados.fromJson(Map<String, dynamic> j) => PaginatedEmpleados(
    count:   j['count'] as int,
    next:    j['next'] as String?,
    results: (j['results'] as List)
        .map((e) => Empleado.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}