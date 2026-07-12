// lib/domain/repository/asignacion_pista_repository.dart
import '../model/asignacion_pista.dart';

abstract class AsignacionPistaRepository {
  Future<List<AsignacionPista>> getAllAsignacionesPista();
  
  Future<AsignacionPista> getAsignacionPistaById(int id);
  
  Future<void> createAsignacionPista(AsignacionPista asignacion);
  
  Future<void> updateAsignacionPista(AsignacionPista asignacion);
  
  Future<void> deleteAsignacionPista(int id);
}