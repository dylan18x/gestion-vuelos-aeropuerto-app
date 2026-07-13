import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repository/tripulacion_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/tripulacion_provider.dart';
import '../../widgets/app_confirm_dialog.dart';
import '../../widgets/app_error_widget.dart';
import 'tripulacion_form_screen.dart';

class TripulacionDetalleScreen extends ConsumerWidget {
  final int id;
  const TripulacionDetalleScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(tripulacionDetalleProvider(id));
    final auth = ref.watch(authProvider);
    final canEdit = auth.isAuthenticated;
    final canDelete = auth.isAdmin;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detalle de tripulación'),
        actions: [
          if (canEdit)
            IconButton(
              icon: const Icon(Icons.edit_rounded, color: AppColors.accent),
              onPressed: () => async.whenData((tripulacion) => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TripulacionFormScreen(tripulacion: tripulacion)),
              ).then((_) => ref.invalidate(tripulacionDetalleProvider(id)))),
            ),
          if (canDelete)
            IconButton(
              icon: const Icon(Icons.delete_rounded, color: AppColors.error),
              onPressed: () async {
                final ok = await showConfirmDialog(
                  context,
                  title: 'Eliminar tripulación',
                  content: '¿Estás seguro? Esta acción no se puede deshacer.',
                );
                if (!ok || !context.mounted) return;
                try {
                  await ref.read(tripulacionRepositoryProvider).deleteTripulante(id);
                  ref.invalidate(tripulacionesProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tripulación eliminada'), backgroundColor: AppColors.success),
                    );
                    context.pop();
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
                    );
                  }
                }
              },
            ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          error: e.toString(),
          onRetry: () => ref.invalidate(tripulacionDetalleProvider(id)),
        ),
        data: (tripulacion) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _DetailCard(children: [
              _Row('ID', tripulacion.id.toString()),
              _Row('Cargo', tripulacion.cargo),
              _Row('Empleado', tripulacion.empleado.nombre),
              _Row('Cargo empleado', tripulacion.empleado.cargo),
            ]),
          ],
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final List<Widget> children;
  const _DetailCard({required this.children});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(children: children),
      );
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 140, child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))),
            Expanded(child: Text(value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600))),
          ],
        ),
      );
}
