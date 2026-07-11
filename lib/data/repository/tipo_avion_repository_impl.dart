// lib/data/repository/tipo_avion_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/tipo_avion.dart';
import '../../domain/repository/tipo_avion_repository.dart';
import '../remote/api/tipo_avion_remote_datasource.dart';

class TipoAvionRepositoryImpl implements TipoAvionRepository {
  final TipoAvionRemoteDatasource _ds;
  TipoAvionRepositoryImpl(this._ds);

  @override Future<List<TipoAvion>> getTiposAvion() => _ds.getTiposAvion();
  @override Future<TipoAvion> getTipoAvion(int id) => _ds.getTipoAvion(id);
  @override Future<TipoAvion> createTipoAvion(Map<String, dynamic> p) => _ds.createTipoAvion(p);
  @override Future<TipoAvion> updateTipoAvion(int id, Map<String, dynamic> p) => _ds.updateTipoAvion(id, p);
  @override Future<void> deleteTipoAvion(int id) => _ds.deleteTipoAvion(id);
}

final tipoAvionRepositoryProvider = Provider<TipoAvionRepository>((ref) =>
  TipoAvionRepositoryImpl(ref.watch(tipoAvionDatasourceProvider)));
