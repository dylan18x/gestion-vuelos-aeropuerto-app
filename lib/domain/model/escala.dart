// lib/domain/model/escala.dart
import 'ruta.dart'; // reutiliza AeropuertoRef

class Escala {
  final int           id;
  final int           idVuelo;
  final AeropuertoRef aeropuertoEscala;

  const Escala({
    required this.id,
    required this.idVuelo,
    required this.aeropuertoEscala,
  });

  factory Escala.fromJson(Map<String, dynamic> j) => Escala(
    id:               j['id']                 as int,
    idVuelo:          j['id_vuelo']            as int,
    aeropuertoEscala: AeropuertoRef.fromJson(j['aeropuerto_escala'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id_vuelo':          idVuelo,
    'aeropuerto_escala': aeropuertoEscala.id,
  };
}