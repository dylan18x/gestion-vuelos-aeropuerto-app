// lib/data/repository/clima_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/clima.dart';
import '../../domain/repository/clima_repository.dart';
import '../remote/api/clima_remote_datasource.dart';

class ClimaRepositoryImpl implements ClimaRepository {
  final ClimaRemoteDatasource _ds;
  ClimaRepositoryImpl(this._ds);

  @override Future<List<Clima>> getClimas() => _ds.getClimas();
  @override Future<Clima> getClima(int id) => _ds.getClima(id);
  @override Future<Clima> createClima(Map<String, dynamic> p) => _ds.createClima(p);
  @override Future<Clima> updateClima(int id, Map<String, dynamic> p) => _ds.updateClima(id, p);
  @override Future<void> deleteClima(int id) => _ds.deleteClima(id);
}

final climaRepositoryProvider = Provider<ClimaRepository>((ref) =>
  ClimaRepositoryImpl(ref.watch(climaDatasourceProvider)));
