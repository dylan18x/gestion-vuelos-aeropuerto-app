// lib/presentation/screens/escalas/escala_detalle_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repository/escala_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../providers/escala_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_confirm_dialog.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_error_widget.dart';
import 'escala_form_screen.dart';

class EscalaDetalleScreen extends ConsumerWidget {
  final int idVuelo;
  const EscalaDetalleScreen({super.key, required this.idVuelo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(escalasByVueloProvider(idVuelo));
    final isAuthenticated = ref.watch(authProvider).isAuthenticated;
    final isAdmin = ref.watch(authProvider).isAdmin;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Escalas del vuelo')),
      floatingActionButton: isAuthenticated
        ? FloatingActionButton.extended(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EscalaFormScreen(idVuelo: idVuelo)),
            ).then((_) => ref.invalidate(escalasByVueloProvider(idVuelo))),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Agregar escala'),
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.onAccent,
          )
        : null,
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          error: e.toString(),
          onRetry: () => ref.invalidate(escalasByVueloProvider(idVuelo)),
        ),
        data: (escalas) => escalas.isEmpty
          ? const AppEmptyState(
              message: 'Este vuelo no tiene escalas registradas',
              icon: Icons.alt_route_rounded,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: escalas.length,
              itemBuilder: (context, index) {
                final escala = escalas[index];
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
                      child: const Icon(Icons.location_on_rounded, color: AppColors.accent, size: 22),
                    ),
                    // Ajusta a escala.aeropuertoEscala.nombre si tu AeropuertoRef usa otro campo
                    title: Text(
                      'Aeropuerto #${escala.aeropuertoEscala.id}',
                      style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                    ),
                    trailing: isAdmin
                      ? IconButton(
                          icon: const Icon(Icons.delete_rounded, color: AppColors.error),
                          onPressed: () async {
                            final ok = await showConfirmDialog(
                              context,
                              title: 'Eliminar escala',
                              content: '¿Estás seguro? Esta acción no se puede deshacer.',
                            );
                            if (!ok || !context.mounted) return;
                            try {
                              await ref.read(escalaRepositoryProvider).deleteEscala(escala.id);
                              ref.invalidate(escalasByVueloProvider(idVuelo));
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Escala eliminada'), backgroundColor: AppColors.success),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
                                );
                              }
                            }
                          },
                        )
                      : null,
                  ),
                );
              },
            ),
      ),
    );
  }
}