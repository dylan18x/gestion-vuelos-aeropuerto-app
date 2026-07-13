import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repository/torre_control_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/torre_control_provider.dart';
import '../../widgets/app_confirm_dialog.dart';
import '../../widgets/app_error_widget.dart';

class TorreControlDetalleScreen extends ConsumerWidget {
  final int id;
  const TorreControlDetalleScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detalleAsync = ref.watch(torreControlDetalleProvider(id));
    final isAdmin = ref.watch(authProvider).isAdmin;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detalle Torre de Control'),
        actions: isAdmin
            ? [
                IconButton(
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: () => context.push('/torres-control/$id/editar'),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_rounded, color: AppColors.error),
                  onPressed: () async {
                    final ok = await showConfirmDialog(
                      context,
                      title: 'Eliminar Torre de Control',
                      content: '¿Está seguro de eliminar esta torre de control?',
                    );
                    if (ok && context.mounted) {
                      try {
                        await ref.read(torreControlRepositoryProvider).deleteTorreControl(id);
                        ref.invalidate(torresControlProvider);
                        ref.invalidate(torreControlDetalleProvider(id));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Torre de control eliminada'),
                            backgroundColor: AppColors.success,
                          ));
                          context.pop();
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: AppColors.error,
                          ));
                        }
                      }
                    }
                  },
                ),
              ]
            : null,
      ),
      body: detalleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          error: e.toString(),
          onRetry: () => ref.invalidate(torreControlDetalleProvider(id)),
        ),
        data: (torre) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.location_city_rounded, color: AppColors.info, size: 48),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                torre.nombre,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            _DetailRow(label: 'ID', value: torre.idTorre.toString()),
            _DetailRow(label: 'Frecuencia', value: '${torre.frecuencia} MHz'),
            _DetailRow(label: 'ID Aeropuerto', value: torre.idAeropuerto.toString()),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            Text(value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
          ],
        ),
      );
}