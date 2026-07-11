// lib/domain/repository/puerta_embarque_repository.dart
import '../model/puerta_embarque.dart';

abstract class PuertaEmbarqueRepository {
  Future<List<PuertaEmbarque>> getPuertas();
  Future<PuertaEmbarque> getPuerta(int id);
  Future<PuertaEmbarque> createPuerta(Map<String, dynamic> payload);
  Future<PuertaEmbarque> updatePuerta(int id, Map<String, dynamic> payload);
  Future<void> deletePuerta(int id);
}
