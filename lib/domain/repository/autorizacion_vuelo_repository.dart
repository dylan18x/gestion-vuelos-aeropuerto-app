// lib/domain/repository/autorizacion_vuelo_repository.dart
import '../model/autorizacion_vuelo.dart';

abstract class AutorizacionVueloRepository {
  Future<List<AutorizacionVuelo>> getAllAutorizaciones();
  
  Future<AutorizacionVuelo> getAutorizacionById(int id);
  
  Future<void> createAutorizacion(AutorizacionVuelo autorizacion);
  
  Future<void> updateAutorizacion(AutorizacionVuelo autorizacion);
  
  Future<void> deleteAutorizacion(int id);
}