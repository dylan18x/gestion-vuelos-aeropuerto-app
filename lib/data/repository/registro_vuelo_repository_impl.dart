// lib/data/repository/registro_vuelo_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/registro_vuelo.dart';
import '../../domain/repository/registro_vuelo_repository.dart';
import '../remote/api/registro_vuelo_remote_datasource.dart';

class RegistroVueloRepositoryImpl implements RegistroVueloRepository {
  final RegistroVueloRemoteDatasource _datasource;
  RegistroVueloRepositoryImpl(this._datasource);

  @override
  Future<PaginatedRegistrosVuelo> getRegistrosVuelo({int? idVuelo}) =>
      _datasource.getRegistrosVuelo(idVuelo: idVuelo);

  @override
  Future<RegistroVuelo> getRegistroVuelo(int id) => _datasource.getRegistroVuelo(id);

  @override
  Future<RegistroVuelo> createRegistroVuelo(Map<String, dynamic> payload) =>
      _datasource.createRegistroVuelo(payload);

  @override
  Future<RegistroVuelo> updateRegistroVuelo(int id, Map<String, dynamic> payload) =>
      _datasource.updateRegistroVuelo(id, payload);

  @override
  Future<void> deleteRegistroVuelo(int id) => _datasource.deleteRegistroVuelo(id);
}

final registroVueloRepositoryProvider = Provider<RegistroVueloRepository>((ref) {
  return RegistroVueloRepositoryImpl(ref.watch(registroVueloDatasourceProvider));
});