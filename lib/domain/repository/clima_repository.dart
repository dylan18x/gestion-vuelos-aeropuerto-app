// lib/domain/repository/clima_repository.dart
import '../model/clima.dart';

abstract class ClimaRepository {
  Future<List<Clima>> getClimas();
  Future<Clima> getClima(int id);
  Future<Clima> createClima(Map<String, dynamic> payload);
  Future<Clima> updateClima(int id, Map<String, dynamic> payload);
  Future<void> deleteClima(int id);
}
