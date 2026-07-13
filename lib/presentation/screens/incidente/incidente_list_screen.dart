// lib/presentation/screens/incidentes/incidente_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/formatters.dart';
import '../../../theme/app_colors.dart';
import '../../providers/incidente_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_error_widget.dart';

class IncidenteListScreen extends ConsumerWidget {
  const IncidenteListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incidentesAsync = ref.watch(incidentesProvider);
    final isAuthenticated = ref.watch(authProvider).isAuthenticated;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Incidentes')),
      floatingActionButton: isAuthenticated
        ? FloatingActionButton.extended(
            onPressed: () => context.push('/incidentes/nuevo'),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Nuevo incidente'),
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.onAccent,
          )
        : null,
      body: incidentesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          error: e.toString(),
          onRetry: () => ref.invalidate(incidentesProvider),
        ),
        data: (paginated) => paginated.results.isEmpty
          ? const AppEmptyState(
              message: 'No hay incidentes registrados todavía',
              icon: Icons.report_problem_rounded,
            )
          : RefreshIndicator(
              onRefresh: () async => ref.invalidate(incidentesProvider),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: paginated.results.length,
                itemBuilder: (context, index) {
                  final incidente = paginated.results[index];
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
                          color: AppColors.error.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.report_problem_rounded, color: AppColors.error, size: 22),
                      ),
                      title: Text(
                        incidente.descripcion,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${formatDate(incidente.fecha)} · '
                        '${incidente.vuelo?.codigoVuelo ?? "Sin vuelo asignado"}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                      onTap: () => context.push('/incidentes/${incidente.id}'),
                    ),
                  );
                },
              ),
            ),
      ),
    );
  }
}