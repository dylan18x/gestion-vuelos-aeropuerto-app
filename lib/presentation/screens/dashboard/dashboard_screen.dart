// lib/presentation/screens/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';
import '../../../core/config/access_control.dart';
import '../../../domain/model/user.dart';
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

  String _roleLabel(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return ' Administrador';
      case UserRole.controlador:
        return ' Controlador';
      case UserRole.tecnico:
        return ' Técnico';
      case UserRole.rrhh:
        return ' RRHH';
      case UserRole.operadorVuelo:
        return ' Operador de Vuelo';
      case UserRole.sinRol:
        return ' Sin rol asignado';
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final user = auth.user;
    final role = auth.role;

    List<_Module> filterByRole(List<_Module> modules) =>
        modules.where((m) => AccessControl.canSeeModule(role, m.route)).toList();

    // Construimos las 4 secciones ya filtradas por rol
    final vuelosFiltrados = filterByRole(_vuelosModules);
    final infraestructuraFiltrada = filterByRole(_infraestructuraModules);
    final flotaFiltrada = filterByRole(_flotaModules);
    final personalFiltrado = filterByRole(_personalModules);

    // Armamos dinámicamente las pestañas visibles: solo las que tienen módulos
    final tabs = <_TabData>[
      if (vuelosFiltrados.isNotEmpty)
        _TabData('Vuelos', Icons.flight_takeoff, 'Gestión de Vuelos', vuelosFiltrados),
      if (infraestructuraFiltrada.isNotEmpty)
        _TabData('Lugar', Icons.business, 'Gestión de Infraestructura', infraestructuraFiltrada),
      if (flotaFiltrada.isNotEmpty)
        _TabData('Flota', Icons.build, 'Flota y Mantenimiento', flotaFiltrada),
      if (personalFiltrado.isNotEmpty)
        _TabData('Personal', Icons.people, 'Personal y Asignaciones', personalFiltrado),
    ];

    // Si el índice actual ya no existe (por cambio de rol/lista), lo corregimos
    if (_currentIndex >= tabs.length) {
      _currentIndex = 0;
    }

    final currentModules = tabs.isEmpty ? <_Module>[] : tabs[_currentIndex].modules;

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
      // NAVBAR INFERIOR — solo se muestra si hay más de una pestaña con contenido
      bottomNavigationBar: tabs.length <= 1
          ? null
          : NavigationBarTheme(
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
                destinations: tabs
                    .map((t) => NavigationDestination(
                          icon: Icon(t.icon, color: Colors.black),
                          label: t.label,
                        ))
                    .toList(),
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
                      Text(_roleLabel(role),
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Título de la sección dinámica
          if (tabs.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  tabs[_currentIndex].title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ),
            ),

          // Grilla que cambia de elementos dependiendo del Navbar
          if (currentModules.isNotEmpty)
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
            )
          else
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
                child: Center(
                  child: Text(
                    'No tienes módulos asignados todavía.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _TabData {
  final String label;
  final IconData icon;
  final String title;
  final List<_Module> modules;
  const _TabData(this.label, this.icon, this.title, this.modules);
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