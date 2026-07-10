class Empleado {
  final int    id;
  final String nombre;
  final String cargo;

  const Empleado({
    required this.id,
    required this.nombre,
    required this.cargo,
  });

  factory Empleado.fromJson(Map<String, dynamic> j) => Empleado(
    id:     j['id']     as int,
    nombre: j['nombre'] as String,
    cargo:  j['cargo']  as String,
  );

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'cargo':  cargo,
  };

  static Empleado empty() => const Empleado(id: 0, nombre: '', cargo: '');

  Empleado copyWith({String? nombre, String? cargo}) => Empleado(
    id:     id,
    nombre: nombre ?? this.nombre,
    cargo:  cargo  ?? this.cargo,
  );
}

class PaginatedEmpleados {
  final int             count;
  final String?         next;
  final List<Empleado>  results;

  const PaginatedEmpleados({required this.count, required this.next, required this.results});

  factory PaginatedEmpleados.fromJson(Map<String, dynamic> j) => PaginatedEmpleados(
    count:   j['count'] as int,
    next:    j['next']  as String?,
    results: (j['results'] as List)
        .map((e) => Empleado.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}