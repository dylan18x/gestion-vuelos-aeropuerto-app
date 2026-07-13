// lib/presentation/screens/autorizacion_vuelo/autorizacion_vuelo_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/formatters.dart';
import '../../../theme/app_colors.dart';
import '../../providers/autorizacion_vuelo_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_error_widget.dart';
import 'autorizacion_vuelo_form_screen.dart';

class AutorizacionVueloListScreen extends ConsumerWidget {
  const AutorizacionVueloListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autorizacionesAsync = ref.watch(autorizacionesVueloProvider);
    final isAuthenticated = ref.watch(authProvider).isAuthenticated;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Autorizaciones de Vuelo')),
      floatingActionButton: isAuthenticated
        ? FloatingActionButton.extended(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AutorizacionFormScreen()),
            ).then((_) => ref.invalidate(autorizacionesVueloProvider)),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Nueva autorización'),
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.onAccent,
          )
        : null,
      body: autorizacionesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          error: e.toString(),
          onRetry: () => ref.invalidate(autorizacionesVueloProvider),
        ),
        data: (autorizaciones) => autorizaciones.isEmpty
          ? const AppEmptyState(
              message: 'No hay autorizaciones de vuelo todavía',
              icon: Icons.verified_rounded,
            )
          : RefreshIndicator(
              onRefresh: () async => ref.invalidate(autorizacionesVueloProvider),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: autorizaciones.length,
                itemBuilder: (context, index) {
                  final autorizacion = autorizaciones[index];
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
                        child: const Icon(Icons.verified_rounded, color: AppColors.accent, size: 22),
                      ),
                      title: Text(
                        '${autorizacion.tipoAutorizacion} · Vuelo ${autorizacion.idVuelo}',
                        style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${autorizacion.estado} · ${formatDate(autorizacion.fecha)}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                      onTap: () => context.push('/autorizacion-vuelo/${autorizacion.idAutorizacion}'),
                    ),
                  );
                },
              ),
            ),
      ),
    );
  }
}