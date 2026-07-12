// lib/domain/repository/aeropuerto_repository.dart
import '../model/aeropuerto.dart';

abstract class AeropuertoRepository {
  Future<List<Aeropuerto>> getAeropuertos();
  Future<Aeropuerto> getAeropuerto(int id);
  Future<Aeropuerto> createAeropuerto(Map<String, dynamic> payload);
  Future<Aeropuerto> updateAeropuerto(int id, Map<String, dynamic> payload);
  Future<void> deleteAeropuerto(int id);
}
