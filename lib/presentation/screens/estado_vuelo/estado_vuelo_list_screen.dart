// lib/presentation/screens/estado_vuelo/estado_vuelo_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../providers/estado_vuelo_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_error_widget.dart';

class EstadoVueloListScreen extends ConsumerWidget {
  const EstadoVueloListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estadosAsync = ref.watch(estadoVuelosProvider);
    final isAdmin = ref.watch(authProvider).isAdmin;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Estados de Vuelo')),
      floatingActionButton: isAdmin
        ? FloatingActionButton.extended(
            onPressed: () => context.push('/estado-vuelo/nuevo'),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Nuevo'),
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.onAccent,
          )
        : null,
      body: estadosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(error: e.toString(), onRetry: () => ref.invalidate(estadoVuelosProvider)),
        data: (list) => list.isEmpty
          ? const AppEmptyState(message: 'No hay estados de vuelo registrados', icon: Icons.flag_rounded)
          : RefreshIndicator(
              onRefresh: () async => ref.invalidate(estadoVuelosProvider),
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
                          color: AppColors.accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.flag_rounded, color: AppColors.accent, size: 22),
                      ),
                      title: Text(a.nombreEstado, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                      subtitle: Text(a.descripcion, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      onTap: () => context.push('/estado-vuelo/${a.idEstado}'),
                    ),
                  );
                },
              ),
            ),
      ),
    );
  }
}
