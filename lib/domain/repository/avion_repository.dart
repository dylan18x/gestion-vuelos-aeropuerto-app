// lib/domain/repository/avion_repository.dart
import '../model/avion.dart';

abstract class AvionRepository {
  Future<List<Avion>> getAviones();
  Future<Avion> getAvion(int id);
  Future<Avion> createAvion(Map<String, dynamic> payload);
  Future<Avion> updateAvion(int id, Map<String, dynamic> payload);
  Future<void> deleteAvion(int id);
}
