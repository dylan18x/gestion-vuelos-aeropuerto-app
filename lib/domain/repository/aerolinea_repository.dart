// lib/domain/repository/aerolinea_repository.dart
import '../model/aerolinea.dart';

abstract class AerolineaRepository {
  Future<List<Aerolinea>> getAerolineas();
  Future<Aerolinea> getAerolinea(int id);
  Future<Aerolinea> createAerolinea(Map<String, dynamic> payload);
  Future<Aerolinea> updateAerolinea(int id, Map<String, dynamic> payload);
  Future<void> deleteAerolinea(int id);
}
