// lib/presentation/screens/terminales/terminal_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../providers/terminal_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_error_widget.dart';

class TerminalListScreen extends ConsumerWidget {
  const TerminalListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(terminalesProvider);
    final isAdmin = ref.watch(authProvider).isAdmin;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Terminales')),
      floatingActionButton: isAdmin
        ? FloatingActionButton.extended(
            onPressed: () => context.push('/terminales/nuevo'),
            icon: const Icon(Icons.add),
            label: const Text('Nueva'),
          )
        : null,
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          error: e.toString(),
          onRetry: () => ref.invalidate(terminalesProvider),
        ),
        data: (list) {
          if (list.isEmpty) {
            return const AppEmptyState(
              message: 'No hay terminales registradas',
              icon: Icons.apartment_outlined,
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(terminalesProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (_, i) {
                final t = list[i];
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
                        color: AppColors.accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.apartment_rounded, color: AppColors.accent, size: 22),
                    ),
                    title: Text('Terminal ${t.numero}',
                      style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                    subtitle: Text('Aeropuerto ID: ${t.idAeropuerto}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textFaint),
                    onTap: () => context.push('/terminales/${t.idTerminal}'),
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
