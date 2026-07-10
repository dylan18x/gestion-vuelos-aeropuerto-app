// lib/domain/repository/tripulacion_repository.dart
import '../model/tripulacion.dart';

abstract class TripulacionRepository {
  Future<List<Tripulacion>> getTripulacion();
  Future<Tripulacion>        getTripulante(int id);
  Future<Tripulacion>        createTripulante(Map<String, dynamic> payload);
  Future<Tripulacion>        updateTripulante(int id, Map<String, dynamic> payload);
  Future<void>                 deleteTripulante(int id); // solo ADMIN
}