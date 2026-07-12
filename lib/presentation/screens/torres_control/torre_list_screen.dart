import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/torre_control_provider.dart';

class TorreListScreen extends ConsumerWidget {
  const TorreListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final torresAsync = ref.watch(torresControlProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Torres de Control')),
      body: torresAsync.when(
        data: (torres) => ListView.builder(
          itemCount: torres.length,
          itemBuilder: (context, index) {
            final torre = torres[index];
            return ListTile(
              title: Text(torre.nombre),
              subtitle: Text('ID: ${torre.id}'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.push('/torres/detalle', extra: torre);
              },
            );
          },
        ),
        error: (err, stack) => Center(child: Text('Error: $err')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/torres/form'),
        child: const Icon(Icons.add),
      ),
    );
  }
}