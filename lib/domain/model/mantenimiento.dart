// lib/domain/model/mantenimiento.dart

class Mantenimiento {
  final int    idMantenimiento;
  final String fecha;
  final String estado;
  final int    idAvion;

  const Mantenimiento({
    required this.idMantenimiento,
    required this.fecha,
    required this.estado,
    required this.idAvion,
  });

  factory Mantenimiento.fromJson(Map<String, dynamic> j) {
    final aRef = j['id_avion'];
    return Mantenimiento(
      idMantenimiento: j['id_mantenimiento'] as int,
      fecha:           j['fecha']            as String,
      estado:          j['estado']           as String,
      idAvion:         aRef is int ? aRef : (aRef is Map ? aRef['id_avion'] as int : 0),
    );
  }

  Map<String, dynamic> toJson() => {
    'fecha':    fecha,
    'estado':   estado,
    'id_avion': idAvion,
  };

  Mantenimiento copyWith({String? fecha, String? estado, int? idAvion}) => Mantenimiento(
    idMantenimiento: idMantenimiento,
    fecha:           fecha   ?? this.fecha,
    estado:          estado  ?? this.estado,
    idAvion:         idAvion ?? this.idAvion,
  );
}
