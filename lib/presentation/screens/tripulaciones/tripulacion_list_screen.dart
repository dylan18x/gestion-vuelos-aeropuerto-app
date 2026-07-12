import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/tripulacion_provider.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_error_widget.dart';

class TripulacionListScreen extends ConsumerWidget {
  const TripulacionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripulacionesAsync = ref.watch(tripulacionesProvider);
    final isAuthenticated = ref.watch(authProvider).isAuthenticated;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Tripulación')),
      floatingActionButton: isAuthenticated
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/tripulacion/nuevo'),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Nueva tripulación'),
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.onAccent,
            )
          : null,
      body: tripulacionesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          error: e.toString(),
          onRetry: () => ref.invalidate(tripulacionesProvider),
        ),
        data: (list) => list.isEmpty
            ? const AppEmptyState(message: 'No hay tripulación registrada', icon: Icons.groups_rounded)
            : RefreshIndicator(
                onRefresh: () async => ref.invalidate(tripulacionesProvider),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final tripulacion = list[i];
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
                            color: AppColors.warning.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.groups_rounded, color: AppColors.warning, size: 22),
                        ),
                        title: Text(
                          tripulacion.empleado.nombre,
                          style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          tripulacion.cargo,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                        onTap: () => context.push('/tripulacion/${tripulacion.id}'),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
