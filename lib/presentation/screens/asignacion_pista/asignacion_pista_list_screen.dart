import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/asignacion_pista_provider.dart';

class AsignacionPistaListScreen extends ConsumerWidget {
  const AsignacionPistaListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(asignacionesPistaProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Asignaciones de Pista')),
      body: state.when(
        data: (asignaciones) => ListView.builder(
          itemCount: asignaciones.length,
          itemBuilder: (context, index) {
            final item = asignaciones[index];
            return ListTile(
              title: Text('Asignación ID: ${item.id}'), // Ajusta al campo de tu modelo
              subtitle: Text('Detalle: ...'), // Ajusta según tu modelo
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.push('/asignaciones-pista/detalle', extra: item);
              },
            );
          },
        ),
        error: (err, stack) => Center(child: Text('Error: $err')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/asignaciones-pista/form'),
        child: const Icon(Icons.add),
      ),
    );
  }
}