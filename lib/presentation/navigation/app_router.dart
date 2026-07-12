import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/profile_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/vuelos/vuelo_detalle_screen.dart';

// --- Tus nuevas rutas (asegúrate de crear estos archivos en tus carpetas respectivas) ---
import '../screens/asignacion_pista/asignacion_pista_list_screen.dart';
import '../screens/asignacion_tripulacion/asignacion_tripulacion_list_screen.dart';
import '../screens/autorizacion_vuelo/autorizacion_vuelo_list_screen.dart';
import '../screens/pista/pista_list_screen.dart';
import '../screens/torre_control/torre_control_list_screen.dart';

// [AQUÍ DEBERÍAS MANTENER LOS DEMÁS IMPORTS QUE YA TENÍA TU COMPAÑERO]

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
      GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/vuelos/:id', builder: (_, s) =>
        VueloDetalleScreen(idVuelo: int.parse(s.pathParameters['id']!))),

      GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
      GoRoute(path: '/perfil',    builder: (_, __) => const ProfileScreen()),

      // ── mis rutas dario  ──────────────────────────────────────────────
      GoRoute(path: '/asignacion-pista', builder: (_, __) => const AsignacionPistaListScreen()),
      GoRoute(path: '/asignacion-tripulacion', builder: (_, __) => const AsignacionTripulacionListScreen()),
      GoRoute(path: '/autorizacion-vuelo', builder: (_, __) => const AutorizacionVueloListScreen()),
      GoRoute(path: '/pistas', builder: (_, __) => const PistaListScreen()),
      GoRoute(path: '/torres-control', builder: (_, __) => const TorreControlListScreen()),
      
    ],
  );

  ref.listen(authProvider, (previous, next) {
    if (previous?.isAuthenticated != next.isAuthenticated) {
      router.refresh();
    }
  });

  return router;
});