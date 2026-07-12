import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/autorizacion_vuelo_provider.dart';

class AutorizacionListScreen extends ConsumerWidget {
  const AutorizacionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(autorizacionesVueloProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Autorizaciones de Vuelo')),
      body: state.when(
        data: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (_, i) => ListTile(
            title: Text('Vuelo ID: ${data[i].idVuelo}'),
            subtitle: Text('Estado: ${data[i].estado}'),
            onTap: () => context.push('/autorizaciones/detalle', extra: data[i]),
          ),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}