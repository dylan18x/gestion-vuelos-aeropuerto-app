// lib/presentation/screens/auth/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final user = auth.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: user == null
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 16),
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.accent,
                  child: Text(
                    user.username.substring(0, 1).toUpperCase(),
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.onAccent),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(child: Text(user.username,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold))),
              const SizedBox(height: 4),
              Center(child: Text(auth.isAdmin ? 'Administrador' : 'Torre de Control',
                style: TextStyle(color: auth.isAdmin ? AppColors.accent : AppColors.info, fontSize: 13))),
              const SizedBox(height: 32),
              _InfoTile(icon: Icons.email_outlined, label: 'Email', value: user.email),
              _InfoTile(
                icon: Icons.badge_outlined,
                label: 'Nombre',
                value: '${user.firstName} ${user.lastName}'.trim(),
              ),
              _InfoTile(
                icon: Icons.verified_user_outlined,
                label: 'Estado',
                value: user.isActive ? 'Activo' : 'Inactivo',
              ),
              const SizedBox(height: 32),
              OutlinedButton.icon(
                icon: const Icon(Icons.logout_rounded, color: AppColors.error),
                label: const Text('Cerrar sesión', style: TextStyle(color: AppColors.error)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.error)),
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) context.go('/login');
                },
              ),
            ],
          ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
    ),
    child: Row(
      children: [
        Icon(icon, color: AppColors.accent, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
            Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    ),
  );
}
