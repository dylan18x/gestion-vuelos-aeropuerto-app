// lib/presentation/screens/asignacion_tripulacion/asignacion_tripulacion_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/formatters.dart';
import '../../../theme/app_colors.dart';
import '../../providers/asignacion_tripulacion_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_error_widget.dart';
import 'asignacion_tripulacion_form_screen.dart';

class AsignacionTripulacionListScreen extends ConsumerWidget {
  const AsignacionTripulacionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asignacionesAsync = ref.watch(asignacionesTripulacionProvider);
    final isAuthenticated = ref.watch(authProvider).isAuthenticated;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Asignaciones de Tripulación')),
      floatingActionButton: isAuthenticated
        ? FloatingActionButton.extended(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AsignacionTripulacionFormScreen()),
            ).then((_) => ref.invalidate(asignacionesTripulacionProvider)),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Nueva asignación'),
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.onAccent,
          )
        : null,
      body: asignacionesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          error: e.toString(),
          onRetry: () => ref.invalidate(asignacionesTripulacionProvider),
        ),
        data: (asignaciones) => asignaciones.isEmpty
          ? const AppEmptyState(
              message: 'No hay asignaciones de tripulación todavía',
              icon: Icons.groups_rounded,
            )
          : RefreshIndicator(
              onRefresh: () async => ref.invalidate(asignacionesTripulacionProvider),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: asignaciones.length,
                itemBuilder: (context, index) {
                  final asignacion = asignaciones[index];
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
                          color: AppColors.accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.groups_rounded, color: AppColors.accent, size: 22),
                      ),
                      title: Text(
                        'Asignación #${asignacion.idAsignacion}',
                        style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        'Tripulación: ${asignacion.idTripulacion} · Empleado: ${asignacion.idEmpleado} · '
                        '${formatDate(asignacion.fechaAsignacion)}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                      onTap: () => context.push('/asignacion-tripulacion/${asignacion.idAsignacion}'),
                    ),
                  );
                },
              ),
            ),
      ),
    );
  }
}