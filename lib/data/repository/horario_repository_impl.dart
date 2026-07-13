// lib/data/repository/horario_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/horario.dart';
import '../../domain/repository/horario_repository.dart';
import '../remote/api/horario_remote_datasource.dart';

class HorarioRepositoryImpl implements HorarioRepository {
  final HorarioRemoteDatasource _datasource;
  HorarioRepositoryImpl(this._datasource);

  @override
  Future<Horario?> getHorarioByVuelo(int idVuelo) =>
      _datasource.getHorarioByVuelo(idVuelo);

  @override
  Future<Horario> createHorario(Map<String, dynamic> payload) =>
      _datasource.createHorario(payload);

  @override
  Future<Horario> updateHorario(int id, Map<String, dynamic> payload) =>
      _datasource.updateHorario(id, payload);

  @override
  Future<void> deleteHorario(int id) => _datasource.deleteHorario(id);
}

final horarioRepositoryProvider = Provider<HorarioRepository>((ref) {
  return HorarioRepositoryImpl(ref.watch(horarioDatasourceProvider));
});