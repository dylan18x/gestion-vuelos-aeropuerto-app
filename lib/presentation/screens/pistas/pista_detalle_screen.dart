import 'package:flutter/material.dart';
import '../../../domain/model/pista.dart';

class PistaDetalleScreen extends StatelessWidget {
  final Pista pista;
  const PistaDetalleScreen({super.key, required this.pista});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pista ID: ${pista.id}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${pista.id}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            // Agrega aquí los demás campos de tu modelo Pista
          ],
        ),
      ),
    );
  }
}