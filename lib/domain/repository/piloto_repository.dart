// lib/domain/repository/piloto_repository.dart
import '../model/piloto.dart';

abstract class PilotoRepository {
  Future<List<Piloto>> getPilotos();
  Future<Piloto>        getPiloto(int id);
  Future<Piloto>        createPiloto(Map<String, dynamic> payload);
  Future<Piloto>        updatePiloto(int id, Map<String, dynamic> payload);
  Future<void>            deletePiloto(int id); // solo ADMIN
}