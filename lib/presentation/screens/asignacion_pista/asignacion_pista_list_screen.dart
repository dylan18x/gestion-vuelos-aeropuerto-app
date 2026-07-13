// lib/presentation/screens/asignacion_pista/asignacion_pista_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_colors.dart';
import '../../providers/asignacion_pista_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_error_widget.dart';
import 'asignacion_pista_form_screen.dart';

class AsignacionPistaListScreen extends ConsumerWidget {
  const AsignacionPistaListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asignacionesAsync = ref.watch(asignacionesPistaProvider);
    final isAuthenticated = ref.watch(authProvider).isAuthenticated;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Asignaciones de Pista')),
      floatingActionButton: isAuthenticated
        ? FloatingActionButton.extended(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AsignacionPistaFormScreen()),
            ).then((_) => ref.invalidate(asignacionesPistaProvider)),
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
          onRetry: () => ref.invalidate(asignacionesPistaProvider),
        ),
        data: (asignaciones) => asignaciones.isEmpty
          ? const AppEmptyState(
              message: 'No hay asignaciones de pista todavía',
              icon: Icons.flight_land_rounded,
            )
          : RefreshIndicator(
              onRefresh: () async => ref.invalidate(asignacionesPistaProvider),
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
                        child: const Icon(Icons.flight_land_rounded, color: AppColors.accent, size: 22),
                      ),
                      title: Text(
                        'Asignación #${asignacion.idAsignacionPista}',
                        style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        'Pista: ${asignacion.idPista} · Vuelo: ${asignacion.idVuelo} · '
                        '${_formatHora(asignacion.horaAsignacion)}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                      onTap: () => context.push('/asignacion-pista/${asignacion.idAsignacionPista}'),
                    ),
                  );
                },
              ),
            ),
      ),
    );
  }
}

String _formatHora(String hora) {
  final parsed = DateTime.tryParse(hora);
  if (parsed == null) return hora;
  return DateFormat('dd/MM/yyyy HH:mm').format(parsed.toLocal());
}