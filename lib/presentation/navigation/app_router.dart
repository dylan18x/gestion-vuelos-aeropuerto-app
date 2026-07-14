// lib/presentation/navigation/app_router.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_shop_app/presentation/screens/public/contact_screen.dart';
import 'package:flutter_shop_app/presentation/screens/public/flight_detail_screen.dart';
import 'package:flutter_shop_app/presentation/screens/public/flights_screen.dart';
import 'package:flutter_shop_app/presentation/screens/public/information_screen.dart';
import 'package:flutter_shop_app/presentation/screens/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/access_control.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/profile_screen.dart';
import '../screens/public/home_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/vuelos/vuelo_detalle_screen.dart';
import '../screens/vuelos/vuelo_form_screen.dart';
import '../screens/vuelos/vuelo_list_screen.dart';
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
import '../screens/historial_estado_vuelo/historial_estado_vuelo_list_screen.dart';
import '../screens/historial_estado_vuelo/historial_estado_vuelo_form_screen.dart';
import '../screens/control_trafico/control_trafico_list_screen.dart';
import '../screens/rutas/ruta_list_screen.dart';
import '../screens/rutas/ruta_form_screen.dart';
import '../screens/rutas/ruta_detalle_screen.dart';
import '../screens/tripulaciones/tripulacion_list_screen.dart';
import '../screens/tripulaciones/tripulacion_form_screen.dart';
import '../screens/tripulaciones/tripulacion_detalle_screen.dart';
import '../screens/control_trafico/control_trafico_form_screen.dart';
import '../screens/control_trafico/control_trafico_detalle_screen.dart';
import '../screens/empleado/empleado_list_screen.dart';
import '../screens/empleado/empleado_form_screen.dart';
import '../screens/empleado/empleado_detalle_screen.dart';
import '../screens/escalas/escala_list_screen.dart';
import '../screens/escalas/escala_form_screen.dart';
import '../screens/escalas/escala_detalle_screen.dart';
import '../screens/horarios/horario_list_screen.dart';
import '../screens/horarios/horario_form_screen.dart';
import '../screens/horarios/horario_detalle_screen.dart';
import '../screens/incidente/incidente_list_screen.dart';
import '../screens/incidente/incidente_form_screen.dart';
import '../screens/incidente/incidente_detalle_screen.dart';
import '../screens/piloto/piloto_list_screen.dart';
import '../screens/piloto/piloto_form_screen.dart';
import '../screens/piloto/piloto_detalle_screen.dart';
import '../screens/registro_vuelo/registro_vuelo_list_screen.dart';
import '../screens/registro_vuelo/registro_vuelo_form_screen.dart';
import '../screens/registro_vuelo/registro_vuelo_detalle_screen.dart';

import '../screens/torre_control/torre_control_list_screen.dart';
import '../screens/torre_control/torre_control_detalle_screen.dart';
import '../screens/torre_control/torre_control_form_screen.dart';
import '../screens/pistas/pista_list_screen.dart';
import '../screens/pistas/pista_detalle_screen.dart';
import '../screens/asignacion_tripulacion/asignacion_tripulacion_list_screen.dart';
import '../screens/asignacion_tripulacion/asignacion_tripulacion_detalle_screen.dart';
import '../screens/asignacion_pista/asignacion_pista_list_screen.dart';
import '../screens/asignacion_pista/asignacion_pista_detalle_screen.dart';
import '../screens/autorizacion_vuelo/autorizacion_vuelo_list_screen.dart';
import '../screens/autorizacion_vuelo/autorizacion_vuelo_detalle_screen.dart';
import '../screens/error/not_found_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/splash',
    errorBuilder: (context, state) => const NotFoundScreen(),
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isLoggedIn = authState.isAuthenticated;
      final role = authState.role;
      final location = state.uri.path;

      final publicRoutes = {
        '/',
        '/splash',
        '/login',
        '/flights',
        '/flight-detail',
        '/information',
        '/contact',
      };

      final isPublic =
          publicRoutes.contains(location) || location.startsWith('/vuelos/');

      // Rutas privadas conocidas
      final privatePrefixes = [
        '/dashboard',
        '/perfil',
        '/aeropuertos',
        '/terminales',
        '/puertas',
        '/aerolineas',
        '/aviones',
        '/tipos-avion',
        '/mantenimientos',
        '/estado-vuelo',
        '/clima',
        '/vuelos',
        '/historial-estados-vuelo',
        '/controles-trafico',
        '/control-trafico',
        '/empleados',
        '/rutas',
        '/tripulacion',
        '/escalas',
        '/horarios',
        '/incidentes',
        '/pilotos',
        '/registros-vuelo',
        '/asignacion-pista',
        '/asignacion-tripulacion',
        '/autorizaciones-vuelo',
        '/pistas',
        '/torres-control',
      ];

      final isPrivate = privatePrefixes.any(
        (p) => location == p || location.startsWith('$p/'),
      );

      // Si no pertenece a ninguna ruta conocida,
      // dejar que GoRouter muestre el error 404.
      if (!isPublic && !isPrivate) {
        return null;
      }

      if (!isLoggedIn && isPrivate) {
        return '/login';
      }

      if (isLoggedIn && (location == '/login' || location == '/splash')) {
        return '/dashboard';
      }

      // 🔒 Si está logueado pero su rol no tiene acceso a esta ruta privada,
      // lo mandamos de vuelta al dashboard (que le mostrará solo lo suyo).
      if (isLoggedIn && isPrivate && !AccessControl.canAccess(role, location)) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      // ── Públicas ──────────────────────────────────────────────────────
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(
        path: '/contact',
        builder: (context, state) => const ContactScreen(),
      ),
      GoRoute(
        path: '/flights',
        builder: (context, state) => const FlightsScreen(),
      ),
      GoRoute(
        path: '/flight-detail',
        builder: (context, state) => const FlightDetailScreen(),
      ),
      GoRoute(
        path: '/information',
        builder: (context, state) => const InformationScreen(),
      ),

      // ── Privadas ──────────────────────────────────────────────────────
      GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
      GoRoute(path: '/perfil', builder: (_, __) => const ProfileScreen()),

      // Aeropuertos
      GoRoute(
          path: '/aeropuertos',
          builder: (_, __) => const AeropuertoListScreen()),
      GoRoute(
          path: '/aeropuertos/nuevo',
          builder: (_, __) => const AeropuertoFormScreen()),
      GoRoute(
          path: '/aeropuertos/:id',
          builder: (_, s) =>
              AeropuertoDetalleScreen(id: int.parse(s.pathParameters['id']!))),
      GoRoute(
          path: '/aeropuertos/:id/editar',
          builder: (_, s) => const AeropuertoFormScreen()),

      // Terminales
      GoRoute(
          path: '/terminales', builder: (_, __) => const TerminalListScreen()),
      GoRoute(
          path: '/terminales/nuevo',
          builder: (_, __) => const TerminalFormScreen()),
      GoRoute(
          path: '/terminales/:id',
          builder: (_, s) =>
              TerminalDetalleScreen(id: int.parse(s.pathParameters['id']!))),
      GoRoute(
          path: '/terminales/:id/editar',
          builder: (_, s) => const TerminalFormScreen()),

      // Puertas
      GoRoute(path: '/puertas', builder: (_, __) => const PuertaListScreen()),
      GoRoute(
          path: '/puertas/nuevo', builder: (_, __) => const PuertaFormScreen()),
      GoRoute(
          path: '/puertas/:id',
          builder: (_, s) =>
              PuertaDetalleScreen(id: int.parse(s.pathParameters['id']!))),
      GoRoute(
          path: '/puertas/:id/editar',
          builder: (_, s) => const PuertaFormScreen()),

      // Aerolneas
      GoRoute(
          path: '/aerolineas', builder: (_, __) => const AerolineaListScreen()),
      GoRoute(
          path: '/aerolineas/nuevo',
          builder: (_, __) => const AerolineaFormScreen()),
      GoRoute(
          path: '/aerolineas/:id',
          builder: (_, s) =>
              AerolineaDetalleScreen(id: int.parse(s.pathParameters['id']!))),
      GoRoute(
          path: '/aerolineas/:id/editar',
          builder: (_, s) => const AerolineaFormScreen()),

      // Aviones
      GoRoute(path: '/aviones', builder: (_, __) => const AvionListScreen()),
      GoRoute(
          path: '/aviones/nuevo', builder: (_, __) => const AvionFormScreen()),
      GoRoute(
          path: '/aviones/:id',
          builder: (_, s) =>
              AvionDetalleScreen(id: int.parse(s.pathParameters['id']!))),
      GoRoute(
          path: '/aviones/:id/editar',
          builder: (_, s) => const AvionFormScreen()),

      // Tipos de avión
      GoRoute(
          path: '/tipos-avion',
          builder: (_, __) => const TipoAvionListScreen()),
      GoRoute(
          path: '/tipos-avion/nuevo',
          builder: (_, __) => const TipoAvionFormScreen()),
      GoRoute(
          path: '/tipos-avion/:id',
          builder: (_, s) =>
              TipoAvionDetalleScreen(id: int.parse(s.pathParameters['id']!))),
      GoRoute(
          path: '/tipos-avion/:id/editar',
          builder: (_, s) => const TipoAvionFormScreen()),

      // Mantenimientos
      GoRoute(
          path: '/mantenimientos',
          builder: (_, __) => const MantenimientoListScreen()),
      GoRoute(
          path: '/mantenimientos/nuevo',
          builder: (_, __) => const MantenimientoFormScreen()),
      GoRoute(
          path: '/mantenimientos/:id',
          builder: (_, s) => MantenimientoDetalleScreen(
              id: int.parse(s.pathParameters['id']!))),
      GoRoute(
          path: '/mantenimientos/:id/editar',
          builder: (_, s) => const MantenimientoFormScreen()),

      // Estado de Vuelo
      GoRoute(
          path: '/estado-vuelo',
          builder: (_, __) => const EstadoVueloListScreen()),
      GoRoute(
          path: '/estado-vuelo/nuevo',
          builder: (_, __) => const EstadoVueloFormScreen()),
      GoRoute(
          path: '/estado-vuelo/:id',
          builder: (_, s) =>
              EstadoVueloDetalleScreen(id: int.parse(s.pathParameters['id']!))),
      GoRoute(
          path: '/estado-vuelo/:id/editar',
          builder: (_, s) => const EstadoVueloFormScreen()),

      // Clima
      GoRoute(path: '/clima', builder: (_, __) => const ClimaListScreen()),
      GoRoute(
          path: '/clima/nuevo', builder: (_, __) => const ClimaFormScreen()),
      GoRoute(
          path: '/clima/:id',
          builder: (_, s) =>
              ClimaDetalleScreen(id: int.parse(s.pathParameters['id']!))),
      GoRoute(
          path: '/clima/:id/editar',
          builder: (_, s) => const ClimaFormScreen()),

      //vuelos
      GoRoute(path: '/vuelos', builder: (_, __) => const VueloListScreen()),
      GoRoute(
          path: '/vuelos/nuevo', builder: (_, __) => const VueloFormScreen()),
      GoRoute(
          path: '/vuelos/:id',
          builder: (_, s) =>
              VueloDetalleScreen(idVuelo: int.parse(s.pathParameters['id']!))),
      GoRoute(
          path: '/vuelos/:id/editar',
          builder: (_, s) => const VueloFormScreen()),

      // Historial de estados de vuelo
      GoRoute(
          path: '/historial-estados-vuelo',
          builder: (_, __) => const HistorialEstadoVueloListScreen()),
      GoRoute(
          path: '/historial-estados-vuelo/nuevo',
          builder: (_, __) => const HistorialEstadoVueloFormScreen()),

      // Controles de tráfico
      GoRoute(
          path: '/controles-trafico',
          builder: (_, __) => const ControlTraficoListScreen()),
      GoRoute(
          path: '/control-trafico/nuevo',
          builder: (_, __) => const ControlTraficoFormScreen()),
      GoRoute(
          path: '/control-trafico/:id',
          builder: (_, s) => ControlTraficoDetalleScreen(
              id: int.parse(s.pathParameters['id']!))),
      GoRoute(
          path: '/control-trafico/:id/editar',
          builder: (_, s) => const ControlTraficoFormScreen()),

      // Empleados
      GoRoute(
          path: '/empleados', builder: (_, __) => const EmpleadoListScreen()),
      GoRoute(
          path: '/empleados/nuevo',
          builder: (_, __) => const EmpleadoFormScreen()),
      GoRoute(
          path: '/empleados/:id',
          builder: (_, s) =>
              EmpleadoDetalleScreen(id: int.parse(s.pathParameters['id']!))),
      GoRoute(
          path: '/empleados/:id/editar',
          builder: (_, s) => const EmpleadoFormScreen()),

      // Rutas
      GoRoute(path: '/rutas', builder: (_, __) => const RutaListScreen()),
      GoRoute(path: '/rutas/nuevo', builder: (_, __) => const RutaFormScreen()),
      GoRoute(
          path: '/rutas/:id',
          builder: (_, s) =>
              RutaDetalleScreen(id: int.parse(s.pathParameters['id']!))),
      GoRoute(
          path: '/rutas/:id/editar', builder: (_, s) => const RutaFormScreen()),

      // Tripulación
      GoRoute(
          path: '/tripulacion',
          builder: (_, __) => const TripulacionListScreen()),
      GoRoute(
          path: '/tripulacion/nuevo',
          builder: (_, __) => const TripulacionFormScreen()),
      GoRoute(
          path: '/tripulacion/:id',
          builder: (_, s) =>
              TripulacionDetalleScreen(id: int.parse(s.pathParameters['id']!))),
      GoRoute(
          path: '/tripulacion/:id/editar',
          builder: (_, s) => const TripulacionFormScreen()),

      // Escalas
      GoRoute(path: '/escalas', builder: (_, __) => const EscalaListScreen()),
      GoRoute(
          path: '/escalas/:idVuelo',
          builder: (_, s) => EscalaDetalleScreen(
              idVuelo: int.parse(s.pathParameters['idVuelo']!))),

      // Horarios
      GoRoute(path: '/horarios', builder: (_, __) => const HorarioListScreen()),
      GoRoute(
          path: '/horarios/:idVuelo',
          builder: (_, s) => HorarioDetalleScreen(
              idVuelo: int.parse(s.pathParameters['idVuelo']!))),

      // Incidentes
      GoRoute(
          path: '/incidentes', builder: (_, __) => const IncidenteListScreen()),
      GoRoute(
          path: '/incidentes/nuevo',
          builder: (_, __) => const IncidenteFormScreen()),
      GoRoute(
          path: '/incidentes/:id',
          builder: (_, s) =>
              IncidenteDetalleScreen(id: int.parse(s.pathParameters['id']!))),

      // Pilotos
      GoRoute(path: '/pilotos', builder: (_, __) => const PilotoListScreen()),
      GoRoute(
          path: '/pilotos/nuevo', builder: (_, __) => const PilotoFormScreen()),
      GoRoute(
          path: '/pilotos/:id',
          builder: (_, s) =>
              PilotoDetalleScreen(id: int.parse(s.pathParameters['id']!))),

      // Registros de vuelo
      GoRoute(
          path: '/registros-vuelo',
          builder: (_, __) => const RegistroVueloListScreen()),
      GoRoute(
          path: '/registros-vuelo/nuevo',
          builder: (_, __) => const RegistroVueloFormScreen()),
      GoRoute(
          path: '/registros-vuelo/:id',
          builder: (_, s) => RegistroVueloDetalleScreen(
              id: int.parse(s.pathParameters['id']!))),

      GoRoute(
          path: '/asignacion-pista',
          builder: (_, __) => const AsignacionPistaListScreen()),
      GoRoute(
          path: '/asignacion-pista/:id',
          builder: (_, s) => AsignacionPistaDetalleScreen(
              id: int.parse(s.pathParameters['id']!))),
      GoRoute(
          path: '/asignacion-tripulacion',
          builder: (_, __) => const AsignacionTripulacionListScreen()),
      GoRoute(
          path: '/asignacion-tripulacion/:id',
          builder: (_, s) => AsignacionTripulacionDetalleScreen(
              id: int.parse(s.pathParameters['id']!))),
      GoRoute(
          path: '/autorizaciones-vuelo',
          builder: (_, __) => const AutorizacionVueloListScreen()),
      GoRoute(
          path: '/autorizaciones-vuelo/:id',
          builder: (_, s) => AutorizacionDetalleScreen(
              id: int.parse(s.pathParameters['id']!))),
      GoRoute(path: '/pistas', builder: (_, __) => const PistaListScreen()),
      GoRoute(
          path: '/pistas/:id',
          builder: (_, s) =>
              PistaDetalleScreen(id: int.parse(s.pathParameters['id']!))),
      GoRoute(
          path: '/torres-control',
          builder: (_, __) => const TorreControlListScreen()),
      GoRoute(
          path: '/torres-control/nuevo',
          builder: (_, __) => const TorreControlFormScreen()),
      GoRoute(
          path: '/torres-control/:id',
          builder: (_, s) => TorreControlDetalleScreen(
              id: int.parse(s.pathParameters['id']!))),
      GoRoute(
          path: '/torres-control/:id/editar',
          builder: (_, s) =>
              TorreControlFormScreen(id: int.parse(s.pathParameters['id']!))),
    ],
  );

  ref.listen(authProvider, (previous, next) {
    if (previous?.isAuthenticated != next.isAuthenticated ||
        previous?.role != next.role) {
      router.refresh();
    }
  });

  return router;
});