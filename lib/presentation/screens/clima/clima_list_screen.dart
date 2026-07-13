// lib/presentation/screens/clima/clima_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/formatters.dart';
import '../../../theme/app_colors.dart';
import '../../providers/clima_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_error_widget.dart';

class ClimaListScreen extends ConsumerWidget {
  const ClimaListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final climasAsync = ref.watch(climasProvider);
    final isAdmin = ref.watch(authProvider).isAdmin;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Clima')),
      floatingActionButton: isAdmin
        ? FloatingActionButton.extended(
            onPressed: () => context.push('/clima/nuevo'),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Nuevo'),
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.onAccent,
          )
        : null,
      body: climasAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(error: e.toString(), onRetry: () => ref.invalidate(climasProvider)),
        data: (list) => list.isEmpty
          ? const AppEmptyState(message: 'No hay reportes de clima', icon: Icons.cloud_outlined)
          : RefreshIndicator(
              onRefresh: () async => ref.invalidate(climasProvider),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final a = list[i];
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
                        child: const Icon(Icons.cloud_rounded, color: AppColors.info, size: 22),
                      ),
                      title: Text('Aeropuerto: ${a.idAeropuerto}', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                      subtitle: Text('${a.condicion} • ${a.temperatura}°C\nFecha: ${formatDateTime(a.fecha)}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      onTap: () => context.push('/clima/${a.idClima}'),
                    ),
                  );
                },
              ),
            ),
      ),
    );
  }
}
