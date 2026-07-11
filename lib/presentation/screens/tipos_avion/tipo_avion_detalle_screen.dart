// lib/presentation/screens/tipos_avion/tipo_avion_detalle_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repository/tipo_avion_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../providers/tipo_avion_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_confirm_dialog.dart';
import '../../widgets/app_error_widget.dart';
import 'tipo_avion_form_screen.dart';

class TipoAvionDetalleScreen extends ConsumerWidget {
  final int id;
  const TipoAvionDetalleScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(tipoAvionDetalleProvider(id));
    final isAdmin = ref.watch(authProvider).isAdmin;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detalle Tipo de Avión'),
        actions: isAdmin ? [
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: AppColors.accent),
            onPressed: () => async.whenData((a) => Navigator.push(
              context, MaterialPageRoute(builder: (_) => TipoAvionFormScreen(tipoAvion: a)))
              .then((_) => ref.invalidate(tipoAvionDetalleProvider(id)))),
          ),
          IconButton(
            icon: const Icon(Icons.delete_rounded, color: AppColors.error),
            onPressed: () async {
              final ok = await showConfirmDialog(context,
                title: 'Eliminar Tipo de Avión',
                content: '¿Estás seguro? Esta acción no se puede deshacer.');
              if (!ok || !context.mounted) return;
              try {
                await ref.read(tipoAvionRepositoryProvider).deleteTipoAvion(id);
                ref.invalidate(tiposAvionProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tipo de avión eliminado'), backgroundColor: AppColors.success));
                  context.pop();
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
                }
              }
            },
          ),
        ] : null,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(error: e.toString(), onRetry: () => ref.invalidate(tipoAvionDetalleProvider(id))),
        data: (a) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _DetailCard(children: [
              _Row('Fabricante',   a.fabricante),
              _Row('Modelo',       a.modelo),
              _Row('Alcance',      a.alcance),
              _Row('ID Tipo',      a.idTipo.toString()),
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
        SizedBox(width: 120, child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))),
        Expanded(child: Text(value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600))),
      ],
    ),
  );
}
