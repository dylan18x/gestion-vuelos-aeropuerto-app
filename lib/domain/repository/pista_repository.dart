// lib/domain/repository/pista_repository.dart
import '../model/pista.dart';

abstract class PistaRepository {
  Future<List<Pista>> getAllPistas();
  Future<Pista> getPistaById(int id);
  Future<void> createPista(Pista pista);
  Future<void> updatePista(Pista pista);
  Future<void> deletePista(int id);
}