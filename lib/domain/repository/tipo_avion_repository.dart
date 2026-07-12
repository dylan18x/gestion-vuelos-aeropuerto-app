// lib/domain/repository/tipo_avion_repository.dart
import '../model/tipo_avion.dart';

abstract class TipoAvionRepository {
  Future<List<TipoAvion>> getTiposAvion();
  Future<TipoAvion> getTipoAvion(int id);
  Future<TipoAvion> createTipoAvion(Map<String, dynamic> payload);
  Future<TipoAvion> updateTipoAvion(int id, Map<String, dynamic> payload);
  Future<void> deleteTipoAvion(int id);
}
