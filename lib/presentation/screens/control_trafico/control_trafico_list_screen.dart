// lib/presentation/screens/control_trafico/control_trafico_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_colors.dart';
import '../../providers/control_trafico_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_error_widget.dart';

class ControlTraficoListScreen extends ConsumerWidget {
  const ControlTraficoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controlesAsync = ref.watch(controlesTraficoProvider);
    final isAuthenticated = ref.watch(authProvider).isAuthenticated;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Control de tráfico')),
      floatingActionButton: isAuthenticated
        ? FloatingActionButton.extended(
            onPressed: () => context.push('/control-trafico/nuevo'),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Nuevo control'),
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.onAccent,
          )
        : null,
      body: controlesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          error: e.toString(),
          onRetry: () => ref.invalidate(controlesTraficoProvider),
        ),
        data: (paginated) => paginated.results.isEmpty
          ? const AppEmptyState(
              message: 'No hay controles de tráfico registrados todavía',
              icon: Icons.radar_rounded,
            )
          : RefreshIndicator(
              onRefresh: () async => ref.invalidate(controlesTraficoProvider),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: paginated.results.length,
                itemBuilder: (context, index) {
                  final control = paginated.results[index];
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
                        child: const Icon(Icons.radar_rounded, color: AppColors.accent, size: 22),
                      ),
                      title: Text(
                        control.autorizacion,
                        style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${_formatHora(control.hora)} · '
                        '${control.vuelo?.codigoVuelo ?? "Sin vuelo asignado"}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                      onTap: () => context.push('/control-trafico/${control.id}'),
                    ),
                  );
                },
              ),
            ),
      ),
    );
  }
}

/// Formatea una hora ISO8601 a algo legible; si no se puede parsear, muestra el valor crudo.
String _formatHora(String hora) {
  final parsed = DateTime.tryParse(hora);
  if (parsed == null) return hora;
  return DateFormat('dd/MM/yyyy HH:mm').format(parsed.toLocal());
}