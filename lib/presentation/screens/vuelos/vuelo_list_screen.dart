// lib/presentation/screens/vuelos/vuelo_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../providers/vuelo_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_error_widget.dart';

/// Pública para leer (cualquiera la ve, sin login).
/// El botón "+" solo aparece si hay sesión iniciada (TECNICO o ADMIN),
/// porque crear vuelos SÍ requiere estar logueado.
class VueloListScreen extends ConsumerWidget {
  const VueloListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vuelosAsync = ref.watch(vuelosProvider);
    final isAuthenticated = ref.watch(authProvider).isAuthenticated;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Tablero de vuelos')),
      floatingActionButton: isAuthenticated
        ? FloatingActionButton.extended(
            onPressed: () => context.push('/vuelos/nuevo'),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Nuevo vuelo'),
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.onAccent,
          )
        : null,
      body: vuelosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          error: e.toString(),
          onRetry: () => ref.invalidate(vuelosProvider),
        ),
        data: (paginated) => paginated.results.isEmpty
          ? const AppEmptyState(
              message: 'No hay vuelos registrados todavía',
              icon: Icons.flight_rounded,
            )
          : RefreshIndicator(
              onRefresh: () async => ref.invalidate(vuelosProvider),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: paginated.results.length,
                itemBuilder: (context, index) {
                  final vuelo = paginated.results[index];
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
                        child: const Icon(Icons.flight_rounded, color: AppColors.accent, size: 22),
                      ),
                      title: Text(
                        vuelo.codigoVuelo,
                        style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${formatDate(vuelo.fecha)} · ${vuelo.estado} · '
                        '${vuelo.avion?.matricula ?? "Sin avión asignado"}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                      onTap: () => context.push('/vuelos/${vuelo.id}'),
                    ),
                  );
                },
              ),
            ),
      ),
    );
  }
}