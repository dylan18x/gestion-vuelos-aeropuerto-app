// lib/presentation/screens/historial_estado_vuelo/historial_estado_vuelo_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/formatters.dart';
import '../../../theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/historial_estado_vuelo_provider.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_error_widget.dart';
import 'historial_estado_vuelo_detalle_screen.dart';

/// Listado GLOBAL: el historial de TODOS los vuelos junto, sin filtrar.
class HistorialEstadoVueloListScreen extends ConsumerWidget {
  const HistorialEstadoVueloListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historialesAsync = ref.watch(allHistorialesEstadoVueloProvider);
    final isAuthenticated = ref.watch(authProvider).isAuthenticated;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Historial de estados')),
      floatingActionButton: isAuthenticated
        ? FloatingActionButton.extended(
            onPressed: () => context.push('/historial-estados-vuelo/nuevo'),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Nuevo registro'),
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.onAccent,
          )
        : null,
      body: historialesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          error: e.toString(),
          onRetry: () => ref.invalidate(allHistorialesEstadoVueloProvider),
        ),
        data: (historiales) {
          if (historiales.isEmpty) {
            return const AppEmptyState(
              message: 'No hay registros en el historial todavía',
              icon: Icons.history_rounded,
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(allHistorialesEstadoVueloProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: historiales.length,
              itemBuilder: (context, index) {
                final historial = historiales[index];
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
                      child: const Icon(Icons.history_rounded, color: AppColors.accent, size: 22),
                    ),
                    title: Text(
                      'Vuelo ID: ${historial.idVuelo}',
                      style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      '${formatDate(historial.fechaCambio)} · Estado: ${historial.estado.nombreEstado}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                    // Pasamos el objeto ya cargado directo, sin pedirlo de nuevo a la API
                    // (no tenemos endpoint de "traer 1 historial por su id").
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HistorialEstadoVueloDetalleScreen(historial: historial),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}