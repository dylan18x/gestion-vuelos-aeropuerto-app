// lib/domain/repository/vuelo_repository.dart
import '../model/vuelo.dart';

abstract class VueloRepository {
  Future<PaginatedVuelos> getVuelos({String? estado});
  Future<Vuelo>           getVuelo(int id);
  Future<Vuelo>           createVuelo(Map<String, dynamic> payload);
  Future<Vuelo>           updateVuelo(int id, Map<String, dynamic> payload);
  Future<void>            deleteVuelo(int id); // solo ADMIN
  Future<Vuelo>           assignAvion(int idVuelo, int idAvion); // solo TECNICO/ADMIN
}