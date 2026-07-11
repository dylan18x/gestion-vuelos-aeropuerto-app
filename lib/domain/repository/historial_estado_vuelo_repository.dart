// lib/domain/repository/historial_estado_vuelo_repository.dart
import '../model/historial_estado_vuelo.dart';

abstract class HistorialEstadoVueloRepository {
  Future<List<HistorialEstadoVuelo>> getHistorialByVuelo(int idVuelo);
  Future<HistorialEstadoVuelo>        registrarCambioEstado(Map<String, dynamic> payload);
}