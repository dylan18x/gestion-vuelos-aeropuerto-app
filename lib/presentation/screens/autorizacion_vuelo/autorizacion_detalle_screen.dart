import 'package:flutter/material.dart';
import '../../../domain/model/autorizacion_vuelo.dart';

class AutorizacionDetalleScreen extends StatelessWidget {
  final AutorizacionVuelo autorizacion;
  const AutorizacionDetalleScreen({super.key, required this.autorizacion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Autorización')),
      body: Column(
        children: [
          Text('ID Vuelo: ${autorizacion.idVuelo}'),
          Text('Estado: ${autorizacion.estado}'),
        ],
      ),
    );
  }
}