// lib/presentation/screens/puertas/puerta_detalle_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../../data/repository/puerta_embarque_repository_impl.dart';
import '../../providers/puerta_embarque_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_confirm_dialog.dart';
import '../../widgets/app_error_widget.dart';

class PuertaDetalleScreen extends ConsumerWidget {
  final int id;
  const PuertaDetalleScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detalleAsync = ref.watch(puertaDetalleProvider(id));
    final isAdmin = ref.watch(authProvider).isAdmin;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detalle Puerta'),
        actions: isAdmin
          ? [
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                onPressed: () => context.push('/puertas/$id/editar'),
              ),
              IconButton(
                icon: const Icon(Icons.delete_rounded, color: AppColors.error),
                onPressed: () async {
                  final ok = await showConfirmDialog(context,
                    title: 'Eliminar Puerta',
                    content: '¿Está seguro de eliminar esta puerta de embarque?');
                  if (ok && context.mounted) {
                    try {
                      await ref.read(puertaEmbarqueRepositoryProvider).deletePuerta(id);
                      ref.invalidate(puertasProvider);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Puerta eliminada'),
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
          onRetry: () => ref.invalidate(puertaDetalleProvider(id)),
        ),
        data: (p) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.door_sliding_rounded, color: AppColors.success, size: 48),
              ),
            ),
            const SizedBox(height: 20),
            Center(child: Text('Puerta ${p.numero}',
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold))),
            const SizedBox(height: 28),
            _Row('ID Puerta', p.idPuerta.toString()),
            _Row('Número', p.numero),
            _Row('ID Terminal', p.idTerminal.toString()),
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
