// lib/presentation/screens/registros_vuelo/registro_vuelo_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_colors.dart';
import '../../providers/registro_vuelo_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_error_widget.dart';

class RegistroVueloListScreen extends ConsumerWidget {
  const RegistroVueloListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrosAsync = ref.watch(registrosVueloProvider);
    final isAuthenticated = ref.watch(authProvider).isAuthenticated;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Registros de vuelo')),
      floatingActionButton: isAuthenticated
        ? FloatingActionButton.extended(
            onPressed: () => context.push('/registros-vuelo/nuevo'),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Nuevo registro'),
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.onAccent,
          )
        : null,
      body: registrosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          error: e.toString(),
          onRetry: () => ref.invalidate(registrosVueloProvider),
        ),
        data: (paginated) => paginated.results.isEmpty
          ? const AppEmptyState(
              message: 'No hay registros de vuelo todavía',
              icon: Icons.assignment_rounded,
            )
          : RefreshIndicator(
              onRefresh: () async => ref.invalidate(registrosVueloProvider),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: paginated.results.length,
                itemBuilder: (context, index) {
                  final registro = paginated.results[index];
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
                        child: const Icon(Icons.assignment_rounded, color: AppColors.accent, size: 22),
                      ),
                      title: Text(
                        registro.vuelo?.codigoVuelo ?? 'Sin vuelo asignado',
                        style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        'Salida real: ${_formatHora(registro.horaRealSalida)} · '
                        'Llegada real: ${_formatHora(registro.horaRealLlegada)}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                      onTap: () => context.push('/registros-vuelo/${registro.id}'),
                    ),
                  );
                },
              ),
            ),
      ),
    );
  }
}

/// Formatea una hora ISO8601; si es null o no se puede parsear, muestra "Pendiente".
String _formatHora(String? hora) {
  if (hora == null || hora.isEmpty) return 'Pendiente';
  final parsed = DateTime.tryParse(hora);
  if (parsed == null) return hora;
  return DateFormat('dd/MM/yyyy HH:mm').format(parsed.toLocal());
}