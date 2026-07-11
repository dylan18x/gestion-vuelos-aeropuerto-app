// lib/presentation/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.flight_takeoff_rounded, color: AppColors.accent, size: 20),
            SizedBox(width: 8),
            Text('Cotopaxi Airlines'),
          ],
        ),
        actions: [
          if (auth.isAuthenticated)
            IconButton(
              icon: const Icon(Icons.dashboard_rounded),
              onPressed: () => context.go('/dashboard'),
              tooltip: 'Dashboard',
            )
          else
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text('Ingresar', style: TextStyle(color: AppColors.accent)),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.surface, AppColors.surface2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tablero de Vuelos',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Información en tiempo real',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          const Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.flight_land_rounded, size: 64, color: AppColors.textFaint),
                  SizedBox(height: 12),
                  Text('Bienvenido a Cotopaxi Airlines',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Inicia sesión para ver el panel completo',
                    style: TextStyle(color: AppColors.textFaint, fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
