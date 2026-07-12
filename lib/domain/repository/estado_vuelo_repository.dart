// lib/domain/repository/estado_vuelo_repository.dart
import '../model/estado_vuelo.dart';

abstract class EstadoVueloRepository {
  Future<List<EstadoVuelo>> getEstadoVuelos();
  Future<EstadoVuelo> getEstadoVuelo(int id);
  Future<EstadoVuelo> createEstadoVuelo(Map<String, dynamic> payload);
  Future<EstadoVuelo> updateEstadoVuelo(int id, Map<String, dynamic> payload);
  Future<void> deleteEstadoVuelo(int id);
}
