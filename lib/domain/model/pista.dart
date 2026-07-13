class Pista {
  final int idPista;
  final String codigo;
  final String estado;

  const Pista({
    required this.idPista,
    required this.codigo,
    required this.estado,
  });

  factory Pista.fromJson(Map<String, dynamic> json) => Pista(
    idPista: json['id_pista'],
    codigo: json['codigo'],
    estado: json['estado'],
  );

  Map<String, dynamic> toJson() => {
    'id_pista': idPista,
    'codigo': codigo,
    'estado': estado,
  };
}
