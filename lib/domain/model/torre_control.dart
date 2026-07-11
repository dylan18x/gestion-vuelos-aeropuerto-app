class TorreControl {
  final int idTorre;
  final String nombre;
  final String ubicacion;

  const TorreControl({
    required this.idTorre,
    required this.nombre,
    required this.ubicacion,
  });

  factory TorreControl.fromJson(Map<String, dynamic> json) => TorreControl(
    idTorre: json['id_torre'],
    nombre: json['nombre'],
    ubicacion: json['ubicacion'],
  );

  Map<String, dynamic> toJson() => {
    'id_torre': idTorre,
    'nombre': nombre,
    'ubicacion': ubicacion,
  };
}