// lib/domain/repository/asignacion_tripulacion_repository.dart
import '../model/asignacion_tripulacion.dart';

abstract class AsignacionTripulacionRepository {
  Future<List<AsignacionTripulacion>> getAllAsignacionesTripulacion();
  
  Future<AsignacionTripulacion> getAsignacionTripulacionById(int id);
  
  Future<void> createAsignacionTripulacion(AsignacionTripulacion asignacion);
  
  Future<void> updateAsignacionTripulacion(AsignacionTripulacion asignacion);
  
  Future<void> deleteAsignacionTripulacion(int id);
}