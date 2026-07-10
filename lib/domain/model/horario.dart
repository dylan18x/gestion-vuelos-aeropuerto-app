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
        id: j['id'] as int,
        codigoVuelo: j['codigo_vuelo'] as String,
        fecha: j['fecha'] as String,
        estado: j['estado'] as String,
      );
}

class Horario {
  final int    id;
  final String salidaProgramada;  
  final String llegadaProgramada;
  final int    idVuelo;

  const Horario({
    required this.id,
    required this.salidaProgramada,
    required this.llegadaProgramada,
    required this.idVuelo,
  });

  factory Horario.fromJson(Map<String, dynamic> j) => Horario(
    id:                j['id']                 as int,
    salidaProgramada:  j['salida_programada']  as String,
    llegadaProgramada: j['llegada_programada'] as String,
    idVuelo:           j['id_vuelo']           as int,
  );

  Map<String, dynamic> toJson() => {
    'salida_programada':  salidaProgramada,
    'llegada_programada': llegadaProgramada,
    'id_vuelo':            idVuelo,
  };

  Horario copyWith({String? salidaProgramada, String? llegadaProgramada}) => Horario(
    id:                id,
    salidaProgramada:  salidaProgramada  ?? this.salidaProgramada,
    llegadaProgramada: llegadaProgramada ?? this.llegadaProgramada,
    idVuelo:           idVuelo,
  );
}