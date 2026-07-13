<<<<<<< HEAD
import 'package:flutter/material.dart';
import '../../../domain/model/asignacion_pista.dart';

class AsignacionPistaDetalleScreen extends StatelessWidget {
  final AsignacionPista asignacion;
  const AsignacionPistaDetalleScreen({super.key, required this.asignacion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle Asignación Pista')),
      body: Center(child: Text('ID: ${asignacion.id}')),
    );
  }
=======
// lib/presentation/screens/asignacion_pista/asignacion_pista_detalle_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../data/repository/asignacion_pista_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../providers/asignacion_pista_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_confirm_dialog.dart';
import '../../widgets/app_error_widget.dart';
import 'asignacion_pista_form_screen.dart';

class AsignacionPistaDetalleScreen extends ConsumerWidget {
  final int id;
  const AsignacionPistaDetalleScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(asignacionPistaDetalleProvider(id));
    final auth = ref.watch(authProvider);
    final canEdit = auth.isAuthenticated;
    final canDelete = auth.isAdmin;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detalle de asignación'),
        actions: [
          if (canEdit)
            IconButton(
              icon: const Icon(Icons.edit_rounded, color: AppColors.accent),
              onPressed: () => async.whenData((asignacion) => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AsignacionPistaFormScreen(asignacion: asignacion)),
              ).then((_) => ref.invalidate(asignacionPistaDetalleProvider(id)))),
            ),
          if (canDelete)
            IconButton(
              icon: const Icon(Icons.delete_rounded, color: AppColors.error),
              onPressed: () async {
                final ok = await showConfirmDialog(
                  context,
                  title: 'Eliminar asignación',
                  content: '¿Estás seguro? Esta acción no se puede deshacer.',
                );
                if (!ok || !context.mounted) return;
                try {
                  await ref.read(asignacionPistaRepositoryProvider).deleteAsignacionPista(id);
                  ref.invalidate(asignacionesPistaProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Asignación eliminada'), backgroundColor: AppColors.success),
                    );
                    Navigator.of(context).pop();
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
          onRetry: () => ref.invalidate(asignacionPistaDetalleProvider(id)),
        ),
        data: (asignacion) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _DetailCard(children: [
              _Row('ID Asignación', asignacion.idAsignacionPista.toString()),
              _Row('ID Pista',      asignacion.idPista.toString()),
              _Row('ID Vuelo',      asignacion.idVuelo.toString()),
              _Row('Hora',          _formatHora(asignacion.horaAsignacion)),
            ]),
          ],
        ),
      ),
    );
  }
}

String _formatHora(String hora) {
  final parsed = DateTime.tryParse(hora);
  if (parsed == null) return hora;
  return DateFormat('dd/MM/yyyy HH:mm').format(parsed.toLocal());
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
>>>>>>> 9c93e9e349b58cd690bce44268335422b70f5c53
}