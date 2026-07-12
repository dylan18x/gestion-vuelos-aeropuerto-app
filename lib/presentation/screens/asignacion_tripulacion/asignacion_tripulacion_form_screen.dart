import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsignacionTripulacionFormScreen extends ConsumerWidget {
  const AsignacionTripulacionFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Asignación Tripulación')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(decoration: InputDecoration(labelText: 'ID Tripulación')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: const Text('Guardar'))
          ],
        ),
      ),
    );
  }
}