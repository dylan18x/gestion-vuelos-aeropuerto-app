// lib/presentation/screens/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../providers/auth_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final user = auth.user;

    final modules = [
      const _Module('Vuelos',         Icons.flight_takeoff_rounded,   '/vuelos',         Color(0xFF3B82F6)),
      const _Module('Aeropuertos',    Icons.location_city_rounded,   '/aeropuertos',    AppColors.info),
      const _Module('Terminales',     Icons.apartment_rounded,        '/terminales',     AppColors.accent),
      const _Module('Puertas',        Icons.door_sliding_rounded,     '/puertas',        AppColors.success),
      const _Module('Aerolíneas',     Icons.airlines_rounded,         '/aerolineas',     AppColors.warning),
      const _Module('Aviones',        Icons.flight_rounded,           '/aviones',        AppColors.error),
      const _Module('Tipos de Avión', Icons.category_rounded,         '/tipos-avion',    Color(0xFF8B5CF6)),
      const _Module('Mantenimientos', Icons.build_circle_rounded,     '/mantenimientos', Color(0xFF14B8A6)),
      const _Module('Estado Vuelo',   Icons.flag_rounded,             '/estado-vuelo',   AppColors.accent),
      const _Module('Clima',          Icons.cloud_rounded,            '/clima',          AppColors.info),
      const _Module('Historial Estado Vuelo', Icons.history_rounded, '/historial-estados-vuelo', AppColors.success),
      const _Module('Rutas',          Icons.route_rounded,            '/rutas',          Color(0xFF0EA5E9)),
      const _Module('Tripulación',    Icons.groups_rounded,           '/tripulacion',   Color(0xFF8B5CF6)),
      const _Module('Escalas',        Icons.alt_route_rounded,        '/escalas',        Color(0xFF14B8A6)),
      const _Module('Horarios',       Icons.schedule_rounded,         '/horarios',      Color(0xFFF59E0B)),
      const _Module('Controles de Tráfico', Icons.traffic_rounded, '/controles-trafico', Color(0xFFF97316)),
      const _Module('Empleados',      Icons.badge_rounded,            '/empleados',      Color(0xFF3B82F6)),
      const _Module('Pilotos',        Icons.person_rounded,           '/pilotos',        Color(0xFF10B981)),
      const _Module('Incidentes',     Icons.report_problem_rounded,   '/incidentes'  ,Color(0xFFF43F5E)),
      const _Module('Registros de Vuelo', Icons.assignment_rounded,   '/registros-vuelo', Color(0xFF8B5CF6)),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: AppColors.accent,
              radius: 16,
              child: Icon(Icons.person_rounded, color: AppColors.onAccent, size: 18),
            ),
            onPressed: () => context.push('/perfil'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.surface, AppColors.surface2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.accent,
                    child: Icon(Icons.person_rounded, color: AppColors.onAccent, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('¡Bienvenido, ${user?.username ?? ''}!',
                        style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(auth.isAdmin ? ' Administrador' : ' Torre de Control',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _ModuleCard(module: modules[i]),
                childCount: modules.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _Module {
  final String title;
  final IconData icon;
  final String route;
  final Color color;
  const _Module(this.title, this.icon, this.route, this.color);
}

class _ModuleCard extends StatelessWidget {
  final _Module module;
  const _ModuleCard({required this.module});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => context.push(module.route),
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: module.color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(module.icon, color: module.color, size: 28),
          ),
          const SizedBox(height: 10),
          Text(module.title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    ),
  );
}