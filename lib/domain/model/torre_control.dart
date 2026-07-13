<<<<<<< HEAD
class TorreControl {
  final int idTorre;
  final String nombre;
  final String ubicacion;
=======
// lib/domain/model/torre_control.dart

class AeropuertoRef {
  final int id;
  final String nombre;
  final String ciudad;
  final String pais;
  final String codigoIata;

  const AeropuertoRef({
    required this.id,
    required this.nombre,
    required this.ciudad,
    required this.pais,
    required this.codigoIata,
  });

  factory AeropuertoRef.fromJson(Map<String, dynamic> j) => AeropuertoRef(
    id:         j['id']          as int,
    nombre:     j['nombre']      as String,
    ciudad:     j['ciudad']      as String,
    pais:       j['pais']        as String,
    codigoIata: j['codigo_iata'] as String,
  );
}

class TorreControl {
  final int    idTorre;
  final String nombre;
  final String frecuencia;
  final int    idAeropuerto; // o AeropuertoRef si tu API lo anida como objeto
>>>>>>> 9c93e9e349b58cd690bce44268335422b70f5c53

  const TorreControl({
    required this.idTorre,
    required this.nombre,
<<<<<<< HEAD
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
=======
    required this.frecuencia,
    required this.idAeropuerto,
  });

  factory TorreControl.fromJson(Map<String, dynamic> json) => TorreControl(
    idTorre:      json['id_torre']      as int,
    nombre:       json['nombre']        as String,
    frecuencia:   json['frecuencia']    as String,
    idAeropuerto: json['id_aeropuerto'] as int,
  );

  Map<String, dynamic> toJson() => {
    'nombre':        nombre,
    'frecuencia':    frecuencia,
    'id_aeropuerto': idAeropuerto,
>>>>>>> 9c93e9e349b58cd690bce44268335422b70f5c53
  };
}