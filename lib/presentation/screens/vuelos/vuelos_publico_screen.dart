// lib/presentation/screens/vuelos/vuelos_publico_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/vuelo_provider.dart';

class VuelosPublicoScreen extends ConsumerWidget {
  const VuelosPublicoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vuelosAsync = ref.watch(vuelosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Tablero de vuelos')),
      body: vuelosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off, size: 40),
                const SizedBox(height: 12),
                Text('$err', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => ref.invalidate(vuelosProvider),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),

        data: (paginated) {
          if (paginated.results.isEmpty) {
            return const Center(child: Text('No hay vuelos registrados todavía.'));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(vuelosProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: paginated.results.length,
              itemBuilder: (context, index) {
                final vuelo = paginated.results[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(vuelo.codigoVuelo),
                    subtitle: Text('${vuelo.fecha} · ${vuelo.estado}'),
                    trailing: Text(vuelo.avion?.matricula ?? 'Sin avión asignado'),
                    onTap: () => context.push('/vuelos/${vuelo.id}'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}