import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/asignacion_tripulacion_provider.dart';

class AsignacionTripulacionListScreen extends ConsumerWidget {
  const AsignacionTripulacionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(asignacionesTripulacionProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Asignaciones de Tripulación')),
      body: state.when(
        data: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (_, i) => ListTile(
            title: Text('Tripulación ID: ${data[i].id}'),
            onTap: () => context.push('/asignaciones-tripulacion/detalle', extra: data[i]),
          ),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}