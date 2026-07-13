// lib/domain/repository/mantenimiento_repository.dart
import '../model/mantenimiento.dart';

abstract class MantenimientoRepository {
  Future<List<Mantenimiento>> getMantenimientos();
  Future<Mantenimiento> getMantenimiento(int id);
  Future<Mantenimiento> createMantenimiento(Map<String, dynamic> payload);
  Future<Mantenimiento> updateMantenimiento(int id, Map<String, dynamic> payload);
  Future<void> deleteMantenimiento(int id);
}
