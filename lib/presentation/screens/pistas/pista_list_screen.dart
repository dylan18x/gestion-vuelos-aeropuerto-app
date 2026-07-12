import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/pista_provider.dart';

class PistaListScreen extends ConsumerWidget {
  const PistaListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pistasProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Pistas')),
      body: state.when(
        data: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (_, i) => ListTile(
            title: Text('Pista: ${data[i].id}'),
            onTap: () => context.push('/pistas/detalle', extra: data[i]),
          ),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/pistas/form'),
        child: const Icon(Icons.add),
      ),
    );
  }
}