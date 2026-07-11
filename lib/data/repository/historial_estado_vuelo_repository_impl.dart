// lib/data/repository/historial_estado_vuelo_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/historial_estado_vuelo.dart';
import '../../domain/repository/historial_estado_vuelo_repository.dart';
import '../remote/api/historial_estado_vuelo_remote_datasource.dart';

class HistorialEstadoVueloRepositoryImpl implements HistorialEstadoVueloRepository {
  final HistorialEstadoVueloRemoteDatasource _datasource;
  HistorialEstadoVueloRepositoryImpl(this._datasource);

  @override
  Future<List<HistorialEstadoVuelo>> getHistorialByVuelo(int idVuelo) =>
      _datasource.getHistorialByVuelo(idVuelo);

  @override
  Future<HistorialEstadoVuelo> registrarCambioEstado(Map<String, dynamic> payload) =>
      _datasource.registrarCambioEstado(payload);
}

final historialEstadoVueloRepositoryProvider =
    Provider<HistorialEstadoVueloRepository>((ref) {
  return HistorialEstadoVueloRepositoryImpl(
    ref.watch(historialEstadoVueloDatasourceProvider),
  );
});