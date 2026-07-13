// lib/presentation/screens/pilotos/piloto_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../providers/piloto_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_error_widget.dart';

class PilotoListScreen extends ConsumerWidget {
  const PilotoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pilotosAsync = ref.watch(pilotosProvider);
    final isAuthenticated = ref.watch(authProvider).isAuthenticated;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Pilotos')),
      floatingActionButton: isAuthenticated
        ? FloatingActionButton.extended(
            onPressed: () => context.push('/pilotos/nuevo'),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Nuevo piloto'),
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.onAccent,
          )
        : null,
      body: pilotosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          error: e.toString(),
          onRetry: () => ref.invalidate(pilotosProvider),
        ),
        data: (pilotos) => pilotos.isEmpty
          ? const AppEmptyState(
              message: 'No hay pilotos registrados todavía',
              icon: Icons.airline_seat_recline_normal_rounded,
            )
          : RefreshIndicator(
              onRefresh: () async => ref.invalidate(pilotosProvider),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: pilotos.length,
                itemBuilder: (context, index) {
                  final piloto = pilotos[index];
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
                        child: const Icon(Icons.airline_seat_recline_normal_rounded, color: AppColors.accent, size: 22),
                      ),
                      title: Text(
                        piloto.empleado.nombre,
                        style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        'Licencia: ${piloto.licencia}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                      onTap: () => context.push('/pilotos/${piloto.id}'),
                    ),
                  );
                },
              ),
            ),
      ),
    );
  }
}