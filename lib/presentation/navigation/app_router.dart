// lib/presentation/navigation/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/vuelos/vuelos_publico_screen.dart';
import '../screens/vuelos/vuelo_detalle_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const VuelosPublicoScreen(),
      ),
      GoRoute(
        path: '/vuelos/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return VueloDetalleScreen(idVuelo: id);
        },
      ),
    ],
  );
});