// lib/data/repository/estado_vuelo_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/estado_vuelo.dart';
import '../../domain/repository/estado_vuelo_repository.dart';
import '../remote/api/estado_vuelo_remote_datasource.dart';

class EstadoVueloRepositoryImpl implements EstadoVueloRepository {
  final EstadoVueloRemoteDatasource _ds;
  EstadoVueloRepositoryImpl(this._ds);

  @override Future<List<EstadoVuelo>> getEstadoVuelos() => _ds.getEstadoVuelos();
  @override Future<EstadoVuelo> getEstadoVuelo(int id) => _ds.getEstadoVuelo(id);
  @override Future<EstadoVuelo> createEstadoVuelo(Map<String, dynamic> p) => _ds.createEstadoVuelo(p);
  @override Future<EstadoVuelo> updateEstadoVuelo(int id, Map<String, dynamic> p) => _ds.updateEstadoVuelo(id, p);
  @override Future<void> deleteEstadoVuelo(int id) => _ds.deleteEstadoVuelo(id);
}

final estadoVueloRepositoryProvider = Provider<EstadoVueloRepository>((ref) =>
  EstadoVueloRepositoryImpl(ref.watch(estadoVueloDatasourceProvider)));
