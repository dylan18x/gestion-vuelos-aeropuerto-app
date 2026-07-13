// lib/data/repository/tripulacion_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/tripulacion.dart';
import '../../domain/repository/tripulacion_repository.dart';
import '../remote/api/tripulacion_remote_datasource.dart';

class TripulacionRepositoryImpl implements TripulacionRepository {
  final TripulacionRemoteDatasource _datasource;
  TripulacionRepositoryImpl(this._datasource);

  @override
  Future<List<Tripulacion>> getTripulacion() => _datasource.getTripulacion();

  @override
  Future<Tripulacion> getTripulante(int id) => _datasource.getTripulante(id);

  @override
  Future<Tripulacion> createTripulante(Map<String, dynamic> payload) =>
      _datasource.createTripulante(payload);

  @override
  Future<Tripulacion> updateTripulante(int id, Map<String, dynamic> payload) =>
      _datasource.updateTripulante(id, payload);

  @override
  Future<void> deleteTripulante(int id) => _datasource.deleteTripulante(id);
}

final tripulacionRepositoryProvider = Provider<TripulacionRepository>((ref) {
  return TripulacionRepositoryImpl(ref.watch(tripulacionDatasourceProvider));
});