// lib/presentation/navigation/app_router.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/profile_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/vuelos/vuelo_detalle_screen.dart';
import '../screens/aeropuertos/aeropuerto_list_screen.dart';
import '../screens/aeropuertos/aeropuerto_form_screen.dart';
import '../screens/aeropuertos/aeropuerto_detalle_screen.dart';
import '../screens/terminales/terminal_list_screen.dart';
import '../screens/terminales/terminal_form_screen.dart';
import '../screens/terminales/terminal_detalle_screen.dart';
import '../screens/puertas/puerta_list_screen.dart';
import '../screens/puertas/puerta_form_screen.dart';
import '../screens/puertas/puerta_detalle_screen.dart';
import '../screens/aerolineas/aerolinea_list_screen.dart';
import '../screens/aerolineas/aerolinea_form_screen.dart';
import '../screens/aerolineas/aerolinea_detalle_screen.dart';
import '../screens/aviones/avion_list_screen.dart';
import '../screens/aviones/avion_form_screen.dart';
import '../screens/aviones/avion_detalle_screen.dart';
import '../screens/tipos_avion/tipo_avion_list_screen.dart';
import '../screens/tipos_avion/tipo_avion_form_screen.dart';
import '../screens/tipos_avion/tipo_avion_detalle_screen.dart';
import '../screens/mantenimientos/mantenimiento_list_screen.dart';
import '../screens/mantenimientos/mantenimiento_form_screen.dart';
import '../screens/mantenimientos/mantenimiento_detalle_screen.dart';
import '../screens/estado_vuelo/estado_vuelo_list_screen.dart';
import '../screens/estado_vuelo/estado_vuelo_form_screen.dart';
import '../screens/estado_vuelo/estado_vuelo_detalle_screen.dart';
import '../screens/clima/clima_list_screen.dart';
import '../screens/clima/clima_form_screen.dart';
import '../screens/clima/clima_detalle_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = ref.read(authProvider).isAuthenticated;
      final location   = state.uri.path;
      final isPublic   = location == '/' || location == '/login' || location.startsWith('/vuelos/');
      if (!isLoggedIn && !isPublic) return '/login';
      if (isLoggedIn && location == '/login') return '/dashboard';
      return null;
    },
    routes: [
      // ── Públicas ──────────────────────────────────────────────────────
      GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/vuelos/:id', builder: (_, s) =>
        VueloDetalleScreen(idVuelo: int.parse(s.pathParameters['id']!))),

      // ── Privadas ──────────────────────────────────────────────────────
      GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
      GoRoute(path: '/perfil',    builder: (_, __) => const ProfileScreen()),

      // Aeropuertos
      GoRoute(path: '/aeropuertos', builder: (_, __) => const AeropuertoListScreen()),
      GoRoute(path: '/aeropuertos/nuevo', builder: (_, __) => const AeropuertoFormScreen()),
      GoRoute(path: '/aeropuertos/:id', builder: (_, s) =>
        AeropuertoDetalleScreen(id: int.parse(s.pathParameters['id']!))),
      GoRoute(path: '/aeropuertos/:id/editar', builder: (_, s) =>
        const AeropuertoFormScreen()),

      // Terminales
      GoRoute(path: '/terminales', builder: (_, __) => const TerminalListScreen()),
      GoRoute(path: '/terminales/nuevo', builder: (_, __) => const TerminalFormScreen()),
      GoRoute(path: '/terminales/:id', builder: (_, s) =>
        TerminalDetalleScreen(id: int.parse(s.pathParameters['id']!))),
      GoRoute(path: '/terminales/:id/editar', builder: (_, s) => const TerminalFormScreen()),

      // Puertas
      GoRoute(path: '/puertas', builder: (_, __) => const PuertaListScreen()),
      GoRoute(path: '/puertas/nuevo', builder: (_, __) => const PuertaFormScreen()),
      GoRoute(path: '/puertas/:id', builder: (_, s) =>
        PuertaDetalleScreen(id: int.parse(s.pathParameters['id']!))),
      GoRoute(path: '/puertas/:id/editar', builder: (_, s) => const PuertaFormScreen()),

      // Aerolneas
      GoRoute(path: '/aerolineas', builder: (_, __) => const AerolineaListScreen()),
      GoRoute(path: '/aerolineas/nuevo', builder: (_, __) => const AerolineaFormScreen()),
      GoRoute(path: '/aerolineas/:id', builder: (_, s) =>
        AerolineaDetalleScreen(id: int.parse(s.pathParameters['id']!))),
      GoRoute(path: '/aerolineas/:id/editar', builder: (_, s) => const AerolineaFormScreen()),

      // Aviones
      GoRoute(path: '/aviones', builder: (_, __) => const AvionListScreen()),
      GoRoute(path: '/aviones/nuevo', builder: (_, __) => const AvionFormScreen()),
      GoRoute(path: '/aviones/:id', builder: (_, s) =>
        AvionDetalleScreen(id: int.parse(s.pathParameters['id']!))),
      GoRoute(path: '/aviones/:id/editar', builder: (_, s) => const AvionFormScreen()),

      // Tipos de avin
      GoRoute(path: '/tipos-avion', builder: (_, __) => const TipoAvionListScreen()),
      GoRoute(path: '/tipos-avion/nuevo', builder: (_, __) => const TipoAvionFormScreen()),
      GoRoute(path: '/tipos-avion/:id', builder: (_, s) =>
        TipoAvionDetalleScreen(id: int.parse(s.pathParameters['id']!))),
      GoRoute(path: '/tipos-avion/:id/editar', builder: (_, s) => const TipoAvionFormScreen()),

      // Mantenimientos
      GoRoute(path: '/mantenimientos', builder: (_, __) => const MantenimientoListScreen()),
      GoRoute(path: '/mantenimientos/nuevo', builder: (_, __) => const MantenimientoFormScreen()),
      GoRoute(path: '/mantenimientos/:id', builder: (_, s) =>
        MantenimientoDetalleScreen(id: int.parse(s.pathParameters['id']!))),
      GoRoute(path: '/mantenimientos/:id/editar', builder: (_, s) => const MantenimientoFormScreen()),

      // Estado de Vuelo
      GoRoute(path: '/estado-vuelo', builder: (_, __) => const EstadoVueloListScreen()),
      GoRoute(path: '/estado-vuelo/nuevo', builder: (_, __) => const EstadoVueloFormScreen()),
      GoRoute(path: '/estado-vuelo/:id', builder: (_, s) =>
        EstadoVueloDetalleScreen(id: int.parse(s.pathParameters['id']!))),
      GoRoute(path: '/estado-vuelo/:id/editar', builder: (_, s) => const EstadoVueloFormScreen()),

      // Clima
      GoRoute(path: '/clima', builder: (_, __) => const ClimaListScreen()),
      GoRoute(path: '/clima/nuevo', builder: (_, __) => const ClimaFormScreen()),
      GoRoute(path: '/clima/:id', builder: (_, s) =>
        ClimaDetalleScreen(id: int.parse(s.pathParameters['id']!))),
      GoRoute(path: '/clima/:id/editar', builder: (_, s) => const ClimaFormScreen()),
    ],
  );

  ref.listen(authProvider, (previous, next) {
    if (previous?.isAuthenticated != next.isAuthenticated) {
      router.refresh();
    }
  });

  return router;
});