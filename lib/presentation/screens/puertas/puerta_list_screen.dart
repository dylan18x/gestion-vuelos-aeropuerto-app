// lib/presentation/screens/puertas/puerta_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../providers/puerta_embarque_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_error_widget.dart';

class PuertaListScreen extends ConsumerWidget {
  const PuertaListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(puertasProvider);
    final isAdmin = ref.watch(authProvider).isAdmin;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Puertas de Embarque')),
      floatingActionButton: isAdmin
        ? FloatingActionButton.extended(
            onPressed: () => context.push('/puertas/nuevo'),
            icon: const Icon(Icons.add),
            label: const Text('Nueva'),
          )
        : null,
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          error: e.toString(),
          onRetry: () => ref.invalidate(puertasProvider),
        ),
        data: (list) {
          if (list.isEmpty) {
            return const AppEmptyState(
              message: 'No hay puertas de embarque registradas',
              icon: Icons.door_sliding_outlined,
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(puertasProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (_, i) {
                final p = list[i];
                return Card(
                  color: AppColors.surface,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.door_sliding_rounded, color: AppColors.success, size: 22),
                    ),
                    title: Text('Puerta ${p.numero}',
                      style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                    subtitle: Text('Terminal ID: ${p.idTerminal}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textFaint),
                    onTap: () => context.push('/puertas/${p.idPuerta}'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
