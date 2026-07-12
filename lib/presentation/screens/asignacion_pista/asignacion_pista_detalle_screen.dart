import 'package:flutter/material.dart';
import '../../../domain/model/asignacion_pista.dart';

class AsignacionPistaDetalleScreen extends StatelessWidget {
  final AsignacionPista asignacion;
  const AsignacionPistaDetalleScreen({super.key, required this.asignacion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle Asignación Pista')),
      body: Center(child: Text('ID: ${asignacion.id}')),
    );
  }
}