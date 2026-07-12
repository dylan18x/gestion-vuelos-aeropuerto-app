// lib/presentation/screens/horarios/horario_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../providers/vuelo_provider.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_error_widget.dart';

class HorarioListScreen extends ConsumerWidget {
  const HorarioListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vuelosAsync = ref.watch(vuelosProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Horarios por vuelo')),
      body: vuelosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          error: e.toString(),
          onRetry: () => ref.invalidate(vuelosProvider),
        ),
        data: (paginated) => paginated.results.isEmpty
          ? const AppEmptyState(
              message: 'No hay vuelos registrados todavía',
              icon: Icons.flight_rounded,
            )
          : RefreshIndicator(
              onRefresh: () async => ref.invalidate(vuelosProvider),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: paginated.results.length,
                itemBuilder: (context, index) {
                  final vuelo = paginated.results[index];
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
                        child: const Icon(Icons.schedule_rounded, color: AppColors.accent, size: 22),
                      ),
                      title: Text(
                        vuelo.codigoVuelo,
                        style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${formatDate(vuelo.fecha)} · ${vuelo.estado}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                      onTap: () => context.push('/horarios/${vuelo.id}'),
                    ),
                  );
                },
              ),
            ),
      ),
    );
  }
}