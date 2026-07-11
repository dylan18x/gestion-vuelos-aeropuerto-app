// lib/data/repository/piloto_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/piloto.dart';
import '../../domain/repository/piloto_repository.dart';
import '../remote/api/piloto_remote_datasource.dart';

class PilotoRepositoryImpl implements PilotoRepository {
  final PilotoRemoteDatasource _datasource;
  PilotoRepositoryImpl(this._datasource);

  @override
  Future<List<Piloto>> getPilotos() => _datasource.getPilotos();

  @override
  Future<Piloto> getPiloto(int id) => _datasource.getPiloto(id);

  @override
  Future<Piloto> createPiloto(Map<String, dynamic> payload) =>
      _datasource.createPiloto(payload);

  @override
  Future<Piloto> updatePiloto(int id, Map<String, dynamic> payload) =>
      _datasource.updatePiloto(id, payload);

  @override
  Future<void> deletePiloto(int id) => _datasource.deletePiloto(id);
}

final pilotoRepositoryProvider = Provider<PilotoRepository>((ref) {
  return PilotoRepositoryImpl(ref.watch(pilotoDatasourceProvider));
});