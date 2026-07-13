// lib/domain/repository/autorizacion_vuelo_repository.dart
import '../model/autorizacion_vuelo.dart';

abstract class AutorizacionVueloRepository {
  Future<List<AutorizacionVuelo>> getAllAutorizacionesVuelo();
  Future<AutorizacionVuelo> getAutorizacionVueloById(int id);
  Future<void> createAutorizacionVuelo(AutorizacionVuelo autorizacion);
  Future<void> updateAutorizacionVuelo(AutorizacionVuelo autorizacion);
  Future<void> deleteAutorizacionVuelo(int id);
}