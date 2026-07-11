// lib/presentation/screens/vuelos/vuelo_detalle_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/vuelo_provider.dart';

class VueloDetalleScreen extends ConsumerWidget {
  final int idVuelo;
  const VueloDetalleScreen({super.key, required this.idVuelo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vueloAsync = ref.watch(vueloDetalleProvider(idVuelo));

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del vuelo')),
      body: vueloAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('$err')),
        data: (vuelo) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(vuelo.codigoVuelo, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('Fecha: ${vuelo.fecha}'),
              Text('Estado: ${vuelo.estado}'),
              Text('Avión: ${vuelo.avion?.modelo ?? "Sin asignar"} '
                  '(${vuelo.avion?.matricula ?? "-"})'),
              // Aquí después agregamos: horario, escalas, historial de estado
            ],
          ),
        ),
      ),
    );
  }
}