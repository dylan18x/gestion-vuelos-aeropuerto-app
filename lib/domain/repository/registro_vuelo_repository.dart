// lib/domain/repository/registro_vuelo_repository.dart
import '../model/registro_vuelo.dart';

abstract class RegistroVueloRepository {
  Future<PaginatedRegistrosVuelo> getRegistrosVuelo({int? idVuelo});
  Future<RegistroVuelo> getRegistroVuelo(int id);
  Future<RegistroVuelo> createRegistroVuelo(Map<String, dynamic> payload);
  Future<RegistroVuelo> updateRegistroVuelo(int id, Map<String, dynamic> payload);
  Future<void> deleteRegistroVuelo(int id);
}