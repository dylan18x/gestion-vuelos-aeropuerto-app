// lib/domain/repository/autorizacion_vuelo_repository.dart
import '../model/autorizacion_vuelo.dart';

abstract class AutorizacionVueloRepository {
<<<<<<< HEAD
  Future<List<AutorizacionVuelo>> getAllAutorizaciones();
  
  Future<AutorizacionVuelo> getAutorizacionById(int id);
  
  Future<void> createAutorizacion(AutorizacionVuelo autorizacion);
  
  Future<void> updateAutorizacion(AutorizacionVuelo autorizacion);
  
  Future<void> deleteAutorizacion(int id);
=======
  Future<List<AutorizacionVuelo>> getAllAutorizacionesVuelo();
  Future<AutorizacionVuelo> getAutorizacionVueloById(int id);
  Future<void> createAutorizacionVuelo(AutorizacionVuelo autorizacion);
  Future<void> updateAutorizacionVuelo(AutorizacionVuelo autorizacion);
  Future<void> deleteAutorizacionVuelo(int id);
>>>>>>> 9c93e9e349b58cd690bce44268335422b70f5c53
}