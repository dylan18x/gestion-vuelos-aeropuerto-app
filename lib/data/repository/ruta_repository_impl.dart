// lib/data/repository/ruta_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/ruta.dart';
import '../../domain/repository/ruta_repository.dart';
import '../remote/api/ruta_remote_datasource.dart';

class RutaRepositoryImpl implements RutaRepository {
  final RutaRemoteDatasource _datasource;
  RutaRepositoryImpl(this._datasource);

  @override
  Future<List<Ruta>> getRutas() => _datasource.getRutas();

  @override
  Future<Ruta> getRuta(int id) => _datasource.getRuta(id);

  @override
  Future<Ruta> createRuta(Map<String, dynamic> payload) =>
      _datasource.createRuta(payload);

  @override
  Future<Ruta> updateRuta(int id, Map<String, dynamic> payload) =>
      _datasource.updateRuta(id, payload);

  @override
  Future<void> deleteRuta(int id) => _datasource.deleteRuta(id);
}

final rutaRepositoryProvider = Provider<RutaRepository>((ref) {
  return RutaRepositoryImpl(ref.watch(rutaDatasourceProvider));
});