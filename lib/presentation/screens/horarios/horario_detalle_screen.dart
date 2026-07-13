// lib/presentation/screens/horarios/horario_detalle_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../data/repository/horario_repository_impl.dart';
import '../../../theme/app_colors.dart';
import '../../providers/horario_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_confirm_dialog.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_error_widget.dart';
import 'horario_form_screen.dart';

class HorarioDetalleScreen extends ConsumerWidget {
  final int idVuelo;
  const HorarioDetalleScreen({super.key, required this.idVuelo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(horarioByVueloProvider(idVuelo));
    final auth = ref.watch(authProvider);
    final canEdit = auth.isAuthenticated;
    final canDelete = auth.isAdmin;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Horario del vuelo')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          error: e.toString(),
          onRetry: () => ref.invalidate(horarioByVueloProvider(idVuelo)),
        ),
        data: (horario) {
          if (horario == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppEmptyState(
                    message: 'Este vuelo no tiene horario asignado',
                    icon: Icons.schedule_rounded,
                  ),
                  if (canEdit) ...[
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => HorarioFormScreen(idVuelo: idVuelo)),
                      ).then((_) => ref.invalidate(horarioByVueloProvider(idVuelo))),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Crear horario'),
                    ),
                  ],
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _DetailCard(children: [
                _Row('Salida programada',  _formatFecha(horario.salidaProgramada)),
                _Row('Llegada programada', _formatFecha(horario.llegadaProgramada)),
              ]),
              const SizedBox(height: 20),
              Row(
                children: [
                  if (canEdit)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => HorarioFormScreen(idVuelo: idVuelo, horario: horario)),
                        ).then((_) => ref.invalidate(horarioByVueloProvider(idVuelo))),
                        icon: const Icon(Icons.edit_rounded),
                        label: const Text('Editar'),
                      ),
                    ),
                  if (canEdit && canDelete) const SizedBox(width: 12),
                  if (canDelete)
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
                        onPressed: () async {
                          final ok = await showConfirmDialog(
                            context,
                            title: 'Eliminar horario',
                            content: '¿Estás seguro? Esta acción no se puede deshacer.',
                          );
                          if (!ok || !context.mounted) return;
                          try {
                            await ref.read(horarioRepositoryProvider).deleteHorario(horario.id);
                            ref.invalidate(horarioByVueloProvider(idVuelo));
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Horario eliminado'), backgroundColor: AppColors.success),
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
                        icon: const Icon(Icons.delete_rounded),
                        label: const Text('Eliminar'),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

String _formatFecha(String value) {
  final parsed = DateTime.tryParse(value);
  if (parsed == null) return value;
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
        SizedBox(width: 160, child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))),
        Expanded(child: Text(value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600))),
      ],
    ),
  );
}