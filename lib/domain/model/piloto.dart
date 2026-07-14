import 'empleado.dart';

class Piloto {
  final int      id;
  final String   licencia;
  final Empleado empleado;
  final String?  imageUrl;

  const Piloto({
    required this.id,
    required this.licencia,
    required this.empleado,
    this.imageUrl,
  });

  factory Piloto.fromJson(Map<String, dynamic> j) => Piloto(
    id:        j['id'] as int,
    licencia:  j['licencia'] as String,
    empleado:  Empleado.fromJson(j['id_empleado'] as Map<String, dynamic>),
    imageUrl:  j['image_url'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'licencia':    licencia,
    'id_empleado': empleado.id,
  };

  Piloto copyWith({
    String? licencia,
    String? imageUrl,
  }) => Piloto(
    id:        id,
    licencia:  licencia ?? this.licencia,
    empleado:  empleado,
    imageUrl:  imageUrl ?? this.imageUrl,
  );
}