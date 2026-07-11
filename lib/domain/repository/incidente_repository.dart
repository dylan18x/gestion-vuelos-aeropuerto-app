// lib/domain/repository/incidente_repository.dart
import '../model/incidente.dart';

abstract class IncidenteRepository {
  Future<PaginatedIncidentes> getIncidentes({int? idVuelo});
  Future<Incidente> getIncidente(int id);
  Future<Incidente> createIncidente(Map<String, dynamic> payload);
  Future<Incidente> updateIncidente(int id, Map<String, dynamic> payload);
  Future<void> deleteIncidente(int id);
}