// lib/data/repository/avion_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/avion.dart';
import '../../domain/repository/avion_repository.dart';
import '../remote/api/avion_remote_datasource.dart';

class AvionRepositoryImpl implements AvionRepository {
  final AvionRemoteDatasource _ds;
  AvionRepositoryImpl(this._ds);

  @override Future<List<Avion>> getAviones() => _ds.getAviones();
  @override Future<Avion> getAvion(int id) => _ds.getAvion(id);
  @override Future<Avion> createAvion(Map<String, dynamic> p) => _ds.createAvion(p);
  @override Future<Avion> updateAvion(int id, Map<String, dynamic> p) => _ds.updateAvion(id, p);
  @override Future<void> deleteAvion(int id) => _ds.deleteAvion(id);
}

final avionRepositoryProvider = Provider<AvionRepository>((ref) =>
  AvionRepositoryImpl(ref.watch(avionDatasourceProvider)));
