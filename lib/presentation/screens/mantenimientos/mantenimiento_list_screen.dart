// lib/presentation/screens/mantenimientos/mantenimiento_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/formatters.dart';
import '../../../theme/app_colors.dart';
import '../../providers/mantenimiento_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_error_widget.dart';

class MantenimientoListScreen extends ConsumerWidget {
  const MantenimientoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mantenimientosAsync = ref.watch(mantenimientosProvider);
    final isAdmin = ref.watch(authProvider).isAdmin;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Mantenimientos')),
      floatingActionButton: isAdmin
        ? FloatingActionButton.extended(
            onPressed: () => context.push('/mantenimientos/nuevo'),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Nuevo'),
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.onAccent,
          )
        : null,
      body: mantenimientosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(error: e.toString(), onRetry: () => ref.invalidate(mantenimientosProvider)),
        data: (list) => list.isEmpty
          ? const AppEmptyState(message: 'No hay mantenimientos registrados', icon: Icons.build_circle_rounded)
          : RefreshIndicator(
              onRefresh: () async => ref.invalidate(mantenimientosProvider),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final a = list[i];
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
                          color: const Color(0xFF14B8A6).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.build_circle_rounded, color: Color(0xFF14B8A6), size: 22),
                      ),
                      title: Text('Avión ID: ${a.idAvion}', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                      subtitle: Text('Estado: ${a.estado} • Fecha: ${formatDate(a.fecha)}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      onTap: () => context.push('/mantenimientos/${a.idMantenimiento}'),
                    ),
                  );
                },
              ),
            ),
      ),
    );
  }
}
