// lib/data/repository/control_trafico_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/control_trafico.dart';
import '../../domain/repository/control_trafico_repository.dart';
import '../remote/api/control_trafico_remote_datasource.dart';

class ControlTraficoRepositoryImpl implements ControlTraficoRepository {
  final ControlTraficoRemoteDatasource _datasource;
  ControlTraficoRepositoryImpl(this._datasource);

  @override
  Future<PaginatedControlesTrafico> getControlesTrafico({int? idVuelo}) =>
      _datasource.getControlesTrafico(idVuelo: idVuelo);

  @override
  Future<ControlTrafico> getControlTrafico(int id) => _datasource.getControlTrafico(id);

  @override
  Future<ControlTrafico> createControlTrafico(Map<String, dynamic> payload) =>
      _datasource.createControlTrafico(payload);

  @override
  Future<ControlTrafico> updateControlTrafico(int id, Map<String, dynamic> payload) =>
      _datasource.updateControlTrafico(id, payload);

  @override
  Future<void> deleteControlTrafico(int id) => _datasource.deleteControlTrafico(id);
}

final controlTraficoRepositoryProvider = Provider<ControlTraficoRepository>((ref) {
  return ControlTraficoRepositoryImpl(ref.watch(controlTraficoDatasourceProvider));
});