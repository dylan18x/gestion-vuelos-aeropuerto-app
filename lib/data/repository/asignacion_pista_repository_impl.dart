// lib/data/repository/asignacion_pista_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/asignacion_pista.dart';
import '../../domain/repository/asignacion_pista_repository.dart';
import '../remote/api/asignacion_pista_remote_datasource.dart';

class AsignacionPistaRepositoryImpl implements AsignacionPistaRepository {
  final AsignacionPistaRemoteDatasource _datasource;
  AsignacionPistaRepositoryImpl(this._datasource);

  @override
  Future<List<AsignacionPista>> getAllAsignacionesPista() => _datasource.getAsignacionesPista();

  @override
  Future<AsignacionPista> getAsignacionPistaById(int id) => _datasource.getAsignacionPista(id);

  @override
  Future<void> createAsignacionPista(AsignacionPista asignacion) {
    // No mandamos id_asignacion_pista al crear: el backend lo asigna.
    final payload = asignacion.toJson()..remove('id_asignacion_pista');
    return _datasource.createAsignacionPista(payload);
  }

  @override
  Future<void> updateAsignacionPista(AsignacionPista asignacion) =>
      _datasource.updateAsignacionPista(asignacion.idAsignacionPista, asignacion.toJson());

  @override
  Future<void> deleteAsignacionPista(int id) => _datasource.deleteAsignacionPista(id);
}

// ÚNICA definición de este provider en todo el proyecto.
final asignacionPistaRepositoryProvider = Provider<AsignacionPistaRepository>((ref) {
  return AsignacionPistaRepositoryImpl(ref.watch(asignacionPistaDatasourceProvider));
});