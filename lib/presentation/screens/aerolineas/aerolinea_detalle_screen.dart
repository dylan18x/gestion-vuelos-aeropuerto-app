// lib/presentation/screens/aerolineas/aerolinea_detalle_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../../data/repository/aerolinea_repository_impl.dart';
import '../../providers/aerolinea_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_confirm_dialog.dart';
import '../../widgets/app_error_widget.dart';

class AerolineaDetalleScreen extends ConsumerWidget {
  final int id;
  const AerolineaDetalleScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detalleAsync = ref.watch(aerolineaDetalleProvider(id));
    final isAdmin = ref.watch(authProvider).isAdmin;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detalle Aerolínea'),
        actions: isAdmin
          ? [
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                onPressed: () => context.push('/aerolineas/$id/editar'),
              ),
              IconButton(
                icon: const Icon(Icons.delete_rounded, color: AppColors.error),
                onPressed: () async {
                  final ok = await showConfirmDialog(context,
                    title: 'Eliminar Aerolínea',
                    content: '¿Está seguro de eliminar esta aerolínea?');
                  if (ok && context.mounted) {
                    try {
                      await ref.read(aerolineaRepositoryProvider).deleteAerolinea(id);
                      ref.invalidate(aerolineasProvider);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Aerolínea eliminada'),
                          backgroundColor: AppColors.success,
                        ));
                        context.pop();
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Error: $e'), backgroundColor: AppColors.error));
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
          onRetry: () => ref.invalidate(aerolineaDetalleProvider(id)),
        ),
        data: (a) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: a.imageUrl != null
                    ? Image.network(
                        a.imageUrl!,
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: double.infinity,
                        height: 220,
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.airlines_rounded,
                          color: AppColors.warning,
                          size: 70,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Center(child: Text(a.nombre,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold))),
            const SizedBox(height: 28),
            _Row('ID Aerolínea', a.idAerolinea.toString()),
            _Row('Nombre', a.nombre),
            _Row('País', a.pais),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

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
