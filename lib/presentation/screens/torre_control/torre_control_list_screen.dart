import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/torre_control_provider.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_error_widget.dart';

class TorreControlListScreen extends ConsumerWidget {
  const TorreControlListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final torresAsync = ref.watch(torresControlProvider);
    final isAdmin = ref.watch(authProvider).isAdmin;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Torres de Control')),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/torres-control/nuevo'),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Nuevo'),
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.onAccent,
            )
          : null,
      body: torresAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          error: e.toString(),
          onRetry: () => ref.invalidate(torresControlProvider),
        ),
        data: (torres) => torres.isEmpty
            ? const AppEmptyState(
                message: 'No hay torres de control registradas',
                icon: Icons.location_city_rounded,
              )
            : RefreshIndicator(
                onRefresh: () async => ref.invalidate(torresControlProvider),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: torres.length,
                  itemBuilder: (_, i) {
                    final torre = torres[i];
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
                            color: AppColors.info.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.location_city_rounded, color: AppColors.info, size: 22),
                        ),
                        title: Text(
                          torre.nombre,
                          style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          'Frecuencia: ${torre.frecuencia} MHz',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textFaint),
                        onTap: () => context.push('/torres-control/${torre.idTorre}'),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}