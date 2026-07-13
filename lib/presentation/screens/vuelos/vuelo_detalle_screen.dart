// lib/presentation/screens/vuelos/vuelo_detalle_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/repository/vuelo_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../providers/vuelo_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_confirm_dialog.dart';
import '../../widgets/app_error_widget.dart';
import 'vuelo_form_screen.dart';

class VueloDetalleScreen extends ConsumerWidget {
  final int idVuelo;
  const VueloDetalleScreen({super.key, required this.idVuelo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(vueloDetalleProvider(idVuelo));
    final auth = ref.watch(authProvider);
    // TECNICO: cualquiera logueado que no sea admin. ADMIN: is_staff = true.
    final canEdit = auth.isAuthenticated;   // TECNICO o ADMIN pueden editar
    final canDelete = auth.isAdmin;         // solo ADMIN elimina

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detalle del vuelo'),
        actions: [
          if (canEdit)
            IconButton(
              icon: const Icon(Icons.edit_rounded, color: AppColors.accent),
              onPressed: () => async.whenData((vuelo) => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => VueloFormScreen(vuelo: vuelo)),
              ).then((_) => ref.invalidate(vueloDetalleProvider(idVuelo)))),
            ),
          if (canDelete)
            IconButton(
              icon: const Icon(Icons.delete_rounded, color: AppColors.error),
              onPressed: () async {
                final ok = await showConfirmDialog(
                  context,
                  title: 'Eliminar vuelo',
                  content: '¿Estás seguro? Esta acción no se puede deshacer.',
                );
                if (!ok || !context.mounted) return;
                try {
                  await ref.read(vueloRepositoryProvider).deleteVuelo(idVuelo);
                  ref.invalidate(vuelosProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vuelo eliminado'), backgroundColor: AppColors.success),
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
          onRetry: () => ref.invalidate(vueloDetalleProvider(idVuelo)),
        ),
        data: (vuelo) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _DetailCard(children: [
              _Row('Código de vuelo', vuelo.codigoVuelo),
              _Row('Fecha',            formatDate(vuelo.fecha)),
              _Row('Estado',           vuelo.estado),
              _Row('Avión',            vuelo.avion?.modelo ?? 'Sin asignar'),
              _Row('Matrícula',        vuelo.avion?.matricula ?? '-'),
            ]),
            // TODO: agregar aquí tarjetas de Horario, Escala e Historial de estado
            // (usa horarioRepositoryProvider, escalaRepositoryProvider,
            // historialEstadoVueloRepositoryProvider con .getXxxByVuelo(idVuelo))
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