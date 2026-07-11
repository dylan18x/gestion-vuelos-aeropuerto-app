// lib/presentation/screens/tipos_avion/tipo_avion_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../providers/tipo_avion_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_empty_state.dart';
import '../../widgets/app_error_widget.dart';

class TipoAvionListScreen extends ConsumerWidget {
  const TipoAvionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tiposAsync = ref.watch(tiposAvionProvider);
    final isAdmin = ref.watch(authProvider).isAdmin;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Tipos de Avión')),
      floatingActionButton: isAdmin
        ? FloatingActionButton.extended(
            onPressed: () => context.push('/tipos-avion/nuevo'),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Nuevo'),
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.onAccent,
          )
        : null,
      body: tiposAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(error: e.toString(), onRetry: () => ref.invalidate(tiposAvionProvider)),
        data: (list) => list.isEmpty
          ? const AppEmptyState(message: 'No hay tipos de avión registrados', icon: Icons.category_rounded)
          : RefreshIndicator(
              onRefresh: () async => ref.invalidate(tiposAvionProvider),
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
                          color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.category_rounded, color: Color(0xFF8B5CF6), size: 22),
                      ),
                      title: Text(a.modelo, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                      subtitle: Text('Fabricante: ${a.fabricante} • Alcance: ${a.alcance}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      onTap: () => context.push('/tipos-avion/${a.idTipo}'),
                    ),
                  );
                },
              ),
            ),
      ),
    );
  }
}
