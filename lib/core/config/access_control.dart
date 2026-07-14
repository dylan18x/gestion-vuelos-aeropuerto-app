import '../../domain/model/user.dart';

/// Centraliza qué prefijos de ruta puede ver cada rol.
/// Ajusta estos sets si algún módulo no calza con el rol real del backend.
class AccessControl {
  static const Map<UserRole, Set<String>> _roleRoutes = {
    UserRole.controlador: {
      '/control-trafico',
      '/controles-trafico',
      '/torres-control',
      '/pistas',
      '/asignacion-pista',
      '/autorizaciones-vuelo',
      '/vuelos',
      '/estado-vuelo',
      '/historial-estados-vuelo',
    },
    UserRole.tecnico: {
      '/aviones',
      '/tipos-avion',
      '/mantenimientos',
      '/incidentes',
    },
    UserRole.rrhh: {
      '/empleados',
      '/pilotos',
      '/tripulacion',
      '/asignacion-tripulacion',
    },
    UserRole.operadorVuelo: {
      '/vuelos',
      '/aerolineas',
      '/rutas',
      '/escalas',
      '/horarios',
      '/estado-vuelo',
      '/historial-estados-vuelo',
      '/clima',
      '/aeropuertos',
      '/terminales',
      '/puertas',
      '/registros-vuelo',
    },
    UserRole.sinRol: {},
  };

  /// Rutas que TODOS los roles autenticados pueden ver, sin importar el rol.
  static const Set<String> _commonRoutes = {
    '/dashboard',
    '/perfil',
  };

  static bool canAccess(UserRole role, String location) {
    if (role == UserRole.admin) return true;

    final allowed = {..._commonRoutes, ...?_roleRoutes[role]};
    return allowed.any((p) => location == p || location.startsWith('$p/'));
  }

  /// Usado por el Dashboard para filtrar módulos visibles.
  static bool canSeeModule(UserRole role, String moduleRoute) {
    if (role == UserRole.admin) return true;
    final allowed = _roleRoutes[role] ?? {};
    return allowed.any((p) => moduleRoute == p || moduleRoute.startsWith('$p/'));
  }
}