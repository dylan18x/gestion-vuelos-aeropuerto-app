// lib/domain/repository/escala_repository.dart
import '../model/escala.dart';

abstract class EscalaRepository {
  Future<List<Escala>> getEscalasByVuelo(int idVuelo);
  Future<Escala>        createEscala(Map<String, dynamic> payload);
  Future<void>           deleteEscala(int id);
}