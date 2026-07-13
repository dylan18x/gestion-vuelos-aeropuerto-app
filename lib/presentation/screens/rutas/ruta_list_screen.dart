import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/ruta_provider.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_error_widget.dart';

class RutaListScreen extends ConsumerWidget {
  const RutaListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rutasAsync = ref.watch(rutasProvider);
    final isAuthenticated = ref.watch(authProvider).isAuthenticated;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Rutas')),
      floatingActionButton: isAuthenticated
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/rutas/nuevo'),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Nueva ruta'),
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.onAccent,
            )
          : null,
      body: rutasAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          error: e.toString(),
          onRetry: () => ref.invalidate(rutasProvider),
        ),
        data: (list) => list.isEmpty
            ? const AppEmptyState(message: 'No hay rutas registradas', icon: Icons.route_rounded)
            : RefreshIndicator(
                onRefresh: () async => ref.invalidate(rutasProvider),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final ruta = list[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.info.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.route_rounded, color: AppColors.info, size: 22),
                        ),
                        title: Text(
                          '${ruta.origen.nombre} → ${ruta.destino.nombre}',
                          style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          '${ruta.origen.ciudad} • ${ruta.destino.ciudad}',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                        onTap: () => context.push('/rutas/${ruta.id}'),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
