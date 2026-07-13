// lib/data/repository/asignacion_tripulacion_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/asignacion_tripulacion.dart';
import '../../domain/repository/asignacion_tripulacion_repository.dart';
import '../remote/api/asignacion_tripulacion_remote_datasource.dart';

class AsignacionTripulacionRepositoryImpl implements AsignacionTripulacionRepository {
  final AsignacionTripulacionRemoteDatasource _datasource;
  AsignacionTripulacionRepositoryImpl(this._datasource);

  @override
  Future<List<AsignacionTripulacion>> getAllAsignacionesTripulacion() => _datasource.getAsignaciones();

  @override
  Future<AsignacionTripulacion> getAsignacionTripulacionById(int id) => _datasource.getAsignacion(id);

  @override
  Future<void> createAsignacionTripulacion(AsignacionTripulacion asignacion) {
    // No mandamos id_asignacion al crear: el backend lo asigna.
    final payload = asignacion.toJson()..remove('id_asignacion');
    return _datasource.createAsignacion(payload);
  }

  @override
  Future<void> updateAsignacionTripulacion(AsignacionTripulacion asignacion) =>
      _datasource.updateAsignacion(asignacion.idAsignacion, asignacion.toJson());

  @override
  Future<void> deleteAsignacionTripulacion(int id) => _datasource.deleteAsignacion(id);
}

final asignacionTripulacionRepositoryProvider = Provider<AsignacionTripulacionRepository>((ref) {
  return AsignacionTripulacionRepositoryImpl(ref.watch(asignacionTripulacionDatasourceProvider));
});