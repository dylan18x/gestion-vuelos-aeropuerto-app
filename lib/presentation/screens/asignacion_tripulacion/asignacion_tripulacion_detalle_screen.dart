import 'package:flutter/material.dart';
import '../../../domain/model/asignacion_tripulacion.dart';

class AsignacionTripulacionDetalleScreen extends StatelessWidget {
  final AsignacionTripulacion asignacion;
  const AsignacionTripulacionDetalleScreen({super.key, required this.asignacion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Asignación')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID Asignación: ${asignacion.id}', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}