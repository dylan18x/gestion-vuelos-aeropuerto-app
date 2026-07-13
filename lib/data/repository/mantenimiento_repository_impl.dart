// lib/data/repository/mantenimiento_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/mantenimiento.dart';
import '../../domain/repository/mantenimiento_repository.dart';
import '../remote/api/mantenimiento_remote_datasource.dart';

class MantenimientoRepositoryImpl implements MantenimientoRepository {
  final MantenimientoRemoteDatasource _ds;
  MantenimientoRepositoryImpl(this._ds);

  @override Future<List<Mantenimiento>> getMantenimientos() => _ds.getMantenimientos();
  @override Future<Mantenimiento> getMantenimiento(int id) => _ds.getMantenimiento(id);
  @override Future<Mantenimiento> createMantenimiento(Map<String, dynamic> p) => _ds.createMantenimiento(p);
  @override Future<Mantenimiento> updateMantenimiento(int id, Map<String, dynamic> p) => _ds.updateMantenimiento(id, p);
  @override Future<void> deleteMantenimiento(int id) => _ds.deleteMantenimiento(id);
}

final mantenimientoRepositoryProvider = Provider<MantenimientoRepository>((ref) =>
  MantenimientoRepositoryImpl(ref.watch(mantenimientoDatasourceProvider)));
