// lib/presentation/screens/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../providers/auth_provider.dart';


class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  // Variable para controlar qué pestaña del navbar está seleccionada
  int _currentIndex = 0;

  // Agrupamos los módulos en 4 listas según la categoría
  final List<_Module> _infraestructuraModules = const [
    _Module('Aeropuertos', Icons.location_city_rounded, '/aeropuertos', AppColors.info),
    _Module('Terminales', Icons.apartment_rounded, '/terminales', AppColors.accent),
    _Module('Puertas', Icons.door_sliding_rounded, '/puertas', AppColors.success),
    _Module('Pistas', Icons.add_road_rounded, '/pistas', Color(0xFF10B981)),
    _Module('Torres de Control', Icons.radar_rounded, '/torres-control', Color(0xFF10B981)),
  ];

  final List<_Module> _vuelosModules = const [
    _Module('Vuelos', Icons.flight_takeoff_rounded, '/vuelos', Color(0xFF3B82F6)),
    _Module('Aerolíneas', Icons.airlines_rounded, '/aerolineas', AppColors.warning),
    _Module('Rutas', Icons.route_rounded, '/rutas', Color(0xFF0EA5E9)),
    _Module('Escalas', Icons.alt_route_rounded, '/escalas', Color(0xFF14B8A6)),
    _Module('Horarios', Icons.schedule_rounded, '/horarios', Color(0xFFF59E0B)),
    _Module('Estado Vuelo', Icons.flag_rounded, '/estado-vuelo', AppColors.accent),
    _Module('Historial Vuelo', Icons.history_rounded, '/historial-estados-vuelo', AppColors.success),
    _Module('Clima', Icons.cloud_rounded, '/clima', AppColors.info),
    _Module('Registros de Vuelo', Icons.assignment_rounded, '/registros-vuelo', Color(0xFF8B5CF6)),
    _Module('Controles Tráfico', Icons.traffic_rounded, '/controles-trafico', Color(0xFFF97316)),
    _Module('Autorizaciones', Icons.verified_rounded, '/autorizaciones-vuelo', Color(0xFF10B981)),
  ];

  final List<_Module> _flotaModules = const [
    _Module('Aviones', Icons.flight_rounded, '/aviones', AppColors.error),
    _Module('Tipos de Avión', Icons.category_rounded, '/tipos-avion', Color(0xFF8B5CF6)),
    _Module('Mantenimientos', Icons.build_circle_rounded, '/mantenimientos', Color(0xFF14B8A6)),
    _Module('Incidentes', Icons.report_problem_rounded, '/incidentes', Color(0xFFF43F5E)),
    _Module('Asignación Pista', Icons.airplane_ticket_rounded, '/asignacion-pista', Color(0xFF3B82F6)),
  ];

  final List<_Module> _personalModules = const [
    _Module('Empleados', Icons.badge_rounded, '/empleados', Color(0xFF3B82F6)),
    _Module('Pilotos', Icons.person_rounded, '/pilotos', Color(0xFF10B981)),
    _Module('Tripulación', Icons.groups_rounded, '/tripulacion', Color(0xFF8B5CF6)),
    _Module('Asignación Trip.', Icons.group_add_rounded, '/asignacion-tripulacion', Color(0xFF10B981)),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final user = auth.user;

    // Dependiendo del índice del navbar, mostramos una lista u otra
    List<_Module> currentModules = [];
    switch (_currentIndex) {
      case 0:
        currentModules = _vuelosModules;
        break;
      case 1:
        currentModules = _infraestructuraModules;
        break;
      case 2:
        currentModules = _flotaModules;
        break;
      case 3:
        currentModules = _personalModules;
        break;
    }

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
      // NAVBAR INFERIOR
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
            (states) => const TextStyle(color: Colors.black),
          ),
        ),
        child: NavigationBar(
          backgroundColor: Colors.white,
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.flight_takeoff, color: Colors.black), label: 'Vuelos'),
            NavigationDestination(icon: Icon(Icons.business, color: Colors.black), label: 'Lugar'),
            NavigationDestination(icon: Icon(Icons.build, color: Colors.black), label: 'Flota'),
            NavigationDestination(icon: Icon(Icons.people, color: Colors.black), label: 'Personal'),
          ],
        ),
      ),
      // CUERPO: Muestra el header fijo y los módulos dinámicos abajo
      body: CustomScrollView(
        slivers: [
          // Header de Bienvenida (Fijo)
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
          
          // Título de la sección dinámica
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                _currentIndex == 0 ? 'Gestión de Vuelos' :
                _currentIndex == 1 ? 'Gestión de Infraestructura' :
                _currentIndex == 2 ? 'Flota y Mantenimiento' : 'Personal y Asignaciones',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ),
          ),

          // Grilla que cambia de elementos dependiendo del Navbar
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _ModuleCard(module: currentModules[i]),
                childCount: currentModules.length,
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