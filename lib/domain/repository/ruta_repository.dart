// lib/domain/repository/ruta_repository.dart
import '../model/ruta.dart';

abstract class RutaRepository {
  Future<List<Ruta>> getRutas();
  Future<Ruta>        getRuta(int id);
  Future<Ruta>        createRuta(Map<String, dynamic> payload);
  Future<Ruta>        updateRuta(int id, Map<String, dynamic> payload);
  Future<void>         deleteRuta(int id);
}