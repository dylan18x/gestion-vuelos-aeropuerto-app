// lib/presentation/screens/aeropuertos/aeropuerto_detalle_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../../data/repository/aeropuerto_repository_impl.dart';
import '../../providers/aeropuerto_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_confirm_dialog.dart';
import '../../widgets/app_error_widget.dart';

class AeropuertoDetalleScreen extends ConsumerWidget {
  final int id;
  const AeropuertoDetalleScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detalleAsync = ref.watch(aeropuertoDetalleProvider(id));
    final isAdmin = ref.watch(authProvider).isAdmin;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detalle Aeropuerto'),
        actions: isAdmin
          ? [
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                onPressed: () => context.push('/aeropuertos/$id/editar'),
              ),
              IconButton(
                icon: const Icon(Icons.delete_rounded, color: AppColors.error),
                onPressed: () async {
                  final ok = await showConfirmDialog(context,
                    title: 'Eliminar Aeropuerto',
                    content: '¿Está seguro de eliminar este aeropuerto?');
                  if (ok && context.mounted) {
                    try {
                      await ref.read(aeropuertoRepositoryProvider).deleteAeropuerto(id);
                      ref.invalidate(aeropuertosProvider);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Aeropuerto eliminado'),
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
          onRetry: () => ref.invalidate(aeropuertoDetalleProvider(id)),
        ),
        data: (a) => ListView(
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
              child: Text(a.nombre,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
                ),
                child: Text(a.codigoIata,
                  style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 28),
            _DetailRow(label: 'ID', value: a.idAeropuerto.toString()),
            _DetailRow(label: 'Ciudad', value: a.ciudad),
            _DetailRow(label: 'País', value: a.pais),
            _DetailRow(label: 'Código IATA', value: a.codigoIata),
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
