// lib/domain/repository/empleado_repository.dart
import '../model/empleado.dart';

abstract class EmpleadoRepository {
  Future<PaginatedEmpleados> getEmpleados({String? cargo});
  Future<Empleado>           getEmpleado(int id);
  Future<Empleado>           createEmpleado(Map<String, dynamic> payload);
  Future<Empleado>           updateEmpleado(int id, Map<String, dynamic> payload);
  Future<void>                deleteEmpleado(int id); // solo ADMIN
}