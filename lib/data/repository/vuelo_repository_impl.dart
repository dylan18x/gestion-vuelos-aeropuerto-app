// lib/data/repository/vuelo_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/vuelo.dart';
import '../../domain/repository/vuelo_repository.dart';
import '../remote/api/vuelo_remote_datasource.dart';

class VueloRepositoryImpl implements VueloRepository {
  final VueloRemoteDatasource _datasource;
  VueloRepositoryImpl(this._datasource);

  @override
  Future<PaginatedVuelos> getVuelos({String? estado}) =>
      _datasource.getVuelos(estado: estado);

  @override
  Future<Vuelo> getVuelo(int id) => _datasource.getVuelo(id);

  @override
  Future<Vuelo> createVuelo(Map<String, dynamic> payload) =>
      _datasource.createVuelo(payload);

  @override
  Future<Vuelo> updateVuelo(int id, Map<String, dynamic> payload) =>
      _datasource.updateVuelo(id, payload);

  @override
  Future<void> deleteVuelo(int id) => _datasource.deleteVuelo(id);

  @override
  Future<Vuelo> assignAvion(int idVuelo, int idAvion) =>
      _datasource.assignAvion(idVuelo, idAvion);
}

final vueloRepositoryProvider = Provider<VueloRepository>((ref) {
  return VueloRepositoryImpl(ref.watch(vueloDatasourceProvider));
});