    // lib/presentation/screens/empleados/empleado_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../providers/empleado_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_error_widget.dart';

class EmpleadoListScreen extends ConsumerWidget {
  const EmpleadoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final empleadosAsync = ref.watch(empleadosProvider);
    final isAuthenticated = ref.watch(authProvider).isAuthenticated;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Empleados')),
      floatingActionButton: isAuthenticated
        ? FloatingActionButton.extended(
            onPressed: () => context.push('/empleados/nuevo'),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Nuevo empleado'),
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.onAccent,
          )
        : null,
      body: empleadosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          error: e.toString(),
          onRetry: () => ref.invalidate(empleadosProvider),
        ),
        data: (paginated) => paginated.results.isEmpty
          ? const AppEmptyState(
              message: 'No hay empleados registrados todavía',
              icon: Icons.badge_rounded,
            )
          : RefreshIndicator(
              onRefresh: () async => ref.invalidate(empleadosProvider),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: paginated.results.length,
                itemBuilder: (context, index) {
                  final empleado = paginated.results[index];
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
                        child: const Icon(Icons.badge_rounded, color: AppColors.accent, size: 22),
                      ),
                      title: Text(
                        empleado.nombre,
                        style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        empleado.cargo,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                      onTap: () => context.push('/empleados/${empleado.id}'),
                    ),
                  );
                },
              ),
            ),
      ),
    );
  }
}