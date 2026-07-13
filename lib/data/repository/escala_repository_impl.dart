// lib/data/repository/escala_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/escala.dart';
import '../../domain/repository/escala_repository.dart';
import '../remote/api/escala_remote_datasource.dart';

class EscalaRepositoryImpl implements EscalaRepository {
  final EscalaRemoteDatasource _datasource;
  EscalaRepositoryImpl(this._datasource);

  @override
  Future<List<Escala>> getEscalasByVuelo(int idVuelo) =>
      _datasource.getEscalasByVuelo(idVuelo);

  @override
  Future<Escala> createEscala(Map<String, dynamic> payload) =>
      _datasource.createEscala(payload);

  @override
  Future<void> deleteEscala(int id) => _datasource.deleteEscala(id);
}

final escalaRepositoryProvider = Provider<EscalaRepository>((ref) {
  return EscalaRepositoryImpl(ref.watch(escalaDatasourceProvider));
});