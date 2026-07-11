// lib/data/repository/incidente_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/incidente.dart';
import '../../domain/repository/incidente_repository.dart';
import '../remote/api/incidente_remote_datasource.dart';

class IncidenteRepositoryImpl implements IncidenteRepository {
  final IncidenteRemoteDatasource _datasource;
  IncidenteRepositoryImpl(this._datasource);

  @override
  Future<PaginatedIncidentes> getIncidentes({int? idVuelo}) =>
      _datasource.getIncidentes(idVuelo: idVuelo);

  @override
  Future<Incidente> getIncidente(int id) => _datasource.getIncidente(id);

  @override
  Future<Incidente> createIncidente(Map<String, dynamic> payload) =>
      _datasource.createIncidente(payload);

  @override
  Future<Incidente> updateIncidente(int id, Map<String, dynamic> payload) =>
      _datasource.updateIncidente(id, payload);

  @override
  Future<void> deleteIncidente(int id) => _datasource.deleteIncidente(id);
}

final incidenteRepositoryProvider = Provider<IncidenteRepository>((ref) {
  return IncidenteRepositoryImpl(ref.watch(incidenteDatasourceProvider));
});