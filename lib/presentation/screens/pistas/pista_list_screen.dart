<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/pista_provider.dart';
=======
// lib/presentation/screens/pistas/pista_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../providers/pista_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_error_widget.dart';
import 'pista_form_screen.dart';
>>>>>>> 9c93e9e349b58cd690bce44268335422b70f5c53

class PistaListScreen extends ConsumerWidget {
  const PistaListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
<<<<<<< HEAD
    final state = ref.watch(pistasProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Pistas')),
      body: state.when(
        data: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (_, i) => ListTile(
            title: Text('Pista: ${data[i].id}'),
            onTap: () => context.push('/pistas/detalle', extra: data[i]),
          ),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/pistas/form'),
        child: const Icon(Icons.add),
=======
    final pistasAsync = ref.watch(pistasProvider);
    final isAuthenticated = ref.watch(authProvider).isAuthenticated;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Pistas')),
      floatingActionButton: isAuthenticated
        ? FloatingActionButton.extended(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PistaFormScreen()),
            ).then((_) => ref.invalidate(pistasProvider)),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Nueva pista'),
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.onAccent,
          )
        : null,
      body: pistasAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          error: e.toString(),
          onRetry: () => ref.invalidate(pistasProvider),
        ),
        data: (pistas) => pistas.isEmpty
          ? const AppEmptyState(
              message: 'No hay pistas registradas todavía',
              icon: Icons.flight_land_rounded,
            )
          : RefreshIndicator(
              onRefresh: () async => ref.invalidate(pistasProvider),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: pistas.length,
                itemBuilder: (context, index) {
                  final pista = pistas[index];
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
                        child: const Icon(Icons.flight_land_rounded, color: AppColors.accent, size: 22),
                      ),
                      title: Text(
                        'Pista ${pista.codigo}',
                        style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        'Estado: ${pista.estado}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                      onTap: () => context.push('/pistas/${pista.idPista}'),
                    ),
                  );
                },
              ),
            ),
>>>>>>> 9c93e9e349b58cd690bce44268335422b70f5c53
      ),
    );
  }
}