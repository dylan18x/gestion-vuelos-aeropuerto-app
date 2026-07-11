// lib/presentation/screens/aeropuertos/aeropuerto_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../providers/aeropuerto_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_error_widget.dart';

class AeropuertoListScreen extends ConsumerWidget {
  const AeropuertoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aeropuertosAsync = ref.watch(aeropuertosProvider);
    final isAdmin = ref.watch(authProvider).isAdmin;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Aeropuertos')),
      floatingActionButton: isAdmin
        ? FloatingActionButton.extended(
            onPressed: () => context.push('/aeropuertos/nuevo'),
            icon: const Icon(Icons.add),
            label: const Text('Nuevo'),
          )
        : null,
      body: aeropuertosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          error: e.toString(),
          onRetry: () => ref.invalidate(aeropuertosProvider),
        ),
        data: (list) {
          if (list.isEmpty) {
            return const AppEmptyState(
              message: 'No hay aeropuertos registrados',
              icon: Icons.location_city_outlined,
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(aeropuertosProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (_, i) {
                final a = list[i];
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
                        color: AppColors.info.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.location_city_rounded, color: AppColors.info, size: 22),
                    ),
                    title: Text(a.nombre,
                      style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                    subtitle: Text('${a.ciudad}, ${a.pais} · ${a.codigoIata}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textFaint),
                    onTap: () => context.push('/aeropuertos/${a.idAeropuerto}'),
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
